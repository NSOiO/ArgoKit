//
//  Node.m
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/14.
//

#import "ArgoKitNode.h"
#import <objc/runtime.h>
#import "yoga/Yoga.h"
#import "ArgoKitLayoutHelper.h"
#import "ArgoKitUtils.h"
#import "ArgoKitNodeViewModifier.h"
#import "ArgoKitNode+Frame.h"
#import "ArgoKitNode+Observer.h"
#import "ArgoKitDictionary.h"
#if __has_include(<ArgoAnimation/UIView+AKFrame.h>)
#import <ArgoAnimation/UIView+AKFrame.h>
#else
#import "UIView+AKFrame.h"
#endif


@implementation NodeAction
- (instancetype)initWithAction:(ArgoKitNodeBlock)action controlEvents:(UIControlEvents)controlEvents{
    if (self = [super init]) {
        _actionBlock = action;
        _controlEvents = controlEvents;
    }
    return self;
}
@end

@implementation ViewAttribute : NSObject
- (instancetype)initWithSelector:(SEL)selector paramter:(NSArray<id> *)paramter{
    self = [super init];
    if(self){
        _selector = selector;
        _paramter = paramter;
    }
    return self;
}
@end




@class ArgoKitLayout;
@interface ArgoKitNode()

@property(nonatomic,weak,nullable)UIView *view;
// 布局layout
@property (nonatomic, strong) ArgoKitLayout *layout;
// 子node
@property (nonatomic, strong,nullable)  NSMutableArray<ArgoKitNode *> *childs;
@property (nonatomic,copy) ArgoKitNodeBlock actionBlock;

@property (nonatomic,assign)BOOL isUIView;
@property (nonatomic, assign) BOOL isReused;

//存储View属性
@property (nonatomic, strong,nullable)NSMutableDictionary<NSString*, ViewAttribute *>* viewAttributes;
//action 相关
@property (nonatomic,strong)NSMutableDictionary<NSString *,ArgoKitNodeBlock> *actionMap;
@property (nonatomic,strong)NSMutableArray<NodeAction *> *nodeActions;


@property(nonatomic,strong)NSHashTable<ArgoKitNodeObserver *> *nodeObservers;
@end


static YGConfigRef globalConfig;
@interface ArgoKitLayout: NSObject
@property (nonatomic, assign, readonly) YGNodeRef ygnode;
@property (nonatomic, weak, readonly) ArgoKitNode *argoNode;
- (instancetype)initWithNode:(ArgoKitNode *)node;
@end
@implementation ArgoKitLayout
+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        globalConfig = YGConfigNew();
        YGConfigSetExperimentalFeatureEnabled(globalConfig, YGExperimentalFeatureWebFlexBasis, true);
        YGConfigSetPointScaleFactor(globalConfig, [UIScreen mainScreen].scale);
    });
}
- (instancetype)initWithNode:(ArgoKitNode *)node
{
    self = [super init];
    if (self) {
        _argoNode = node;
        _ygnode= YGNodeNewWithConfig(globalConfig);
        YGNodeSetContext(_ygnode, (__bridge void *)node);
    }
    return self;
}
- (void)dealloc
{
  YGNodeFree(self.ygnode);
}

#pragma mark --- 完成数据采集后计算 ---
- (CGSize)applyLayoutWithsize:(CGSize)size
{
  CGSize result = [self calculateLayoutWithSize:size];
  YGApplyLayoutToNodeHierarchy(self.argoNode);
  return result;
}
- (void)applyLayoutAferCalculation{
    YGApplyLayoutToNodeHierarchy(self.argoNode);
}
- (void)applyLayoutAferCalculationWithView:(BOOL)withView{
    self.argoNode.isReused = !withView;
    YGApplyLayoutToNodeHierarchy(self.argoNode);
}
// 视图是否为叶子
- (BOOL)isLeaf{
    if (self.argoNode.childs.count == 0) {
        return YES;
    }
    if (self.argoNode.isEnabled) {
      for (ArgoKitNode *childNode in self.argoNode.childs) {
        ArgoKitLayout *const layout = childNode.layout;
        if (layout.argoNode.isEnabled) {
          return NO;
        }
      }
    }
    return YES;
}

- (CGSize)calculateLayoutWithSize:(CGSize)size
{
  NSAssert([NSThread isMainThread], @"Yoga calculation must be done on main.");
  NSAssert(self.argoNode.isEnabled, @"Yoga is not enabled for this view.");

  YGAttachNodesFromNodeHierachy(self.argoNode);

  const YGNodeRef node = self.ygnode;
  YGNodeCalculateLayout(
    node,
    size.width,
    size.height,
    YGNodeStyleGetDirection(node));

  return (CGSize) {
    .width = YGNodeLayoutGetWidth(node),
    .height = YGNodeLayoutGetHeight(node),
  };
}

- (BOOL)isDirty
{
  return YGNodeIsDirty(self.ygnode);
}

- (void)markDirty
{
  if (self.isDirty || !self.isLeaf) {
    return;
  }

  // Yoga is not happy if we try to mark a node as "dirty" before we have set
  // the measure function. Since we already know that this is a leaf,
  // this *should* be fine. Forgive me Hack Gods.
  const YGNodeRef node = self.ygnode;
  if (!YGNodeHasMeasureFunc(node)) {
    YGNodeSetMeasureFunc(node, YGMeasureView);
  }
  YGNodeMarkDirty(node);
}

- (NSUInteger)numberOfChildren
{
  return YGNodeGetChildCount(self.ygnode);
}

#pragma mark - Private
// 计算当前node
static void YGApplyLayoutToNodeHierarchy(ArgoKitNode *node)
{
    const ArgoKitLayout *layout = node.layout;
    YGNodeRef ygnode = layout.ygnode;
    if (!ygnode || isnan(YGNodeLayoutGetWidth(ygnode)) || isnan(YGNodeLayoutGetHeight(ygnode))) {
        return;
    }
    const CGPoint topLeft = {
        YGNodeLayoutGetLeft(ygnode),
        YGNodeLayoutGetTop(ygnode),
    };
    
    const CGPoint bottomRight = {
        topLeft.x + YGNodeLayoutGetWidth(ygnode),
        topLeft.y + YGNodeLayoutGetHeight(ygnode),
    };
    
    const CGPoint origin = node.resetOrigin ? CGPointZero:node.frame.origin;
    CGRect frame = (CGRect) {
        .origin = {
            .x = YGRoundPixelValue(topLeft.x + origin.x),
            .y = YGRoundPixelValue(topLeft.y + origin.y),
        },
        .size = {
            .width = YGRoundPixelValue(bottomRight.x) - YGRoundPixelValue(topLeft.x),
            .height = YGRoundPixelValue(bottomRight.y) - YGRoundPixelValue(topLeft.y),
        },
    };
    
    [node createNodeViewIfNeed:frame];
    if (!CGRectEqualToRect(node.frame, frame)) {
        node.frame = frame;
    }
    if (![layout isLeaf]) {
        for (NSUInteger i=0; i<node.childs.count; i++) {
            ArgoKitNode *chiledNode = node.childs[i];
            chiledNode.isReused = node.isReused;
            YGApplyLayoutToNodeHierarchy(node.childs[i]);
            chiledNode.isReused = NO;
        }
    }
    node.isReused = NO;
}

static CGFloat YGSanitizeMeasurement(
  CGFloat constrainedSize,
  CGFloat measuredSize,
  YGMeasureMode measureMode)
{
  CGFloat result;
  if (measureMode == YGMeasureModeExactly) {
    result = constrainedSize;
  } else if (measureMode == YGMeasureModeAtMost) {
    result = MIN(constrainedSize, measuredSize);
  } else {
    result = measuredSize;
  }
  return result;
}

static YGSize YGMeasureView(
  YGNodeRef node,
  float width,
  YGMeasureMode widthMode,
  float height,
  YGMeasureMode heightMode)
{
  const CGFloat constrainedWidth = (widthMode == YGMeasureModeUndefined) ? CGFLOAT_MAX : width;
  const CGFloat constrainedHeight = (heightMode == YGMeasureModeUndefined) ? CGFLOAT_MAX: height;
  ArgoKitNode *argoNode = (__bridge ArgoKitNode*) YGNodeGetContext(node);
  CGSize sizeThatFits = CGSizeZero;
  if (!argoNode.isUIView || [argoNode.childs count] > 0) {
    sizeThatFits = [argoNode sizeThatFits:(CGSize){
                                          .width = constrainedWidth,
                                          .height = constrainedHeight,
                                      }];
  }
  return (YGSize) {
      .width = static_cast<float>(YGSanitizeMeasurement(constrainedWidth, sizeThatFits.width, widthMode)),
      .height = static_cast<float>(YGSanitizeMeasurement(constrainedHeight, sizeThatFits.height, heightMode)),
  };
}

static void YGRemoveAllChildren(const YGNodeRef node)
{
  if (node == NULL) {
    return;
  }
  YGNodeRemoveAllChildren(node);
}
static BOOL YGNodeHasExactSameChildren(const YGNodeRef node, NSArray<ArgoKitNode *> *childs)
{
  if (YGNodeGetChildCount(node) != childs.count) {
    return NO;
  }
  for (int i=0; i<childs.count; i++) {
    if (YGNodeGetChild(node, i) != childs[i].layout.ygnode) {
      return NO;
    }
  }
  return YES;
}

static void YGAttachNodesFromNodeHierachy(ArgoKitNode *const argoNode)
{
  ArgoKitLayout * layout = argoNode.layout;
  const YGNodeRef node = layout.ygnode;

  if (layout.isLeaf) {
    YGRemoveAllChildren(node);
    YGNodeSetMeasureFunc(node, YGMeasureView);
  } else {
    YGNodeSetMeasureFunc(node, NULL);

    NSMutableArray<ArgoKitNode *> *childsToInclude = [[NSMutableArray alloc] initWithCapacity:argoNode.childs.count];
    for (ArgoKitNode *node in argoNode.childs) {
      if (node.isEnabled) {
          [childsToInclude addObject:node];
      }
    }
      
    if (!YGNodeHasExactSameChildren(node, childsToInclude)) {
      YGRemoveAllChildren(node);
      for (int i=0; i<childsToInclude.count; i++) {
        YGNodeInsertChild(node, childsToInclude[i].layout.ygnode, i);
      }
    }
    for (ArgoKitNode *const childNode in childsToInclude) {
        YGAttachNodesFromNodeHierachy(childNode);
    }
  }
}

static CGFloat YGRoundPixelValue(CGFloat value)
{
  static CGFloat scale;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^(){
    scale = [UIScreen mainScreen].scale;
  });
  return roundf(value * scale) / scale;
}

@end


@implementation ArgoKitNode
-(void)dealloc{
//    NSLog(@"dealloc");
}

- (instancetype)init {
    return [self initWithViewClass:[UIView class]];
}

- (instancetype)initWithView:(UIView *)view {
    self = [super init];
    if (self) {
        [self setUpNode:[view class]];
        _view = view;
        _size = view.bounds.size;
    }
    return self;
}

- (instancetype)initWithViewClass:(Class)viewClass{
    self = [super init];
    if (self) {
        [self setUpNode:viewClass];
    }
    return self;
}

- (NSString *)identifiable {
    if (!_identifiable) {
        _identifiable = [NSString stringWithFormat:@"%lud", (unsigned long)[self hash]];
    }
    return _identifiable;
}

- (void)setUpNode:(Class)viewClass {
    _viewClass = viewClass;
    _resetOrigin = YES;
    _isEnabled = YES;
    _isUIView = [viewClass isMemberOfClass:[UIView class]];
    _bindProperties = [NSMutableDictionary new];
}

- (void)bindView:(UIView *)view {
    if (![view isKindOfClass:_viewClass]) {
        return;
    }
    [self linkView:view];
    if (_childs.count) {
        for (ArgoKitNode *child in _childs) {
            if (child.view) {
                [view addSubview:child.view];
            }
        }
    }
}

- (void)linkView:(UIView *)view {
    _view = view;
    _size = view.bounds.size;
    [self commitAttributes];
}

- (UIView *)createNodeViewWithFrame:(CGRect)frame {
    UIView *view = [self.viewClass new];
    view.akLayoutFrame = frame;
    return view;
}

- (void)createNodeViewIfNeed:(CGRect)frame {
    if (_isReused) {
        return;
    }
    __weak typeof(self)wealSelf = self;
    [ArgoKitUtils runMainThreadAsyncBlock:^{
        if (!wealSelf.view) {
            UIView *view = [wealSelf createNodeViewWithFrame:frame];
            [wealSelf linkView:view];
            NSArray *nodeObservers = [wealSelf.nodeObservers copy];
            for (ArgoKitNodeObserver *observer in nodeObservers) {
                if (observer.createViewBlock) {
                    observer.createViewBlock(wealSelf.view);
                }
            }
        }else if (!CGRectEqualToRect(frame, wealSelf.view.akLayoutFrame)) {
            wealSelf.view.akLayoutFrame = frame;
            if (!wealSelf.view.superview) {
                [wealSelf insertViewToParentNodeView];
            }
        }
    }];
}

- (void)commitAttributes {
    if (_viewAttributes.count) {
        [ArgoKitNodeViewModifier nodeViewAttributeWithNode:self attributes:[self nodeAllAttributeValue] markDirty:NO];
    }
    if (_nodeActions.count && [self.view isKindOfClass:[UIControl class]] && [self.view respondsToSelector:@selector(addTarget:action:forControlEvents:)]) {
        NSArray<NodeAction *> *copyActions = [self.nodeActions mutableCopy];
        for(NodeAction *action in copyActions){
            [self addTarget:self.view forControlEvents:action.controlEvents action:action.actionBlock];
        }
    }
    [self insertViewToParentNodeView];
}

- (void)insertViewToParentNodeView {
    if (!self.parentNode.view) {
        return;
    }
    NSInteger index = [self.parentNode.childs indexOfObject:self];
    if ([self.parentNode.view isMemberOfClass:[UIVisualEffectView class]]) {
        [((UIVisualEffectView *)self.parentNode.view).contentView insertSubview:self.view atIndex:index];
    }else{
        [self.parentNode.view insertSubview:self.view atIndex:index];
    }
}

#pragma mark --- property setter/getter ---
- (void)setFrame:(CGRect)frame{
    _frame = frame;
    _size = frame.size;
    
    [self sendFrameChanged:frame];
}

- (NSMutableArray<ArgoKitNode *> *)childs{
    if (!_childs) {
        _childs = [[NSMutableArray<ArgoKitNode *> alloc] init];
    }
    return _childs;
}

- (NSMutableDictionary<NSString *,ArgoKitNodeBlock> *)actionMap{
    if (!_actionMap) {
        _actionMap = [NSMutableDictionary new];
    }
    return _actionMap;
}
- (NSMutableDictionary<NSString *,ViewAttribute *> *)viewAttributes{
    if (!_viewAttributes) {
        _viewAttributes = [[NSMutableDictionary alloc] init];
    }
    return _viewAttributes;
}

-(ArgoKitLayout *)layout{
    if (!_layout) {
        _layout = [[ArgoKitLayout alloc] initWithNode:self];
    }
    return _layout;
}

- (NSMutableArray<NodeAction *> *)nodeActions{
    if (!_nodeActions) {
        _nodeActions = [NSMutableArray array];
    }
    return _nodeActions;
}
- (NSHashTable<ArgoKitNodeObserver *> *)nodeObservers{
    if (!_nodeObservers) {
        _nodeObservers = [NSHashTable weakObjectsHashTable];
    }
    return _nodeObservers;
}


#pragma mark --- Action ---
- (void)observeAction:(id)obj actionBlock:(ArgoKitNodeBlock)action{
    if (obj) {
        NSString *keyString = [@([obj hash]) stringValue];
        [self.actionMap setObject:[action copy] forKey:keyString];
    }
}

- (void)nodeAction:(id)sender {
    [self sendActionWithObj:sender paramter:nil];
}

- (id)sendActionWithObj:(id)obj paramter:(NSArray *)paramter {
    NSString *keyString = [@([obj hash]) stringValue];
    ArgoKitNodeBlock actionBlock = self.actionMap[keyString];
    if(actionBlock){
        return actionBlock(obj, paramter);
    }
    return nil;
}

- (void)addTarget:(id)target forControlEvents:(UIControlEvents)controlEvents action:(ArgoKitNodeBlock)action{
    if ([target respondsToSelector:@selector(addTarget:action:forControlEvents:)]) {
        [target addTarget:self action:@selector(nodeAction:) forControlEvents:controlEvents];
        [self observeAction:target actionBlock:action];
    }else if([target respondsToSelector:@selector(addTarget:action:)]){
        [target addTarget:self action:@selector(nodeAction:)];
        [self observeAction:target actionBlock:action];
    }
}

- (void)addAction:(ArgoKitNodeBlock)action forControlEvents:(UIControlEvents)controlEvents{
    NodeAction *action_ = [[NodeAction alloc] initWithAction:action controlEvents:controlEvents];
    [self.nodeActions addObject:action_];
}

@end

@implementation ArgoKitNode(LayoutNode)

- (BOOL)isRootNode{
    return self.parentNode == nil;
}
- (void)markDirty{
    [self.layout markDirty];
}
- (BOOL)isDirty{
    return [self.layout isDirty];
}

- (NSUInteger)numberOfChildren{
    return [self.layout numberOfChildren];
}

- (CGSize)sizeThatFits:(CGSize)size{
    if(self.view){
        return [self.view sizeThatFits:size];
    }
    return CGSizeZero;
}

- (CGSize)applyLayout{
    if (self.layout) {
        CGSize size = self.parentNode?CGSizeZero:self.size;
        self.size = [self applyLayout:size];
    }
    return self.size;
}

- (CGSize)applyLayout:(CGSize)size{
    if (self.layout) {
        [ArgoKitLayoutHelper addLayoutNode:self];
        self.size = [self.layout applyLayoutWithsize:size];
    }
    return self.size;
}

- (void)applyLayoutAferCalculationWithView:(BOOL)withView{
    if (self.layout) {
        [self.layout applyLayoutAferCalculationWithView:withView];
    }
}

- (CGSize)calculateLayoutWithSize:(CGSize)size{
    if (self.layout) {
        self.size = [self.layout calculateLayoutWithSize:size];
    }
    return self.size;
}
@end

@implementation ArgoKitNode(Hierarchy)
- (void)addChildNode:(ArgoKitNode *)node{
    if (!node) {
        return;
    }
    if ([self.childs containsObject:node]) {
        [node removeFromSuperNode];
    }
    node.parentNode = self;
    [self.childs addObject:node];
    if (node.view && self.view) {
        [self.view addSubview:node.view];
    }
    [self insertYGNode:node atIndex:YGNodeGetChildCount(self.layout.ygnode)];
}
- (void)addChildNodes:(NSArray<ArgoKitNode *> *)nodes {
    for (ArgoKitNode *node in nodes) {
        [self addChildNode:node];
    }
}
- (void)insertChildNode:(ArgoKitNode *)node atIndex:(NSInteger)index{
    if (!node) {
        return;
    }
    if ([self.childs containsObject:node]) {
        return;
    }
    [self.childs insertObject:node atIndex:index];
    [self insertYGNode:node atIndex:index];
    if (node.view) {
        [self.view insertSubview:node.view atIndex:index];
    }
}

- (void)insertYGNode:(ArgoKitNode *)node atIndex:(NSInteger)index{
    if (!node) return;
    if(!(YGNodeGetChild(self.layout.ygnode, (int)index) ==  node.layout.ygnode)){
        YGNodeSetMeasureFunc(self.layout.ygnode, NULL); // ensure the node being inserted no measure func
        YGNodeInsertChild(self.layout.ygnode, node.layout.ygnode, (const uint32_t)index);
    }
}


- (void)removeFromSuperNode{
    if(self.parentNode){
        [self.view removeFromSuperview];
        [self.parentNode.childs removeObject:self];
        YGNodeRemoveChild(self.parentNode.layout.ygnode, self.layout.ygnode);
        self.parentNode = nil;
    }
}
- (void)removeAllChildNodes {
    for (ArgoKitNode *child in _childs) {
        [child.view removeFromSuperview];
        child.parentNode = nil;
    }
    if (_childs.count) {
        [_childs removeAllObjects];
    }
    YGNodeRemoveAllChildren(self.layout.ygnode);
}

- (ArgoKitNode *)rootNode{
    ArgoKitNode *node = self;
    while (node.parentNode) {
        node = node.parentNode;
    }
    return node;
}

@end


@implementation ArgoKitNode(AttributeValue)

- (void)prepareForUse{
}

- (void)nodeAddViewAttribute:(ViewAttribute *)attribute{
    if (!attribute) {
        return;
    }
    NSString *selector_name;
    if (attribute.selector) {
        selector_name = @(sel_getName(attribute.selector));
    }
    ViewAttribute *oldattribute = self.viewAttributes[selector_name];
    if (![selector_name hasPrefix:@"set"]) {//不是set方法则排除在外
        selector_name = [NSString stringWithFormat:@"%@:%@",selector_name,@([attribute.paramter.firstObject hash])];
        [self.viewAttributes argokit_setObject:attribute forKey:selector_name];
    }else{
        if (oldattribute) {
            oldattribute.paramter = attribute.paramter;
        }else{
            [self.viewAttributes argokit_setObject:attribute forKey:selector_name];
        }
    }
}
- (nullable NSArray *)nodeAllAttributeValue{
    return [self.viewAttributes argokit_allValues];
}
- (nullable NSString *)text{
    return [self valueWithSelector:@selector(setText:)];
}
- (nullable NSAttributedString *)attributedText{
    return [self valueWithSelector:@selector(setAttributedText:)];
}
- (nullable UIFont *)font{
    return [self valueWithSelector:@selector(setFont:)];
}
- (nullable UIColor *)textColor{
    return [self valueWithSelector:@selector(setTextColor:)];
}
- (NSInteger)numberOfLines{
    id lines = [self valueWithSelector:@selector(setNumberOfLines:)];
    if ([lines isKindOfClass:[NSNumber class]]) {
        return [lines intValue];
    }
    return 1;
}

- (NSTextAlignment)textAlignment{
    id textAlignment = [self valueWithSelector:@selector(setTextAlignment:)];
    if ([textAlignment isKindOfClass:[NSNumber class]]) {
        return (NSTextAlignment)[textAlignment intValue];
    }
    return NSTextAlignmentLeft;
}
- (NSLineBreakMode)lineBreakMode{
    id breakMode = [self valueWithSelector:@selector(setLineBreakMode:)];
    if ([breakMode isKindOfClass:[NSNumber class]]) {
        return (NSLineBreakMode)[breakMode intValue];
    }
    return NSLineBreakByWordWrapping;
}
- (nullable UIImage *)image{
    return [self valueWithSelector:@selector(setImage:)];
}

- (nullable id)valueWithSelector:(SEL)selector{
    NSString *selector_name =  @(sel_getName(selector));
    ViewAttribute *attribute = self.viewAttributes[selector_name];
    if (attribute) {
        return attribute.paramter.firstObject;
    }
    return nil;
}

@end


