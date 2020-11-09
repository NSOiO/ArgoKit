//
//  ArgoKitUtils.m
//  ArgoKit
//
//  Created by Bruce on 2020/10/31.
//

#import "ArgoKitUtils.h"
#include <pthread/pthread.h>
@implementation ArgoKitUtils
+ (void)runMainThreadAsyncBlock:(dispatch_block_t)block{
    if (pthread_main_np()) {
        block();
    }else{
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

+ (void)runMainThreadSyncBlock:(dispatch_block_t)block{
    if (pthread_main_np()) {
        block();
    }else{
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}
@end
