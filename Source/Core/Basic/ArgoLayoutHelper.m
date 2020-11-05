//
//  ArgoLayoutHelper.m
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/15.
//

#import "ArgoLayoutHelper.h"
#import "ArgoKitNode.h"
#import <os/lock.h>
static CFRunLoopSourceRef _runloopSource = NULL;

static void ArgoSourceContextCallBackLog(void *info) {
}

@interface ArgoLayoutHelper(){
    CFRunLoopObserverRef _observer;
}
@property(nonatomic,strong)NSMutableArray<ArgoKitNode *> *layoutNodesPool;
@end


@implementation ArgoLayoutHelper
static ArgoLayoutHelper* _instance;
+ (instancetype)sharedInstance{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _instance = [[self alloc] init];
        [_instance startRunloop];
    });
    return _instance;
}
-(void)dealloc{
    [self stopRunloop];
}

+ (void)startRunloop{
    [[ArgoLayoutHelper sharedInstance] startRunloop];
}
+ (void)stopRunloop{
    [[ArgoLayoutHelper sharedInstance] stopRunloop];
}

+ (void)addLayoutNode:(ArgoKitNode *)node{
    [[ArgoLayoutHelper sharedInstance] addLayoutNode:node];
}

+ (void)removeLayoutNode:(ArgoKitNode *)node{
    [[ArgoLayoutHelper sharedInstance] removeLayoutNode:node];
}

+ (void)layout{
    [[ArgoLayoutHelper sharedInstance] layout];
}

#pragma mark --- private methods ---
- (NSMutableArray<ArgoKitNode *> *)layoutNodesPool{
    if (!_layoutNodesPool) {
        _layoutNodesPool = [NSMutableArray array];
    }
    return _layoutNodesPool;
}
- (void)startRunloop {
    // 监听主线程runloop操作
    CFRunLoopRef runloop = CFRunLoopGetMain();
    __weak typeof(self)wealSelf = self;
    _observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopBeforeWaiting | kCFRunLoopExit, true, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        [wealSelf layout];
    });
    CFRunLoopAddObserver(runloop, _observer, kCFRunLoopCommonModes);
    
    
    CFRunLoopSourceContext *sourceContext = calloc(1, sizeof(CFRunLoopSourceContext));
    sourceContext->perform = ArgoSourceContextCallBackLog;
    _runloopSource = CFRunLoopSourceCreate(CFAllocatorGetDefault(), 0, sourceContext);
    CFRunLoopAddSource(runloop, _runloopSource, kCFRunLoopCommonModes);
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
    if (node.isRootNode && ![self.layoutNodesPool containsObject:node]) {
        [self.layoutNodesPool addObject:node];
    }
}

- (void)removeLayoutNode:(nullable ArgoKitNode *)node{
    if (node.isRootNode && [self.layoutNodesPool containsObject:node]) {
        [self.layoutNodesPool removeObject:node];
    }
}
- (void)layout{
    NSArray<ArgoKitNode *> *nodes = [self.layoutNodesPool copy];
    for(ArgoKitNode *node in nodes){
        if(node.isDirty){
            [node applyLayout];
        }
    }
}

@end
