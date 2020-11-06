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
+ (void)nodeViewAttributeWithNode:(ArgoKitNode *)node attributes:(NSArray<ViewAttribute *> *)attributes;

+ (void)reuseNodeViewAttribute:(NSArray<ArgoKitNode*> *)nodes reuseNodes:(NSArray<ArgoKitNode*> *)reuseNodes;
@end

NS_ASSUME_NONNULL_END
