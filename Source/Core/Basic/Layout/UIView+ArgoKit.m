//
//  UIView+ArgoKit.m
//  ArgoKit
//
//  Created by Dai on 2021-04-25.
//

#import "UIView+ArgoKit.h"
@import ObjectiveC;

@implementation UIView (ArgoKit)

- (NSString *)argokit_viewAliasName {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setArgokit_viewAliasName:(NSString *)argokit_viewAliasName {
    objc_setAssociatedObject(self, @selector(argokit_viewAliasName), argokit_viewAliasName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end
