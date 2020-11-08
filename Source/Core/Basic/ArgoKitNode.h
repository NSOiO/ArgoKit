//
//  Node.h
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface ViewAttribute : NSObject
@property(nonatomic,assign)SEL selector;
@property(nonatomic,copy)NSArray<id> *paramter;
@property(nonatomic,assign)BOOL isDirty;
- (instancetype)initWithSelector:(nullable SEL)selector paramter:(nullable NSArray<id> *)paramter;
@end
 
typedef id _Nullable(^ArgoKitNodeBlock)(id obj, NSArray<id> * _Nullable paramter);
@interface ArgoKitNode : NSObject
/* node父节点*/
@property (nonatomic, weak ,nullable)ArgoKitNode  *parentNode;
/* node包含的子节点*/
@property (nonatomic, strong, readonly,nullable)  NSMutableArray<ArgoKitNode *> *childs;
/* 是否为根节点*/
@property (nonatomic, assign, readonly)BOOL isRootNode;

@property (nonatomic, strong) NSMutableDictionary *bindProperties;

//存储View属性
@property (nonatomic, strong)NSMutableArray<ViewAttribute *>* viewAttributes;
//存储Backup View属性
@property (nonatomic, copy)NSArray<ViewAttribute *>* backupViewAttributes;
/* 节点持有的视图 */
@property (nonatomic, strong, readonly, nullable) UIView *view;

/* 节点持有的视图 */
@property (nonatomic, assign)Class viewClass;

/* frame 相关 */
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

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

- (instancetype)initWithView:(UIView *)view;

- (instancetype)initWithViewClass:(Class)viewClass;
- (void)addAction:(ArgoKitNodeBlock)action forControlEvents:(UIControlEvents)controlEvents;
- (void)addTarget:(id)target forControlEvents:(UIControlEvents)controlEvents action:(ArgoKitNodeBlock)action;

- (nullable id)sendActionWithObj:(id)obj paramter:(nullable NSArray *)paramter;
- (void)observeAction:(id)obj actionBlock:(ArgoKitNodeBlock)action;
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

- (CGSize)applyLayout:(CGSize)size
    NS_SWIFT_NAME(applyLayout(size:));

/**
  Returns the size of the view based on provided constraints. Pass NaN for an unconstrained dimension.
 */
- (CGSize)calculateLayoutWithSize:(CGSize)size
    NS_SWIFT_NAME(calculateLayout(size:));
@end


@interface ArgoKitNode(Hierarchy)
- (void)addChildNode:(ArgoKitNode *)node;
- (void)insertChildNode:(ArgoKitNode *)node atIndex:(NSInteger)index;
- (void)removeFromSuperNode;
- (void)removeAllChildNodes;
@end




@interface ArgoKitNode(AttributeValue)
- (void)nodeAddViewAttribute:(nullable ViewAttribute *)attribute NS_SWIFT_NAME(nodeAddView(attribute:));
- (nullable NSString *)text;
- (nullable UIFont *)font;
- (NSInteger)numberOfLines NS_SWIFT_NAME(numberOfLines());
- (nullable UIImage *)image;
@end
NS_ASSUME_NONNULL_END
