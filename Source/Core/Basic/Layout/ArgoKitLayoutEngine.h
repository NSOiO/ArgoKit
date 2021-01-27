//
//  ArgoKitLayoutEngine.h
//  ArgoKit
//
//  Created by Bruce on 2020/11/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class ArgoKitNode;
@interface ArgoKitLayoutEngine : NSObject
- (void)startRunloop:(CFOptionFlags)activities repeats:(Boolean) repeats order:(CFIndex)order block:(void(^)(ArgoKitNode *node))block;
- (void)stopRunloop;
- (void)addLayoutNode:(nullable ArgoKitNode *)node;
- (void)removeLayoutNode:(nullable ArgoKitNode *)node;

- (void)forLayoutNode:(nullable Class)anyClass frame:(CGRect)frame;

- (void)reLayoutNode:(nullable NSArray *)cellNodes frame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
