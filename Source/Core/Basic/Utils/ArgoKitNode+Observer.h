//
//  ArgoKitNode+Observer.h
//  ArgoKit
//
//  Created by Bruce on 2020/11/27.
//

#import <Foundation/Foundation.h>
#import "ArgoKitNode.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^ArgoKitNodeCreateViewBlock)(UIView *);
typedef void(^ArgoKitNodeFrameChangeBlock)(CGRect);
@interface ArgoKitNodeObserver : NSObject
@property(nonatomic, copy, readonly)ArgoKitNodeCreateViewBlock  createViewBlock;
@property(nonatomic, copy, readonly)ArgoKitNodeFrameChangeBlock  frameChangeBlock;

- (void)setCreateViewBlock:(ArgoKitNodeCreateViewBlock _Nonnull)createViewBlock;
- (void)setFrameChangeBlock:(ArgoKitNodeFrameChangeBlock _Nonnull)frameChangeBlock;
@end
@interface ArgoKitNode(Observer)
- (void)addNodeObserver:(ArgoKitNodeObserver *)observer NS_SWIFT_NAME(addNode(observer:));
- (void)removeNodeObserver:(ArgoKitNodeObserver *)observer NS_SWIFT_NAME(removeNode(observer:));
- (void)removeAllNodeObservers NS_SWIFT_NAME(removeAllNodeObservers());

- (void)sendFrameChanged:(CGRect)frame NS_SWIFT_NAME(sendFrameChanged(frame:));

@end

NS_ASSUME_NONNULL_END
