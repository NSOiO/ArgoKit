//
//  ArgoKitUtils.h
//  ArgoKit
//
//  Created by Bruce on 2020/10/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArgoKitUtils : NSObject
+ (void)runMainThreadBlock:(dispatch_block_t)block;
@end

NS_ASSUME_NONNULL_END
