//
//  ArgoKitLayoutHelper.h
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/15.
//

#import <Foundation/Foundation.h>
@class ArgoKitNode;
NS_ASSUME_NONNULL_BEGIN

@interface ArgoKitLayoutHelper : NSObject
- (instancetype)init NS_UNAVAILABLE;
+ (void)addLayoutNode:(nullable ArgoKitNode *)node;

+ (void)forLayoutNode:(nullable Class)anyClass;
@end

NS_ASSUME_NONNULL_END
