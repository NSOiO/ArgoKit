//
//  ArgoKitLock.m
//  ArgoKit
//
//  Created by Bruce on 2021/2/23.
//

#import "ArgoKitLock.h"
#import <os/lock.h>
@interface ArgoKitLock(){
    os_unfair_lock unfair_lock;
}
@end
@implementation ArgoKitLock
- (instancetype)init
{
    self = [super init];
    if (self) {
        unfair_lock = OS_UNFAIR_LOCK_INIT;
    }
    return self;
}
- (void)lock{
    os_unfair_lock_lock(&unfair_lock);
}

- (bool)trylock{
    return os_unfair_lock_trylock(&unfair_lock);
}
- (void)unlock{
    os_unfair_lock_unlock(&unfair_lock);
}
@end
