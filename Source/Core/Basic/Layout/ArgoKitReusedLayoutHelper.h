//
//  ArgoKitLayoutHelper.h
//  ArgoKit
//
//  Created by Bruce on 2020/10/15.
//

#import <Foundation/Foundation.h>
@class ArgoKitNode;
NS_ASSUME_NONNULL_BEGIN

@interface ArgoKitReusedLayoutHelper : NSObject
- (instancetype)init NS_UNAVAILABLE;
+ (void)addLayoutNode:(nullable ArgoKitNode *)node;
+ (void)removeLayoutNode:(nullable ArgoKitNode *)node;
+ (void)appLayout:(ArgoKitNode *)node;
+ (void)reLayoutNode:(nullable NSArray *)cellNodes frame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
