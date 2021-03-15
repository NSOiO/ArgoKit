//
//  ArgoKitNode+Observer.m
//  ArgoKit
//
//  Created by Bruce on 2020/11/27.
//

#import "ArgoKitNode+Observer.h"
#import "ArgoKitUtils.h"
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
@property(nonatomic,strong) NSHashTable<ArgoKitNodeObserver *> *nodeObservers;
@end
@implementation ArgoKitNode(Observer)
- (void)addNodeObserver:(ArgoKitNodeObserver *)observer{
    NSArray *nodeObservers = [self.nodeObservers allObjects];
    if (observer && ![nodeObservers containsObject:observer] ) {
        [self.nodeObservers addObject:observer];
    }
}
- (void)removeNodeObserver:(ArgoKitNodeObserver *)observer{
    NSArray *nodeObservers = [self.nodeObservers allObjects];
    if (observer && [nodeObservers containsObject:observer] ) {
        [self.nodeObservers removeObject:observer];
    }
}
- (void)removeAllNodeObservers{
    [self.nodeObservers removeAllObjects];
}

- (void)sendFrameChanged:(CGRect)frame {
    __weak typeof(self)weakSelf = self;
    [ArgoKitUtils runMainThreadAsyncBlock:^{
        [weakSelf _sendFrameChanged:frame];
    }];
}

- (void)_sendFrameChanged:(CGRect)frame {
    NSArray *nodeObservers = [self.nodeObservers allObjects];
    for (ArgoKitNodeObserver *observer in nodeObservers) {
        if (observer.frameChangeBlock) {
            observer.frameChangeBlock(frame);
        }
    }
}


@end
