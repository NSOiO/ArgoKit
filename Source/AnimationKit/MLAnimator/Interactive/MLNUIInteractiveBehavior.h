//
//  MLNUIInteractiveBehavior.h
//  ArgoUI
//
//  Created by MOMO on 2020/6/18.
//

/*
#import <Foundation/Foundation.h>
//#import "MLNUIViewConst.h"

NS_ASSUME_NONNULL_BEGIN
@class MLAValueAnimation;
@class MLNUILuaCore, MLNUIBlock;

typedef NS_ENUM(NSUInteger, MLNUITouchType) {
    MLNUITouchType_Begin,
    MLNUITouchType_Move,
    MLNUITouchType_End
//    MLNUITouchType_Cancel
};

typedef NS_ENUM(NSUInteger, InteractiveDirection) {
    InteractiveDirection_X,
    InteractiveDirection_Y
};

typedef NS_ENUM(NSUInteger, InteractiveType) {
    InteractiveType_Gesture, ///< 手势驱动
    InteractiveType_Scale,   ///< 双指缩放驱动
    InteractiveType_Rotate,  ///< 双指旋转驱动（暂不实现）
};

typedef void(^MLNUITouchBehaviorBlock)(MLNUITouchType type, CGFloat delta, CGFloat velocity);

@interface MLNUIInteractiveBehavior : NSObject <NSCopying>

/// 目标视图
@property (nonatomic, weak) UIView *targetView;

/// 交互行为方向
@property (nonatomic, assign) InteractiveDirection direction;

/// 是否越界
@property (nonatomic, assign) BOOL overBoundary;

/// 是否允许交互
@property (nonatomic, assign) BOOL enable;

/// 是否跟随手势
@property (nonatomic, assign) BOOL followEnable;

/// 驱动最大值，当移动、缩放或旋转手势超过最大值时，动画到达最大值
@property (nonatomic, assign) CGFloat max;

/// 触摸回调
@property (nonatomic, strong) MLNUITouchBehaviorBlock touchBlock;

- (void)addAnimation:(MLAValueAnimation *)ani;
- (void)removeAnimation:(MLAValueAnimation *)ani;
- (void)removeAllAnimations;

// bridge
- (instancetype)initWithMLNUILuaCore:(MLNUILuaCore *)luaCore type:(InteractiveType)type;
- (void)lua_setTouchBlock:(MLNUIBlock *)block;
- (MLNUIBlock *)lua_touchBlock;

@end

NS_ASSUME_NONNULL_END
*/
