//
//  ArgoLayoutHelper.h
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArgoLayoutHelper : NSObject
- (instancetype)init NS_UNAVAILABLE;
+ (void)argoLayoutCalculateTask:(dispatch_block_t)calculateTask onComplete:(dispatch_block_t)onComplete;
+ (void)startRunloop;
+ (void)stopRunloop;
@end

NS_ASSUME_NONNULL_END
