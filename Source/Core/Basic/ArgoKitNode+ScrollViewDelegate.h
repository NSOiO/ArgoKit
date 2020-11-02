//
//  ArgoKitNode+ScrollViewDelegate.h
//  ArgoKit
//
//  Created by MOMO on 2020/10/30.
//

#import "ArgoKitNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface ArgoKitNode (ScrollViewDelegate) <UIScrollViewDelegate>

FOUNDATION_EXTERN NSString * const ArgoKitScrollViewDidScrollActionKey;
FOUNDATION_EXTERN NSString * const ArgoKitScrollViewDidZoomActionKey;
FOUNDATION_EXTERN NSString * const ArgoKitScrollViewWillBeginDraggingActionKey;
FOUNDATION_EXTERN NSString * const ArgoKitScrollViewWillEndDraggingWithVelocityTargetContentOffsetActionKey;
FOUNDATION_EXTERN NSString * const ArgoKitScrollViewDidEndDraggingWillDecelerateActionKey;
FOUNDATION_EXTERN NSString * const ArgoKitScrollViewWillBeginDeceleratingActionKey;
FOUNDATION_EXTERN NSString * const ArgoKitScrollViewDidEndDeceleratingActionKey;
FOUNDATION_EXTERN NSString * const ArgoKitScrollViewDidEndScrollingAnimationActionKey;
FOUNDATION_EXTERN NSString * const ArgoKitScrollViewViewForZoomingActionKey;
FOUNDATION_EXTERN NSString * const ArgoKitScrollViewWillBeginZoomingWithViewActionKey;
FOUNDATION_EXTERN NSString * const ArgoKitScrollViewDidEndZoomingWithViewAtScaleActionKey;
FOUNDATION_EXTERN NSString * const ArgoKitScrollViewShouldScrollToTopActionKey;
FOUNDATION_EXTERN NSString * const ArgoKitScrollViewDidScrollToTopActionKey;
FOUNDATION_EXTERN NSString * const ArgoKitScrollViewDidChangeAdjustedContentInsetActionKey;

@end

NS_ASSUME_NONNULL_END
