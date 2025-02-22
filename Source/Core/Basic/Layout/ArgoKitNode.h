//
//  Node.h
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef id _Nullable(^ArgoKitNodeBlock)(id obj, NSArray<id> * _Nullable paramter);
@interface NodeAction:NSObject{
    int actionTag;
    ArgoKitNodeBlock action;
    UIControlEvents  events;
}
@property(nonatomic, copy) ArgoKitNodeBlock actionBlock;
@property(nonatomic, assign)  UIControlEvents  controlEvents;
- (instancetype)initWithAction:(ArgoKitNodeBlock)action controlEvents:(UIControlEvents)controlEvents;
@end

@interface ViewAttribute : NSObject
@property(nonatomic,assign)SEL selector;
@property(nonatomic,copy)NSArray<id> *paramter;
@property(nonatomic,assign)BOOL isDirty;
@property(nonatomic,assign)BOOL isCALayer;
- (instancetype)initWithSelector:(nullable SEL)selector paramter:(nullable NSArray<id> *)paramter;
@end
 
@interface ArgoKitNode : NSObject

@property (nonatomic, strong) NSString *identifiable; // default is self.hash string value

/* 是否为根节点*/
@property (nonatomic, assign, readonly)BOOL isRootNode;
/* 顶层根节点*/
@property (nonatomic, weak ,nullable)ArgoKitNode  *rootNode;
/* node父节点*/
@property (nonatomic, weak ,nullable)ArgoKitNode  *parentNode;
/* node包含的子节点*/
@property (nonatomic, strong, readonly,nullable)  NSMutableArray<ArgoKitNode *> *childs;

//链接此node被复用到的node节点
@property (nonatomic, weak,nullable)ArgoKitNode *linkNode;

@property (atomic, strong) NSMutableDictionary *bindProperties;



/* 节点持有的视图 */
@property (nonatomic, strong, readonly, nullable) UIView *view;
/* 节点持有的视图 */
@property (nonatomic, assign, readonly)Class viewClass;

@property (nonatomic, copy) NSString *viewAliasName;

/* frame 相关 */
@property (nonatomic, assign) CGRect frame; // 调用 applyLayout 相关方法后会更新 frame, 更新 frame 同时会更新 size
@property (nonatomic, assign) CGSize size; // 调用 [ArgoKitNode calculateLayoutWithSize:] 后会更新 size
/**
 Returns the number of children that are using Flexbox.
 */
@property (nonatomic, readonly, assign) NSUInteger numberOfChildren;
/**
 Return a BOOL indiciating whether or not we this node contains any subviews that are included in
 Yoga's layout.
 */
@property (nonatomic, readonly, assign) BOOL isLeaf;
/**
 Return's a BOOL indicating if a view is dirty. When a node is dirty
 it usually indicates that it will be remeasured on the next layout pass.
 */
@property (nonatomic, readonly, assign) BOOL isDirty;

/**
 The property that decides during layout/sizing whether or not styling properties should be applied.
 Defaults to YES.
 */
@property (nonatomic, readwrite, assign, setter=setEnabled:) BOOL isEnabled;

/*If the origin is reset, the root view's layout results will applied from {0,0} when Perform a layout calculation and update the frames of the views in the hierarchy with the results*/
@property (nonatomic, readwrite, assign) BOOL resetOrigin;
- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithView:(UIView *)view NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithViewClass:(Class)viewClass NS_DESIGNATED_INITIALIZER;

- (nullable UIView *)nodeView;
- (void)bindView:(UIView *)view;

@property (nonatomic,strong,readonly)NSMutableArray<NodeAction *> *nodeActions;

//action
- (void)addAction:(ArgoKitNodeBlock)action forControlEvents:(UIControlEvents)controlEvents;
- (void)addTarget:(id)target forControlEvents:(UIControlEvents)controlEvents action:(ArgoKitNodeBlock)action;

- (nullable id)sendActionWithObj:(id)obj paramter:(nullable NSArray *)paramter;
- (void)observeAction:(id)obj actionBlock:(ArgoKitNodeBlock)action;


- (void)createNodeViewIfNeed:(CGRect)frame;
// 子类可重载
- (UIView *)createNodeViewWithFrame:(CGRect)frame; // 自定义创建View

- (void)destroyProperties;
- (void)clearStrongRefrence;
@end

@interface ArgoKitNode(LayoutNode)
/**
 Mark that a view's layout needs to be recalculated. Only works for leaf views.
 */
- (void)markDirty;

/// 用于测量叶子节点视图大小, 子类node应该覆盖该方法
- (CGSize)sizeThatFits:(CGSize)size;

/**
 Perform a layout calculation and update the frames of the views in the hierarchy with the results.
 If the origin is not preserved, the root view's layout results will applied from {0,0}.
 */
- (CGSize)applyLayout NS_SWIFT_NAME(applyLayout());

/**
 Perform a layout calculation and update the frames of the views in the hierarchy with the results.
 Returns the size of the view based on provided constraints. Pass NaN for an unconstrained dimension.
 */
- (CGSize)applyLayout:(CGSize)size
    NS_SWIFT_NAME(applyLayout(size:));

/**
  Returns the size of the view based on provided constraints. Pass NaN for an unconstrained dimension.
 */
- (CGSize)calculateLayoutWithSize:(CGSize)size
    NS_SWIFT_NAME(calculateLayout(size:));

///  update the frames of the nodes in the hierarchy with the results of Calculation.
/// @param withView 更新完node是否创建对应的视图，YES 创建，NO不创建
- (void)applyLayoutAferCalculationWithView:(BOOL)withView
NS_SWIFT_NAME(applyLayoutAferCalculation(withView:));

@end


@interface ArgoKitNode(Hierarchy)
- (void)addChildNode:(nullable ArgoKitNode *)node;
- (void)addChildNodes:(NSArray<ArgoKitNode *> *)nodes;
- (void)insertChildNode:(ArgoKitNode *)node atIndex:(NSInteger)index;
- (void)removeFromSuperNode;
- (void)removeAllChildNodes;
- (void)positonToFront;
- (void)positonToBack;
- (void)positonToIndex:(NSInteger)index;
@end




@interface ArgoKitNode(AttributeValue)
- (void)reuseNodeToView:(ArgoKitNode *)node view:(nullable UIView *)view NS_SWIFT_NAME(reuseNodeToView(node:view:));
- (void)prepareForUse:(nullable UIView *)view NS_SWIFT_NAME(prepareForUse(view:));
- (void)addNodeViewAttribute:(nullable ViewAttribute *)attribute NS_SWIFT_NAME(addNodeddView(attribute:));
- (nullable NSArray<ViewAttribute *> *)nodeAllAttributeValue;
// 获取对应属性值
- (nullable NSString *)text;
- (nullable NSAttributedString *)attributedText;
- (nullable UIFont *)font;
- (nullable UIColor *)textColor;
- (NSInteger)numberOfLines NS_SWIFT_NAME(numberOfLines());
- (NSTextAlignment)textAlignment;
- (NSLineBreakMode)lineBreakMode;
- (nullable UIImage *)image;
- (nullable id)valueWithSelector:(SEL)selector;
@end
NS_ASSUME_NONNULL_END
