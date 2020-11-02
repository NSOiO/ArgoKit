//
//  ArgoKitNode+ScrollViewDelegate.m
//  ArgoKit
//
//  Created by MOMO on 2020/10/30.
//

#import "ArgoKitNode+ScrollViewDelegate.h"

NSString * const ArgoKitScrollViewDidScrollActionKey = @"ArgoKitScrollViewDidScrollActionKey";
NSString * const ArgoKitScrollViewDidZoomActionKey = @"ArgoKitScrollViewDidZoomActionKey";
NSString * const ArgoKitScrollViewWillBeginDraggingActionKey = @"ArgoKitScrollViewWillBeginDraggingActionKey";
NSString * const ArgoKitScrollViewWillEndDraggingWithVelocityTargetContentOffsetActionKey = @"ArgoKitScrollViewWillEndDraggingWithVelocityTargetContentOffsetActionKey";
NSString * const ArgoKitScrollViewDidEndDraggingWillDecelerateActionKey = @"ArgoKitScrollViewDidEndDraggingWillDecelerateActionKey";
NSString * const ArgoKitScrollViewWillBeginDeceleratingActionKey = @"ArgoKitScrollViewWillBeginDeceleratingActionKey";
NSString * const ArgoKitScrollViewDidEndDeceleratingActionKey = @"ArgoKitScrollViewDidEndDeceleratingActionKey";
NSString * const ArgoKitScrollViewDidEndScrollingAnimationActionKey = @"ArgoKitScrollViewDidEndScrollingAnimationActionKey";
NSString * const ArgoKitScrollViewViewForZoomingActionKey = @"ArgoKitScrollViewViewForZoomingActionKey";
NSString * const ArgoKitScrollViewWillBeginZoomingWithViewActionKey = @"ArgoKitScrollViewWillBeginZoomingWithViewActionKey";
NSString * const ArgoKitScrollViewDidEndZoomingWithViewAtScaleActionKey = @"ArgoKitScrollViewDidEndZoomingWithViewAtScaleActionKey";
NSString * const ArgoKitScrollViewShouldScrollToTopActionKey = @"ArgoKitScrollViewShouldScrollToTopActionKey";
NSString * const ArgoKitScrollViewDidScrollToTopActionKey = @"ArgoKitScrollViewDidScrollToTopActionKey";
NSString * const ArgoKitScrollViewDidChangeAdjustedContentInsetActionKey = @"ArgoKitScrollViewDidChangeAdjustedContentInsetActionKey";

@implementation ArgoKitNode (ScrollViewDelegate)

- (void)scrollViewDidScroll:(UIScrollView *)scrollView; {
    [self sendActionWithObj:ArgoKitScrollViewDidScrollActionKey paramter:nil];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self sendActionWithObj:ArgoKitScrollViewDidZoomActionKey paramter:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self sendActionWithObj:ArgoKitScrollViewWillBeginDraggingActionKey paramter:nil];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [self sendActionWithObj:ArgoKitScrollViewWillEndDraggingWithVelocityTargetContentOffsetActionKey paramter:@[[NSValue valueWithCGPoint:velocity], [NSValue valueWithPointer:targetContentOffset]]];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self sendActionWithObj:ArgoKitScrollViewDidEndDraggingWillDecelerateActionKey paramter:@[@(decelerate)]];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self sendActionWithObj:ArgoKitScrollViewWillBeginDeceleratingActionKey paramter:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self sendActionWithObj:ArgoKitScrollViewDidEndDeceleratingActionKey paramter:nil];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self sendActionWithObj:ArgoKitScrollViewDidEndScrollingAnimationActionKey paramter:nil];
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [self sendActionWithObj:ArgoKitScrollViewViewForZoomingActionKey paramter:nil];
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view {
    [self sendActionWithObj:ArgoKitScrollViewWillBeginZoomingWithViewActionKey paramter:view ? @[view] : nil];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    [self sendActionWithObj:ArgoKitScrollViewDidEndZoomingWithViewAtScaleActionKey paramter:view ? @[@(scale), view] : @[@(scale)]];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    id vaule = [self sendActionWithObj:ArgoKitScrollViewShouldScrollToTopActionKey paramter:nil];
    if (vaule) {
        return [vaule boolValue];
    }
    return scrollView.scrollsToTop;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [self sendActionWithObj:ArgoKitScrollViewDidScrollToTopActionKey paramter:nil];
}

- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView {
    [self sendActionWithObj:ArgoKitScrollViewDidChangeAdjustedContentInsetActionKey paramter:nil];
}

@end
