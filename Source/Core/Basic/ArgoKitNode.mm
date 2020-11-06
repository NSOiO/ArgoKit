//
//  Node.m
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/14.
//

#import "ArgoKitNode.h"
#import <objc/runtime.h>
#import "yoga/Yoga.h"
#import "ArgoLayoutHelper.h"
#import "ArgoKitUtils.h"
#import "ArgoKitNodeViewModifier.h"

@interface NodeAction:NSObject{
    int actionTag;
    ArgoKitNodeBlock action;
    UIControlEvents  events;
}
@property(nonatomic, copy) ArgoKitNodeBlock actionBlock;
@property(nonatomic, assign)  UIControlEvents  controlEvents;
- (instancetype)initWithAction:(ArgoKitNodeBlock)action controlEvents:(UIControlEvents)controlEvents;
@end

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
@property (nonatomic, strong,nullable)  NSMutableArray<ArgoKitNode *> *childs;
@property (nonatomic,copy) ArgoKitNodeBlock actionBlock;
@property (nonatomic,copy)NSMutableDictionary<NSString *,ArgoKitNodeBlock> *actionMap;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic,assign)BOOL isUIView;

@property (nonatomic,copy)NSMutableArray<NodeAction *> *nodeActions;
@end


static YGConfigRef globalConfig;
@interface ArgoKitLayout: NSObject
@property (nonatomic, assign, readonly) YGNodeRef ygnode;
@property (nonatomic, weak, readonly) ArgoKitNode *argoNode;
@property(nonatomic, assign, readonly) BOOL isBaseNode;
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
        YGNodeSetContext(_ygnode, (__bridge void *) node);
        _isBaseNode = [node isMemberOfClass:[ArgoKitNode class]];
    }
    return self;
}
- (void)dealloc
{
  YGNodeFree(self.ygnode);
}

#pragma mark --- 完成数据采集后计算 ---
- (void)applyLayoutWithsize:(CGSize)size
{
  [self calculateLayoutWithSize:size];
  YGApplyLayoutToNodeHierarchy(self.argoNode);
}

// 视图是否为
- (BOOL)isLeaf{
    NSAssert([NSThread isMainThread], @"This method must be called on the main thread.");
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

  const CGPoint origin = node.resetOrigin ? CGPointZero:node.origin;
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

  if (![layout isLeaf]) {
    for (NSUInteger i=0; i<node.childs.count; i++) {
        YGApplyLayoutToNodeHierarchy(node.childs[i]);
    }
  }
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

    NSMutableArray<ArgoKitNode *> *subviewsToInclude = [[NSMutableArray alloc] initWithCapacity:argoNode.childs.count];
    for (ArgoKitNode *node in argoNode.childs) {
      if (node.isEnabled) {
          [subviewsToInclude addObject:node];
      }
    }
      
    if (!YGNodeHasExactSameChildren(node, subviewsToInclude)) {
      YGRemoveAllChildren(node);
      for (int i=0; i<subviewsToInclude.count; i++) {
        YGNodeInsertChild(node, subviewsToInclude[i].layout.ygnode, i);
      }
    }
    for (ArgoKitNode *const childNode in subviewsToInclude) {
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
- (instancetype)initWithView:(UIView *)view{
    self = [super init];
    if (self) {
        _view = view;
        _viewClass = view.class;
        _resetOrigin = NO;
        _isEnabled = YES;
        _isUIView = [view isMemberOfClass:[UIView class]];
        _size = view.bounds.size;
        _frame = view.frame;
        _origin = _frame.origin;
        _bindProperties = [NSMutableDictionary new];
    }
    return self;
}

- (instancetype)initWithViewClass:(Class)viewClass{
    self = [super init];
    if (self) {
        _resetOrigin = NO;
        _isEnabled = YES;
        _isUIView = [viewClass isMemberOfClass:[UIView class]];
        _origin = _frame.origin;
        _bindProperties = [NSMutableDictionary new];
        _viewClass = viewClass;
    }
    return self;
}

#pragma mark --- property setter/getter ---
- (void)setFrame:(CGRect)frame{
    _frame = frame;
    __weak typeof(self)wealSelf = self;
    [ArgoKitUtils runMainThreadBlock:^{
        if (!wealSelf.view) {
            wealSelf.view = [wealSelf.viewClass new];
            wealSelf.view.frame = frame;
            [ArgoKitNodeViewModifier nodeViewAttributeWithNode:wealSelf attributes:wealSelf.viewAttributes];
            if ([wealSelf.view isKindOfClass:[UIControl class]] && [wealSelf.view respondsToSelector:@selector(addTarget:action:forControlEvents:)]) {
                NSArray<NodeAction *> *copyActions = [wealSelf.nodeActions mutableCopy];
                for(NodeAction *action in copyActions){
                    [wealSelf addTarget:wealSelf.view forControlEvents:action.controlEvents action:action.actionBlock];
                }
            }
            
            if (wealSelf.parentNode) {
                NSInteger index = [wealSelf.parentNode.childs indexOfObject:wealSelf];
                if (wealSelf.parentNode.view) {
                    [wealSelf.parentNode.view insertSubview:wealSelf.view atIndex:index];
                }
            }
        }else{
            wealSelf.view.frame = frame;
        }
    }];
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

- (NSMutableArray<ViewAttribute *> *)viewAttributes{
    if (!_viewAttributes) {
        _viewAttributes = [[NSMutableArray alloc] init];
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
    return (self.parentNode == nil);
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
    UILabel *lable = [UILabel new];
    lable.text = self.text;
    return [lable sizeThatFits:size];
}

- (void)applyLayout{
    if (self.layout) {
        [self.layout applyLayoutWithsize:self.size];
    }
}

- (void)applyLayout:(CGSize)size{
    if (self.layout) {
        [self.layout applyLayoutWithsize:self.size];
    }
}

- (CGSize)calculateLayoutWithSize:(CGSize)size{
    if (self.layout) {
        return [self.layout calculateLayoutWithSize:size];
    }
    return CGSizeMake(0, 0);
}
@end

@implementation ArgoKitNode(Hierarchy)
- (void)addChildNode:(ArgoKitNode *)node{
    if (node) {
        node.parentNode = self;
        if (node.view) {
            [self.view addSubview:node.view];
        }
        [self.childs addObject:node];
    }
}
- (void)insertChildNode:(ArgoKitNode *)node atIndex:(NSInteger)index{
    if (node) {
        [self.childs insertObject:node atIndex:index];
    }
}
- (void)removeFromSuperNode{
    if(self.parentNode){
        [self.view removeFromSuperview];
        [self.parentNode.childs removeObject:self];
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
}
@end


@implementation ArgoKitNode(Frame)
- (void)direction:(YGDirection)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetDirection(node, value);
     
}
- (void)directionInherit{
    return [self direction:YGDirectionInherit];
}
- (void)directionLTR{
    return [self direction:YGDirectionLTR];
}
- (void)directionRTL{
    return [self direction:YGDirectionRTL];
}

- (void)flexDirection:(YGFlexDirection)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetFlexDirection(node, value);
     
}

- (void)column{
    return [self flexDirection:YGFlexDirectionColumn];
}
- (void)columnREV{
    return [self flexDirection:YGFlexDirectionColumnReverse];
}
- (void)row{
    return [self flexDirection:YGFlexDirectionRow];
}
- (void)rowREV{
    return [self flexDirection:YGFlexDirectionRowReverse];
}

- (void)justifyContent:(YGJustify)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetJustifyContent(node, value);
     
}

- (void)justifyContentFlexStart{
    return [self justifyContent:YGJustifyFlexStart];
}
- (void)justifyContentCenter{
    return [self justifyContent:YGJustifyCenter];
}
- (void)justifyContentFlexEnd{
    return [self justifyContent:YGJustifyFlexEnd];
}
- (void)justifyContentSpaceBetween{
    return [self justifyContent:YGJustifySpaceBetween];
}
- (void)justifyContentSpaceAround{
    return [self justifyContent:YGJustifySpaceAround];
}
- (void)justifyContentSpaceEvenly{
    return [self justifyContent:YGJustifySpaceEvenly];
}

- (void)alignContent:(YGAlign)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetAlignContent(node, value);
     
}
- (void)alignContentAuto{
    return [self alignContent:YGAlignAuto];
}
- (void)alignContentFlexStart{
    return [self alignContent:YGAlignFlexStart];
}
- (void)alignContentCenter{
    return [self alignContent:YGAlignCenter];
}
- (void)alignContentFlexEnd{
    return [self alignContent:YGAlignFlexEnd];
}
- (void)alignContentStretch{
    return [self alignContent:YGAlignStretch];
}
- (void)alignContentBaseline{
    return [self alignContent:YGAlignBaseline];
}
- (void)alignContentSpaceBetween{
    return [self alignContent:YGAlignSpaceBetween];
}
- (void)alignContentSpaceAround{
    return [self alignContent:YGAlignSpaceAround];
}


- (void)alignItems:(YGAlign)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetAlignItems(node, value);
     
}
- (void)alignItemsAuto{
    return [self alignItems:YGAlignAuto];
}
- (void)alignItemsFlexStart{
    return [self alignItems:YGAlignFlexStart];
}
- (void)alignItemsCenter{
    return [self alignItems:YGAlignCenter];
}
- (void)alignItemsFlexEnd{
    return [self alignItems:YGAlignFlexEnd];
}
- (void)alignItemsStretch{
    return [self alignItems:YGAlignStretch];
}
- (void)alignItemsBaseline{
    return [self alignItems:YGAlignBaseline];
}
- (void)alignItemsSpaceBetween{
    return [self alignItems:YGAlignSpaceBetween];
}
- (void)alignItemsSpaceAround{
    return [self alignItems:YGAlignSpaceAround];
}

- (void)alignSelf:(YGAlign)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetAlignSelf(node, value);
     
}
- (void)alignSelfAuto{
    return [self alignSelf:YGAlignAuto];
}
- (void)alignSelfFlexStart{
    return [self alignSelf:YGAlignFlexStart];
}
- (void)alignSelfCenter{
    return [self alignSelf:YGAlignCenter];
}
- (void)alignSelfFlexEnd{
    return [self alignSelf:YGAlignFlexEnd];
}
- (void)alignSelfStretch{
    return [self alignSelf:YGAlignStretch];
}
- (void)alignSelfBaseline{
    return [self alignSelf:YGAlignBaseline];
}
- (void)alignSelfSpaceBetween{
    return [self alignSelf:YGAlignSpaceBetween];
}
- (void)alignSelfSpaceAround{
    return [self alignSelf:YGAlignSpaceAround];
}

- (void)position:(YGPositionType)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetPositionType(node, value);
     
}
- (void)positionRelative{
    return [self position:YGPositionTypeRelative];
}
- (void)positionAbsolute{
    return [self position:YGPositionTypeAbsolute];
}

- (void)flexWrap:(YGWrap)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetFlexWrap(node, value);
     
}
- (void)flexWrapNoWrap{
    return [self flexWrap:YGWrapNoWrap];
}
- (void)flexWrapWrap{
    return [self flexWrap:YGWrapWrap];
}
- (void)flexWrapWrapREV{
    return [self flexWrap:YGWrapWrapReverse];
}

- (void)overflow:(YGOverflow)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetOverflow(node, value);
     
}
- (void)overflowVisible{
    return [self overflow:YGOverflowVisible];
}
- (void)overflowHidden{
    return [self overflow:YGOverflowHidden];
}
- (void)overflowScroll{
    return [self overflow:YGOverflowScroll];
}

- (void)display:(YGDisplay)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetDisplay(node, value);
    
     
}
- (void)displayFlex{
    return [self display:YGDisplayFlex];
}
- (void)displayNone{
    return [self display:YGDisplayNone];
}

- (void)flex:(CGFloat)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetFlex(node, value);
     
}
- (void)flexGrow:(CGFloat)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetFlexGrow(node, value);
     
}
- (void)flexShrink:(CGFloat)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetFlexShrink(node, value);
    
     
}

- (void)flexBasis:(YGValue)value{
    YGNodeRef node = self.layout.ygnode;
    switch (value.unit) {
        case YGUnitAuto:
            YGNodeStyleSetFlexBasisAuto(node);
            break;
        case YGUnitPercent:
            YGNodeStyleSetFlexBasisPercent(node, value.value);
            break;
        case YGUnitPoint:
            YGNodeStyleSetFlexBasis(node, value.value);
            break;
        default:
            break;
    }
     
}
- (void)flexBasisAuto{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetFlexBasisAuto(node);
     
}
- (void)flexBasisWithPercent:(CGFloat)value{
    YGNodeRef node = self.layout.ygnode;
    if(value > 100.0){
        value = 100.0;
    }
    YGNodeStyleSetFlexBasisPercent(node, (float)value);
     
}
- (void)flexBasisWithPoint:(CGFloat)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetFlexBasis(node, (float)value);
     
}

- (void)left:(YGValue)value{
    YGNodeRef node = self.layout.ygnode;
    switch (value.unit) {
        case YGUnitUndefined:
        case YGUnitPoint:
            YGNodeStyleSetPosition(node, YGEdgeLeft, value.value);
            break;
        case YGUnitPercent:
            YGNodeStyleSetPositionPercent(node, YGEdgeLeft, value.value);
            break;
        default:
            break;
    }
    
     
}
- (void)positionWithPercent:(CGFloat)value edge:(YGEdge)edge{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetPositionPercent(node, edge, (float)value);
     
}
- (void)positionWithPoint:(CGFloat)value edge:(YGEdge)edge{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetPosition(node, edge, (float)value);
     
}
- (void)leftWithPercent:(CGFloat)value{
    return [self positionWithPercent:value edge:YGEdgeLeft];
}
- (void)leftWithPoint:(CGFloat)value{
    return [self positionWithPoint:value edge:YGEdgeLeft];
}

- (void)topWithPercent:(CGFloat)value{
    return [self positionWithPercent:value edge:YGEdgeTop];
}
- (void)topWithPoint:(CGFloat)value{
    return [self positionWithPoint:value edge:YGEdgeTop];
}

- (void)top:(YGValue)value{
    YGNodeRef node = self.layout.ygnode;
    switch (value.unit) {
        case YGUnitUndefined:
        case YGUnitPoint:
            YGNodeStyleSetPosition(node, YGEdgeTop, value.value);
            break;
        case YGUnitPercent:
            YGNodeStyleSetPositionPercent(node, YGEdgeTop, value.value);
            break;
        default:
            break;
    }
     
}

- (void)right:(YGValue)value{
    YGNodeRef node = self.layout.ygnode;
    switch (value.unit) {
        case YGUnitUndefined:
        case YGUnitPoint:
            YGNodeStyleSetPosition(node, YGEdgeRight, value.value);
            break;
        case YGUnitPercent:
            YGNodeStyleSetPositionPercent(node, YGEdgeRight, value.value);
            break;
        default:
            break;
    }
     
}
- (void)rightWithPercent:(CGFloat)value{
    return [self positionWithPercent:value edge:YGEdgeRight];
}
- (void)rightWithPoint:(CGFloat)value{
    return [self positionWithPoint:value edge:YGEdgeRight];
}
- (void)bottom:(YGValue)value{
    YGNodeRef node = self.layout.ygnode;
    switch (value.unit) {
        case YGUnitUndefined:
        case YGUnitPoint:
            YGNodeStyleSetPosition(node, YGEdgeBottom, value.value);
            break;
        case YGUnitPercent:
            YGNodeStyleSetPositionPercent(node, YGEdgeBottom, value.value);
            break;
        default:
            break;
    }
    
     
}
- (void)bottomWithPercent:(CGFloat)value{
    return [self positionWithPercent:value edge:YGEdgeBottom];
}
- (void)bottomWithPoint:(CGFloat)value{
    return [self positionWithPoint:value edge:YGEdgeBottom];
}
- (void)start:(YGValue)value{
    YGNodeRef node = self.layout.ygnode;
    switch (value.unit) {
        case YGUnitUndefined:
        case YGUnitPoint:
            YGNodeStyleSetPosition(node, YGEdgeStart, value.value);
            break;
        case YGUnitPercent:
            YGNodeStyleSetPositionPercent(node, YGEdgeStart, value.value);
            break;
        default:
            break;
    }
    
     
}
- (void)startWithPercent:(CGFloat)value{
    return [self positionWithPercent:value edge:YGEdgeStart];
}
- (void)startWithPoint:(CGFloat)value{
    return [self positionWithPoint:value edge:YGEdgeStart];
}
- (void)end:(YGValue)value{
    YGNodeRef node = self.layout.ygnode;
    switch (value.unit) {
        case YGUnitUndefined:
        case YGUnitPoint:
            YGNodeStyleSetPosition(node, YGEdgeEnd, value.value);
            break;
        case YGUnitPercent:
            YGNodeStyleSetPositionPercent(node, YGEdgeEnd, value.value);
            break;
        default:
            break;
    }
    
     
}
- (void)endWithPercent:(CGFloat)value{
    return [self positionWithPercent:value edge:YGEdgeEnd];
}
- (void)endWithPoint:(CGFloat)value{
    return [self positionWithPoint:value edge:YGEdgeEnd];
}


- (void)marginWithPercent:(CGFloat)value edge:(YGEdge)edge{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetMarginPercent(node, edge, (float)value);
     
}
- (void)marginWithPoint:(CGFloat)value edge:(YGEdge)edge{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetMargin(node, edge, (float)value);
     
}


- (void)marginLeft:(YGValue)value{
    YGNodeRef node = self.layout.ygnode;
    switch (value.unit) {
        case YGUnitUndefined:
        case YGUnitPoint:
            YGNodeStyleSetMargin(node, YGEdgeLeft, value.value);
            break;
        case YGUnitPercent:
            YGNodeStyleSetMarginPercent(node, YGEdgeLeft, value.value);
            break;
        default:
            break;
    }
    
     
}
- (void)marginLeftWithPoint:(CGFloat)value{
    return [self marginWithPoint:value edge:YGEdgeLeft];
}
- (void)marginLeftWithPercent:(CGFloat)value{
    return [self marginWithPercent:value edge:YGEdgeLeft];
}

- (void)marginTop:(YGValue)value{
    YGNodeRef node = self.layout.ygnode;
    switch (value.unit) {
        case YGUnitUndefined:
        case YGUnitPoint:
            YGNodeStyleSetMargin(node, YGEdgeTop, value.value);
            break;
        case YGUnitPercent:
            YGNodeStyleSetMarginPercent(node, YGEdgeTop, value.value);
            break;
        default:
            break;
    }
    
     
}
- (void)marginTopWithPoint:(CGFloat)value{
    return [self marginWithPoint:value edge:YGEdgeTop];
}
- (void)marginTopWithPercent:(CGFloat)value{
    return [self marginWithPercent:value edge:YGEdgeTop];
}
- (void)marginRight:(YGValue)value{
    YGNodeRef node = self.layout.ygnode;
    switch (value.unit) {
        case YGUnitUndefined:
        case YGUnitPoint:
            YGNodeStyleSetMargin(node, YGEdgeRight, value.value);
            break;
        case YGUnitPercent:
            YGNodeStyleSetMarginPercent(node, YGEdgeRight, value.value);
            break;
        default:
            break;
    }
    
     
}
- (void)marginRightWithPoint:(CGFloat)value{
    return [self marginWithPoint:value edge:YGEdgeRight];
}
- (void)marginRightWithPercent:(CGFloat)value{
    return [self marginWithPercent:value edge:YGEdgeRight];
}
- (void)marginBottom:(YGValue)value{
    YGNodeRef node = self.layout.ygnode;
    switch (value.unit) {
        case YGUnitUndefined:
        case YGUnitPoint:
            YGNodeStyleSetMargin(node, YGEdgeBottom, value.value);
            break;
        case YGUnitPercent:
            YGNodeStyleSetMarginPercent(node, YGEdgeBottom, value.value);
            break;
        default:
            break;
    }
    
     
}
- (void)marginBottomWithPoint:(CGFloat)value{
    return [self marginWithPoint:value edge:YGEdgeBottom];
}
- (void)marginBottomWithPercent:(CGFloat)value{
    return [self marginWithPercent:value edge:YGEdgeBottom];
}
- (void)marginStart:(YGValue)value{
    YGNodeRef node = self.layout.ygnode;
    switch (value.unit) {
        case YGUnitUndefined:
        case YGUnitPoint:
            YGNodeStyleSetMargin(node, YGEdgeStart, value.value);
            break;
        case YGUnitPercent:
            YGNodeStyleSetMarginPercent(node, YGEdgeStart, value.value);
            break;
        default:
            break;
    }
    
     
}
- (void)marginStartWithPoint:(CGFloat)value{
    return [self marginWithPoint:value edge:YGEdgeStart];
}
- (void)marginStartWithPercent:(CGFloat)value{
    return [self marginWithPercent:value edge:YGEdgeStart];
}

- (void)marginEnd:(YGValue)value{
    YGNodeRef node = self.layout.ygnode;
    switch (value.unit) {
        case YGUnitUndefined:
        case YGUnitPoint:
            YGNodeStyleSetMargin(node, YGEdgeEnd, value.value);
            break;
        case YGUnitPercent:
            YGNodeStyleSetMarginPercent(node, YGEdgeEnd, value.value);
            break;
        default:
            break;
    }
    
     
}
- (void)marginEndWithPoint:(CGFloat)value{
    return [self marginWithPoint:value edge:YGEdgeEnd];
}
- (void)marginEndWithPercent:(CGFloat)value{
    return [self marginWithPercent:value edge:YGEdgeEnd];
}

- (void)marginHorizontal:(YGValue)value{
    YGNodeRef node = self.layout.ygnode;
    switch (value.unit) {
        case YGUnitUndefined:
        case YGUnitPoint:
            YGNodeStyleSetMargin(node, YGEdgeHorizontal, value.value);
            break;
        case YGUnitPercent:
            YGNodeStyleSetMarginPercent(node, YGEdgeHorizontal, value.value);
            break;
        default:
            break;
    }
     
}
- (void)marginHWithPoint:(CGFloat)value{
    return [self marginWithPoint:value edge:YGEdgeHorizontal];
}
- (void)marginHWithPercent:(CGFloat)value{
    return [self marginWithPercent:value edge:YGEdgeHorizontal];
}

- (void)marginVertical:(YGValue)value{
    YGNodeRef node = self.layout.ygnode;
    switch (value.unit) {
        case YGUnitUndefined:
        case YGUnitPoint:
            YGNodeStyleSetMargin(node, YGEdgeVertical, value.value);
            break;
        case YGUnitPercent:
            YGNodeStyleSetMarginPercent(node, YGEdgeVertical, value.value);
            break;
        default:
            break;
    }
    
     
}
- (void)marginVWithPoint:(CGFloat)value{
    return [self marginWithPoint:value edge:YGEdgeVertical];
}
- (void)marginVWithPercent:(CGFloat)value{
    return [self marginWithPercent:value edge:YGEdgeVertical];
}

- (void)margin:(YGValue)value{
    YGNodeRef node = self.layout.ygnode;
    switch (value.unit) {
        case YGUnitUndefined:
        case YGUnitPoint:
            YGNodeStyleSetMargin(node, YGEdgeAll, value.value);
            break;
        case YGUnitPercent:
            YGNodeStyleSetMarginPercent(node, YGEdgeAll, value.value);
            break;
        default:
            break;
    }
     
}

- (void)marginAllWithPoint:(CGFloat)value{
    return [self marginWithPoint:value edge:YGEdgeAll];
}
- (void)marginAllWithPercent:(CGFloat)value{
    return [self marginWithPercent:value edge:YGEdgeAll];
}


- (void)paddingWithPercent:(CGFloat)value edge:(YGEdge)edge{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetPaddingPercent(node, edge, (float)value);
     
}
- (void)paddingWithPoint:(CGFloat)value edge:(YGEdge)edge{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetPadding(node, edge, (float)value);
     
}


- (void)paddingLeftWithPercent:(CGFloat)value {
    return [self paddingWithPercent:value edge:YGEdgeLeft];
}
- (void)paddingLeftWithPoint:(CGFloat)value{
    return [self paddingWithPoint:value edge:YGEdgeLeft];
}

- (void)paddingTopWithPercent:(CGFloat)value {
    return [self paddingWithPercent:value edge:YGEdgeTop];
}
- (void)paddingTopWithPoint:(CGFloat)value{
    return [self paddingWithPoint:value edge:YGEdgeTop];
}

- (void)paddingRightWithPercent:(CGFloat)value {
    return [self paddingWithPercent:value edge:YGEdgeRight];
}
- (void)paddingRightWithPoint:(CGFloat)value{
    return [self paddingWithPoint:value edge:YGEdgeRight];
}

- (void)paddingBottomWithPercent:(CGFloat)value {
    return [self paddingWithPercent:value edge:YGEdgeBottom];
}
- (void)paddingBottomWithPoint:(CGFloat)value{
    return [self paddingWithPoint:value edge:YGEdgeBottom];
}

- (void)paddingStartWithPercent:(CGFloat)value {
    return [self paddingWithPercent:value edge:YGEdgeStart];
}
- (void)paddingStartWithPoint:(CGFloat)value{
    return [self paddingWithPoint:value edge:YGEdgeStart];
}

- (void)paddingEndWithPercent:(CGFloat)value {
    return [self paddingWithPercent:value edge:YGEdgeEnd];
}
- (void)paddingEndWithPoint:(CGFloat)value{
    return [self paddingWithPoint:value edge:YGEdgeEnd];
}

- (void)paddingHWithPercent:(CGFloat)value {
    return [self paddingWithPercent:value edge:YGEdgeHorizontal];
}
- (void)paddingHWithPoint:(CGFloat)value{
    return [self paddingWithPoint:value edge:YGEdgeHorizontal];
}

- (void)paddingVWithPercent:(CGFloat)value {
    return [self paddingWithPercent:value edge:YGEdgeVertical];
}
- (void)paddingVWithPoint:(CGFloat)value{
    return [self paddingWithPoint:value edge:YGEdgeVertical];
}

- (void)paddingAllWithPercent:(CGFloat)value {
    return [self paddingWithPercent:value edge:YGEdgeAll];
}
- (void)paddingAllWithPoint:(CGFloat)value{
    return [self paddingWithPoint:value edge:YGEdgeAll];
}


- (void)borderLeftWidth:(CGFloat)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetBorder(node, YGEdgeLeft, value);
    
     
}
- (void)borderTopWidth:(CGFloat)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetBorder(node, YGEdgeTop, value);
    
     
}
- (void)borderRightWidth:(CGFloat)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetBorder(node, YGEdgeRight, value);
    
     
}
- (void)borderBottomWidth:(CGFloat)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetBorder(node, YGEdgeBottom, value);
    
     
}
- (void)borderStartWidth:(CGFloat)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetBorder(node, YGEdgeStart, value);
    
     
}
- (void)borderEndWidth:(CGFloat)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetBorder(node, YGEdgeEnd, value);

     
}
- (void)borderWidth:(CGFloat)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetBorder(node, YGEdgeAll, value);
    
     
}

- (void)widthWithAuto{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetWidthAuto(node);
     
}
- (void)widthWithPercent:(CGFloat)value {
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetWidthPercent(node,(float)value);
     
}
- (void)widthWithPoint:(CGFloat)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetWidth(node, (float)value);
}

- (CGFloat)width{
    YGNodeRef node = self.layout.ygnode;
    return YGNodeStyleGetWidth(node).value;
}

- (void)heightAuto{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetHeightAuto(node);
     
}
- (void)heightWithPercent:(CGFloat)value {
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetHeightPercent(node,(float)value);
     
}
- (void)heightWithPoint:(CGFloat)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetHeight(node, (float)value);
}
- (CGFloat)height{
    YGNodeRef node = self.layout.ygnode;
    return YGNodeStyleGetHeight(node).value;
}

- (void)minWidthWithPercent:(CGFloat)value {
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetMinWidthPercent(node,(float)value);
     
}
- (void)minWidthWithPoint:(CGFloat)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetMinWidth(node, (float)value);
}
- (CGFloat)minWidth{
    YGNodeRef node = self.layout.ygnode;
    return YGNodeStyleGetMinWidth(node).value;
}

- (void)minHeightWithPercent:(CGFloat)value {
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetMinHeightPercent(node,(float)value);
}
- (void)minHeightWithPoint:(CGFloat)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetMinHeight(node, (float)value);
}

- (CGFloat)minHeight{
    YGNodeRef node = self.layout.ygnode;
    return YGNodeStyleGetMinHeight(node).value;
}

- (void)maxWidthWithPercent:(CGFloat)value {
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetMaxWidthPercent(node,(float)value);
     
}
- (void)maxWidthWithPoint:(CGFloat)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetMaxWidth(node, (float)value);
}

- (CGFloat)maxWidth{
    YGNodeRef node = self.layout.ygnode;
    return YGNodeStyleGetMaxWidth(node).value;
}

- (void)maxHeightWithPercent:(CGFloat)value {
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetMaxHeightPercent(node,(float)value);
     
}
- (void)maxHeightWithPoint:(CGFloat)value{
    YGNodeRef node = self.layout.ygnode;
    YGNodeStyleSetMaxHeight(node, (float)value);
}
- (CGFloat)maxHeight{
    YGNodeRef node = self.layout.ygnode;
    return YGNodeStyleGetMaxHeight(node).value;
}
@end
