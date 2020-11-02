//
//  ArgoKitNode+ScrollViewDelegate.m
//  ArgoKit
//
//  Created by MOMO on 2020/10/30.
//

#import "ArgoKitNode+ScrollViewDelegate.h"

@implementation ArgoKitNode (ScrollViewDelegate)

- (void)scrollViewDidScroll:(UIScrollView *)scrollView; {
    [self sendActionWithObj:NSStringFromSelector(_cmd) paramter:nil];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self sendActionWithObj:NSStringFromSelector(_cmd) paramter:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self sendActionWithObj:NSStringFromSelector(_cmd) paramter:nil];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [self sendActionWithObj:NSStringFromSelector(_cmd) paramter:@[[NSValue valueWithCGPoint:velocity], [NSValue valueWithPointer:targetContentOffset]]];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self sendActionWithObj:NSStringFromSelector(_cmd) paramter:@[@(decelerate)]];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self sendActionWithObj:NSStringFromSelector(_cmd) paramter:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self sendActionWithObj:NSStringFromSelector(_cmd) paramter:nil];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self sendActionWithObj:NSStringFromSelector(_cmd) paramter:nil];
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [self sendActionWithObj:NSStringFromSelector(_cmd) paramter:nil];
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view {
    [self sendActionWithObj:NSStringFromSelector(_cmd) paramter:view ? @[view] : nil];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    [self sendActionWithObj:NSStringFromSelector(_cmd) paramter:view ? @[@(scale), view] : @[@(scale)]];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    id vaule = [self sendActionWithObj:NSStringFromSelector(_cmd) paramter:nil];
    if (vaule) {
        return [vaule boolValue];
    }
    return scrollView.scrollsToTop;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [self sendActionWithObj:NSStringFromSelector(_cmd) paramter:nil];
}

- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView API_AVAILABLE(ios(11.0), tvos(11.0)) {
    [self sendActionWithObj:NSStringFromSelector(_cmd) paramter:nil];
}

@end
