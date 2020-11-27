//
//  ArgoKitNode+Observer.m
//  ArgoKit
//
//  Created by Bruce on 2020/11/27.
//

#import "ArgoKitNode+Observer.h"
@interface ArgoKitNodeObserver()
@property(nonatomic, copy)ArgoKitNodeCreateViewBlock  createViewBlock;
@property(nonatomic, copy)ArgoKitNodeFrameChangeBlock  frameChangeBlock;
@end

@implementation ArgoKitNodeObserver
- (void)setCreateViewBlock:(ArgoKitNodeCreateViewBlock _Nonnull)createViewBlock{
    _createViewBlock = [createViewBlock copy];
}
- (void)setFrameChangeBlock:(ArgoKitNodeFrameChangeBlock _Nonnull)frameChangeBlock{
    _frameChangeBlock= [frameChangeBlock copy];
}
@end
@interface ArgoKitNode()
@property(nonatomic,strong)NSMutableArray<ArgoKitNodeObserver *> *nodeObservers;
@end
@implementation ArgoKitNode(Observer)
- (void)addNodeObserver:(ArgoKitNodeObserver *)observer{
    if (observer && ![self.nodeObservers containsObject:observer] ) {
        [self.nodeObservers addObject:observer];
    }
}
- (void)removeNodeObserver:(ArgoKitNodeObserver *)observer{
    if (observer && [self.nodeObservers containsObject:observer] ) {
        [self.nodeObservers removeObject:observer];
    }
}
- (void)removeAllNodeObservers{
    [self.nodeObservers removeAllObjects];
}
@end
