//
//  Node.m
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/14.
//

#import "ArgoKitNode.h"
#import <pthread.h>
#import <objc/runtime.h>
#import "yoga/Yoga.h"
#import "ArgoKitLayoutHelper.h"
#import "ArgoKitUtils.h"
#import "ArgoKitNodeViewModifier.h"
#import "ArgoKitNode+Frame.h"
#import "ArgoKitNode+Observer.h"
#import "ArgoKitDictionary.h"
#import "ArgoKitSafeMutableArray.h"
#if __has_include(<ArgoAnimation/UIView+AKFrame.h>)
#import <ArgoAnimation/UIView+AKFrame.h>
#else
#import "UIView+AKFrame.h"
#endif

#import "ArgoKitNodePrivateHeader.h"
#import "UIView+ArgoKit.h"

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
@property(nonatomic,strong,nullable)UIView *view;
// 布局layout
@property (nonatomic, strong) ArgoKitLayout *layout;
// 子node
@property (nonatomic, strong,nullable) ArgoKitSafeMutableArray *childs;
@property (nonatomic,copy) ArgoKitNodeBlock actionBlock;

@property (nonatomic,assign)BOOL isUIView;
@property (nonatomic, assign) BOOL isReused;

@property (nonatomic,strong)NSLock *lock;

//存储View属性
@property (strong,nullable)NSMutableDictionary<NSString*, ViewAttribute *>* viewAttributes;
//action 相关
@property (nonatomic,strong)NSMutableDictionary<NSString *,ArgoKitNodeBlock> *actionMap;

@property (nonatomic,strong)NSMutableArray<NodeAction *> *nodeActions;

@property(nonatomic,strong)NSHashTable<ArgoKitNodeObserver *> *nodeObservers;

@property(nonatomic,assign) bool viewOnFront;
@property(nonatomic,assign) bool viewOnBack;
@property(nonatomic,assign) NSInteger viewOnIndex;

@property(nonatomic,assign) BOOL completeDealloc;
@property(nonatomic,assign) BOOL completeDestroy;
@end

@interface NodeWrapper:NSObject
@property (nonatomic,weak)ArgoKitNode *node;
@end
@implementation NodeWrapper
- (instancetype)initWithNode:(ArgoKitNode *)node
{
    self = [super init];
    if (self) {
        self.node = node;
    }
    return self;
}
@end

static YGConfigRef globalConfig;

@interface ArgoKitLayout: NSObject
@property (nonatomic, assign, readonly) YGNodeRef ygnode;
@property (nonatomic, weak, readonly) ArgoKitNode *argoNode;
@property (nonatomic, strong, readonly) NodeWrapper *nodeWarpper;
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
        _nodeWarpper = [[NodeWrapper alloc] initWithNode:node];
        _argoNode = node;
        _ygnode= YGNodeNewWithConfig(globalConfig);
        YGNodeSetContext(_ygnode, (__bridge void *)_nodeWarpper);
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

- (BOOL)isLeaf{
    if (self.argoNode.childs.count == 0) {
        return YES;
    }
    if (self.argoNode.isEnabled) {
      NSArray *childs = [self.argoNode.childs copy];
      for (ArgoKitNode *childNode in childs) {
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
//  NSAssert([NSThread isMainThread], @"Yoga calculation must be done on main.");
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
    
    if (!CGRectEqualToRect(node.frame, frame)) {
        node.frame = frame;
    }
    [node createNodeViewIfNeed:frame];
    
    if (![layout isLeaf]) {
        for (NSUInteger i=0; i<node.childs.count; i++) {
            ArgoKitNode *chiledNode = [node.childs objectAtIndex:i];
            chiledNode.isReused = node.isReused;
            YGApplyLayoutToNodeHierarchy([node.childs objectAtIndex:i]);
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
  NodeWrapper *nodeWapper = (__bridge NodeWrapper*) YGNodeGetContext(node);
  ArgoKitNode *argoNode = nodeWapper.node;
  __block CGSize sizeThatFits = CGSizeZero;
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
    NSArray *childs = argoNode.childs;
    for (ArgoKitNode *node in childs) {
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
    [self _destroyProperties:YES];
}

- (void)destroyProperties {
    [self _destroyProperties:NO];
}

- (void)_destroyProperties:(BOOL)dealloc {
    if (dealloc) {
        if (!self.completeDealloc) {
            [self clearStrongRefrence];
            [self iterationRemoveActionMap:self.childs];
            self.completeDealloc = YES;
        }
    }else{
        if (!self.completeDestroy) {
            [self _clearStrongRefrence];
            [self iterationRemoveActionMap:self.childs];
            self.completeDestroy = YES;
        }

    }
}

- (void)iterationRemoveActionMap:(nullable NSArray<ArgoKitNode*> *)nodes{
    NSInteger nodeCount = nodes.count;
    for (int i = 0; i < nodeCount; i++) {
        ArgoKitNode *node = nodes[i];
        [node destroyProperties];
    }
}
- (void)clearStrongRefrence{
    [self _clearStrongRefrence];
}
- (void)_clearStrongRefrence{
    for (UIGestureRecognizer *gesture in self.view.gestureRecognizers) {
        [self.view removeGestureRecognizer:gesture];
    }
    [self.bindProperties argokit_removeAllObjects];
    [self.actionMap argokit_removeAllObjects];
    [self.nodeActions removeAllObjects];
}
- (void)initContent{
    _layout = [[ArgoKitLayout alloc] initWithNode:self];
    _lock = [[NSLock alloc] init];
    _childs = [[ArgoKitSafeMutableArray alloc] init];
    
    _viewAttributes = [[NSMutableDictionary alloc] init];
    [_viewAttributes setArgokit_lock:_lock];
    
    _bindProperties = [[NSMutableDictionary alloc] init];
    [_bindProperties setArgokit_lock:_lock];
    
    _actionMap = [[NSMutableDictionary alloc] init];
    [_actionMap setArgokit_lock:_lock];
    
    _nodeActions = [NSMutableArray array];
    
    _nodeObservers = [NSHashTable weakObjectsHashTable];

}

- (void)setUpNode:(Class)viewClass {
    _viewClass = viewClass;
    _resetOrigin = YES;
    _isEnabled = YES;
    _isUIView = [viewClass isMemberOfClass:[UIView class]];
    
    self.viewOnFront = NO;
    self.viewOnBack = NO;
    self.viewOnIndex = -1;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUpNode:[UIView class]];
        [self initContent];
    }
    return self;
}

- (instancetype)initWithView:(UIView *)view {
    self = [super init];
    if (self) {
        [self setUpNode:[view class]];
        _view = view;
        _size = view.bounds.size;
        [self initContent];
    }
    return self;
}

- (instancetype)initWithViewClass:(Class)viewClass{
    self = [super init];
    if (self) {
        [self setUpNode:viewClass];
        [self initContent];
    }
    return self;
}

- (NSString *)identifiable {
    if (!_identifiable) {
        _identifiable = [NSString stringWithFormat:@"%lud", (unsigned long)[self hash]];
    }
    return _identifiable;
}




- (nullable UIView *)nodeView{
    if (self.linkNode.view) {
        return self.linkNode.view;
    }
    return self.view;
}
- (void)bindView:(UIView *)view {
    if (![view isKindOfClass:self.viewClass]) {
        return;
    }
    [self linkView:view];
    if (self.childs.count) {
        NSMutableArray *childs = [self.childs copy];
        for (ArgoKitNode *child in childs) {
            if (child.view) {
                [view addSubview:child.view];
            }
        }
    }
}

- (void)linkView:(UIView *)view {
    [self linkView:view addAttributes:YES];
}
- (void)linkView:(UIView *)view addAttributes:(BOOL)add{
    _view = view;
    _size = view.bounds.size;
    if (add) {
        [ArgoKitNodeViewModifier commitAttributeValueToView:self reuseNode:self];
    }
    [self insertViewToParentNodeView];
}

- (UIView *)createNodeViewWithFrame:(CGRect)frame {
    UIView *view = [self.viewClass new];
    view.akLayoutFrame = frame;
    return view;
}

- (void)createNodeViewIfNeed:(CGRect)frame {
    [self _createNodeViewIfNeed:frame addAttributes:YES];
}
- (void)createNodeViewIfNeedWithoutAttributes:(CGRect)frame{
    [self _createNodeViewIfNeed:frame addAttributes:NO];
}

- (void)_createNodeViewIfNeed:(CGRect)frame addAttributes:(BOOL)add{
    if (_isReused) {
        return;
    }
    if (!self.view) {
        UIView *view = [self createNodeViewWithFrame:frame];
        [self linkView:view addAttributes:add];
        NSArray *nodeObservers = [self.nodeObservers copy];
        for (ArgoKitNodeObserver *observer in nodeObservers) {
            if (observer.createViewBlock) {
                observer.createViewBlock(self.view);
            }
        }
    }else if (!CGRectEqualToRect(frame, self.view.akLayoutFrame)) {
        self.view.akLayoutFrame = frame;
        if (!self.view.superview) {
            [self insertViewToParentNodeView];
        }
    }
    if (self.viewAliasName) {
        self.view.argokit_viewAliasName = self.viewAliasName;
    }
}


- (void)insertViewToParentNodeView {
    if (!self.parentNode.view) {
        return;
    }
    NSInteger index = [self.parentNode.childs indexOfObject:self];
    if ([self.parentNode.view isMemberOfClass:[UIVisualEffectView class]]) {
        if (self.viewOnFront) {
            [((UIVisualEffectView *)self.parentNode.view).contentView addSubview:self.view];
        }else{
            [((UIVisualEffectView *)self.parentNode.view).contentView insertSubview:self.view atIndex:index];
        }
        
        if (self.viewOnFront) {
            [((UIVisualEffectView *)self.parentNode.view).contentView addSubview:self.view];
        }else if (self.viewOnIndex > 0 && self.parentNode.view.subviews.count >= self.viewOnIndex) {
            [((UIVisualEffectView *)self.parentNode.view).contentView insertSubview:self.view atIndex:self.viewOnIndex];
        }else{
            [((UIVisualEffectView *)self.parentNode.view).contentView insertSubview:self.view atIndex:index];
        }
    }else{
        if (self.viewOnFront) {
            [self.parentNode.view addSubview:self.view];
        }else if (self.viewOnIndex > 0) {
            [self.parentNode.view insertSubview:self.view atIndex:self.viewOnIndex];
        }else{
            [self.parentNode.view insertSubview:self.view atIndex:index];
        }
    }
}

#pragma mark --- property setter/getter ---
- (void)setEnabled:(BOOL)isEnabled{
    _isEnabled = isEnabled;
//    [self markDirty];
}
- (void)setFrame:(CGRect)frame{
    _frame = frame;
    _size = frame.size;
    [self sendFrameChanged:frame];
}

#pragma mark --- Action ---
- (void)observeAction:(id)obj actionBlock:(ArgoKitNodeBlock)action{
    if (obj) {
        NSString *keyString = [@([obj hash]) stringValue];
        [self.actionMap argokit_setValue:[action copy] forKey:keyString];
    }
}

- (void)nodeAction:(id)sender {
    [self sendActionWithObj:sender paramter:nil];
}

- (id)sendActionWithObj:(id)obj paramter:(NSArray *)paramter {
    NSString *keyString = [@([obj hash]) stringValue];
    ArgoKitNodeBlock actionBlock = [self.actionMap argokit_getObjectForKey:keyString];
    if(actionBlock){
        id result = actionBlock(obj, paramter);
        return result;
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
        CGSize size =self.parentNode?CGSizeZero:CGSizeMake(self.size.width, NAN);
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
    }else{
        if (withView) {
            [self layoutToNodeView:self];
        }
    }
}
- (void)layoutToNodeView:(ArgoKitNode *)node
{
    node.isReused = NO;
    [node createNodeViewIfNeed:node.frame];
    if (node.isEnabled) {
        for (NSUInteger i=0; i<node.childs.count; i++) {
            ArgoKitNode *chiledNode = [node.childs objectAtIndex:i];
            YGApplyLayoutToNodeHierarchy([node.childs objectAtIndex:i]);
            [self layoutToNodeView:chiledNode];
        }
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

- (void)addChildNodes:(NSArray<ArgoKitNode *> *)nodes {
    for (ArgoKitNode *node in nodes) {
        [self addChildNode:node];
    }
}

- (void)addChildNode:(ArgoKitNode *)node{
    if (!node) {
        return;
    }
    if ([self.childs containsObject:node]) {
        [node removeFromSuperNode];
    }
    node.parentNode = self;
    [self.childs addObject:node];
    
    __weak typeof(self)weakSelf = self;
    [ArgoKitUtils runMainThreadAsyncBlock:^{
        if (node.view && weakSelf.view) {
            [weakSelf.view addSubview:node.view];
        }
    }];

}

- (void)insertChildNode:(ArgoKitNode *)node atIndex:(NSInteger)index{
    if (!node) {
        return;
    }
    if ([self.childs containsObject:node]) {
        return;
    }
    if (index > self.childs.count) {
        return;
    }
    node.parentNode = self;
    [self.childs insertObject:node atIndex:index];

    __weak typeof(self)weakSelf = self;
    [ArgoKitUtils runMainThreadAsyncBlock:^{
        if (node.view) {
            [weakSelf.view insertSubview:node.view atIndex:index];
        }
    }];
}


- (void)removeFromSuperNode{
    if(self.parentNode){
        self.isEnabled = NO;
        self.frame = CGRectZero;
        __weak typeof(self)weakSelf = self;
        [ArgoKitUtils runMainThreadAsyncBlock:^{
            [weakSelf.view removeFromSuperview];
            weakSelf.view = nil;
        }];
        [self.parentNode markDirty];
    }
}

- (void)removeAllChildNodes {
    if (self.childs.count) {
        NSArray *childs = [self.childs copy];
        for (ArgoKitNode *child in childs) {
            [ArgoKitUtils runMainThreadAsyncBlock:^{
                [child.view removeFromSuperview];
            }];
            child.parentNode = nil;
            child.isEnabled = NO;
        }
        [self.childs removeAllObjects];
    }
}

- (void)positonToFront{
    self.viewOnFront = YES;
    self.viewOnBack = NO;
    self.viewOnIndex = -1;
}
- (void)positonToBack{
    self.viewOnFront = NO;
    self.viewOnBack = YES;
    self.viewOnIndex = 0;
}
- (void)positonToIndex:(NSInteger)index{
    self.viewOnFront = NO;
    self.viewOnBack = NO;
    self.viewOnIndex = index;
}

- (ArgoKitNode *)rootNode{
    if (!_rootNode) {
        ArgoKitNode *node = self;
        while (node.parentNode) {
            node = node.parentNode;
        }
        _rootNode = node;
    }
    return _rootNode;
}

@end




@implementation ArgoKitNode(AttributeValue)
- (void)reuseNodeToView:(ArgoKitNode *)node view:(nullable UIView *)view{
    
}
- (void)prepareForUse:(UIView *)view{
}
- (void)addNodeViewAttribute:(ViewAttribute *)attribute{
    if (!attribute) {
        return;
    }
    NSString *selector_name;
    if (attribute.selector) {
        selector_name = @(sel_getName(attribute.selector));
    }
    ViewAttribute *oldattribute = [self.viewAttributes argokit_getObjectForKey:selector_name];
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


- (nullable NSArray<ViewAttribute *> *)nodeAllAttributeValue{
    NSArray *values = @[];
    values = [self.viewAttributes argokit_allValues];
    return values;
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
    ViewAttribute *attribute = [self.viewAttributes argokit_getObjectForKey:selector_name];
    if (attribute) {
        return attribute.paramter.firstObject;
    }
    return nil;
}

@end


