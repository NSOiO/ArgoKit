//
//  ArgoKitNodeModifier.h
//  ArgoKit
//
//  Created by Bruce on 2020/11/5.
//

#import <Foundation/Foundation.h>
#import "ArgoKitNode.h"
NS_ASSUME_NONNULL_BEGIN

@interface ArgoKitNodeViewModifier : NSObject
+ (void)nodeViewAttributeWithView:(id)view attributes:(NSArray<ViewAttribute *> *)attributes;
@end

NS_ASSUME_NONNULL_END
