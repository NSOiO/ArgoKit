//
//  ArgoLayoutHelper.h
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/15.
//

#import <Foundation/Foundation.h>
@class ArgoKitNode;
NS_ASSUME_NONNULL_BEGIN

@interface ArgoLayoutHelper : NSObject
- (instancetype)init NS_UNAVAILABLE;
+ (void)startRunloop;
+ (void)stopRunloop;
+ (void)addLayoutNode:(ArgoKitNode *)node;
+ (void)removeLayoutNode:(ArgoKitNode *)node;
@end

NS_ASSUME_NONNULL_END
