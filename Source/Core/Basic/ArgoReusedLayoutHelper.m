//
//  ArgoLayoutHelper.m
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/15.
//

#import "ArgoReusedLayoutHelper.h"
#import "ArgoKitNode.h"
#import "ArgoKitNodeViewModifier.h"
#import <os/lock.h>
static CFRunLoopSourceRef _runloopSource = NULL;

static void ArgoSourceContextCallBackLog(void *info) {
}

@interface ArgoReusedLayoutHelper(){
    CFRunLoopObserverRef _observer;
}
@property(nonatomic,strong)NSHashTable<ArgoKitNode *> *layoutNodesPool;
@property(nonatomic,strong)NSHashTable<ArgoKitNode *> *lazyLayoutNodesPool;
@end


@implementation ArgoReusedLayoutHelper
static ArgoReusedLayoutHelper* _instance;
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
    [[ArgoReusedLayoutHelper sharedInstance] startRunloop];
}
+ (void)stopRunloop{
    [[ArgoReusedLayoutHelper sharedInstance] stopRunloop];
}

+ (void)addLayoutNode:(ArgoKitNode *)node{
    [[ArgoReusedLayoutHelper sharedInstance] addLayoutNode:node];
}

+ (void)removeLayoutNode:(ArgoKitNode *)node{
    [[ArgoReusedLayoutHelper sharedInstance] removeLayoutNode:node];
}

+ (void)appLayout:(ArgoKitNode *)node{
    [[ArgoReusedLayoutHelper sharedInstance] layout:node];
}

#pragma mark --- private methods ---
- (NSHashTable<ArgoKitNode *> *)layoutNodesPool{
    if (!_layoutNodesPool) {
        _layoutNodesPool = [NSHashTable weakObjectsHashTable];
    }
    return _layoutNodesPool;
}
- (NSHashTable<ArgoKitNode *> *)lazyLayoutNodesPool{
    if (!_lazyLayoutNodesPool) {
        _lazyLayoutNodesPool = [NSHashTable weakObjectsHashTable];
    }
    return _lazyLayoutNodesPool;
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
            [self layout:node];
        }
    }
}
- (void)layout:(ArgoKitNode *)node{
    [node calculateLayoutWithSize:CGSizeMake(node.size.width, NAN)];
    [node applyLayoutAferCalculationWithView:NO];
    if (node.linkNode) {
        [ArgoKitNodeViewModifier reuseNodeViewAttribute:node.linkNode reuseNode:node];
    }else{
        [ArgoKitNodeViewModifier reuseNodeViewAttribute:node reuseNode:node];
    }
    
}
@end
