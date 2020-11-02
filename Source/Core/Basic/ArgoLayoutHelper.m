//
//  ArgoLayoutHelper.m
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/15.
//

#import "ArgoLayoutHelper.h"
#import "ArgoKitNode.h"
#import <os/lock.h>
static NSMutableArray<dispatch_block_t> *_asyncTaskQueue = nil;
static CFRunLoopSourceRef _runloopSource = NULL;

static void Argolock(dispatch_block_t callback) {
    if (!callback) {
        return;
    }
    if (@available(iOS 10.0, *)) {
        static os_unfair_lock lock = OS_UNFAIR_LOCK_INIT;
        os_unfair_lock_lock(&lock);
        callback();
        os_unfair_lock_unlock(&lock);
    }
    else {
        static dispatch_semaphore_t lock = NULL;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            lock = dispatch_semaphore_create(1);
        });
        dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
        callback();
        dispatch_semaphore_signal(lock);
    }
}

static dispatch_queue_t ArgoLayoutCalculateQueue() {
    static dispatch_queue_t calculateQueue = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calculateQueue = dispatch_queue_create("queue.layout.calculate.argo", dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INTERACTIVE, 0));
    });
    return calculateQueue;
}

static void ArgoAddAsyncTaskBlockWithCompleteCallback(bool isAsync,dispatch_block_t task, dispatch_block_t complete) {
    if (task == nil) return;
    _asyncTaskQueue = [[NSMutableArray alloc] init];
    if (isAsync) {
        dispatch_async(ArgoLayoutCalculateQueue(), ^{
            task();
            if (complete == nil) {
                return;
            }
            Argolock(^{
                [_asyncTaskQueue addObject:complete];
                CFRunLoopSourceSignal(_runloopSource);
                CFRunLoopWakeUp(CFRunLoopGetMain());
            });
        });
    }
}

static void ArgoExecuteAsyncTasks() {
    Argolock(^{
        // onComplete block
        for (dispatch_block_t task in _asyncTaskQueue) {
            task();
        }
        [_asyncTaskQueue removeAllObjects];
    });
}

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
    });
    return _instance;
}
-(void)dealloc{
    [self startRunloop];
}

+ (void)startRunloop{
    [[ArgoLayoutHelper sharedInstance] stopRunloop];
}
+ (void)stopRunloop{
    [[ArgoLayoutHelper sharedInstance] stopRunloop];
}

#pragma mark --- private methods ---
- (void)startRunloop {
    // 监听主线程runloop操作
    CFRunLoopRef runloop = CFRunLoopGetMain();
    _observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopBeforeWaiting | kCFRunLoopExit, true, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        ArgoExecuteAsyncTasks();
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

- (void)addLayoutNode:(ArgoKitNode *)node{
    
}

- (void)removeLayoutNode:(ArgoKitNode *)node{
    
}

+ (void)argoLayoutCalculateTask:(dispatch_block_t)calculateTask onComplete:(dispatch_block_t)onComplete {
    if (!calculateTask) {
        return;
    }
    ArgoAddAsyncTaskBlockWithCompleteCallback(YES,calculateTask, onComplete);
}
@end
