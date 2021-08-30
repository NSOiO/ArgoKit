//
//  ArgoKitLayoutEngine.m
//  ArgoKit
//
//  Created by Bruce on 2020/11/27.
//

#import "ArgoKitLayoutEngine.h"
#import "ArgoKitNode.h"
#import "ArgoKitNodePrivateHeader.h"
@interface ArgoKitLayoutEngine(){
    CFRunLoopObserverRef _observer;
}
@property(nonatomic,strong)NSHashTable<ArgoKitNode *> *layoutNodesPool;
@end
@implementation ArgoKitLayoutEngine
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(void)dealloc{
    [self stopRunloop];
}

#pragma mark --- private methods ---
- (NSHashTable<ArgoKitNode *> *)layoutNodesPool{
    if (!_layoutNodesPool) {
        _layoutNodesPool = [NSHashTable weakObjectsHashTable];
    }
    return _layoutNodesPool;
}
- (void)startRunloop:(CFOptionFlags)activities repeats:(Boolean) repeats order:(CFIndex)order block:(void(^)(ArgoKitNode *node))block{
    // 监听主线程runloop操作
    CFRunLoopRef runloop = CFRunLoopGetMain();
    __weak typeof(self)weakSelf = self;
    _observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), activities, repeats, order, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        [weakSelf layout:block];
    });
    CFRunLoopAddObserver(runloop, _observer, kCFRunLoopCommonModes);
}
- (void)stopRunloop{
    if (_observer) {
        if (CFRunLoopContainsObserver(CFRunLoopGetMain(), _observer, kCFRunLoopCommonModes)) {
            CFRunLoopRemoveObserver(CFRunLoopGetMain(), _observer, kCFRunLoopCommonModes);
        }
        CFRelease(_observer);
        _observer = nil;
    }
}

- (void)addLayoutNode:(nullable ArgoKitNode *)node{
    NSArray *nodes = self.layoutNodesPool.allObjects;
    if (node.isRootNode && ![nodes containsObject:node]) {
        [self.layoutNodesPool addObject:node];
    }
}

- (void)removeLayoutNode:(nullable ArgoKitNode *)node{
    NSArray *nodes = self.layoutNodesPool.allObjects;
    if (node.isRootNode && [nodes containsObject:node]) {
        [self.layoutNodesPool removeObject:node];
    }
}
- (void)layout:(void(^)(ArgoKitNode *node))block{
    @autoreleasepool {
        NSArray *nodes = self.layoutNodesPool.allObjects;
        for(ArgoKitNode *node in nodes){
            if (block) {
                block(node);
            }
        }
    }
}


- (void)reLayoutNode:(nullable NSArray *)cellNodes frame:(CGRect)frame{
    NSArray<ArgoKitNode *> *nodes = [self.layoutNodesPool allObjects];
    for (id node in cellNodes) {
        if ([node isKindOfClass:[ArgoKitNode class]] && [nodes containsObject:node] ) {
            [node applyLayout:CGSizeMake(frame.size.width,NAN)];
        }
    }
}
@end
