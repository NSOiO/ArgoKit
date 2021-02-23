//
//  ArgoKitLock.h
//  ArgoKit
//
//  Created by Bruce on 2021/2/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArgoKitLock : NSObject
- (void)lock;
- (bool)trylock;
- (void)unlock;
@end

NS_ASSUME_NONNULL_END
