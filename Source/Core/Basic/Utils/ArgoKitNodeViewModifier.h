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

+ (void)nodeViewAttributeWithNode:(nullable ArgoKitNode *)node attributes:(nullable NSArray<ViewAttribute *> *)attributes markDirty:(BOOL)markDirty;

+ (void)reuseNodeViewAttribute:(ArgoKitNode *)node reuseNode:(ArgoKitNode*)reuseNode;

+ (void)resetNodeViewFrame:(nullable ArgoKitNode *)node;

+ (void)commitAttributeValueToView:(ArgoKitNode *)node reuseNode:(ArgoKitNode*)reuseNode;

+ (void)prepareForReuseNode:(nullable ArgoKitNode*)node;

+ (void)performViewAttribute:(nullable UIView *)view attributes:(nullable NSArray<ViewAttribute *> *)attributes;
@end

NS_ASSUME_NONNULL_END
