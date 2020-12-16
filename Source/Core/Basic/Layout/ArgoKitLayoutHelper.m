//
//  ArgoKitLayoutHelper.m
//  MMFlexUIKit
//
//  Created by Bruce on 2020/10/15.
//

#import "ArgoKitLayoutHelper.h"
#import "ArgoKitNode.h"
#import "ArgoKitLayoutEngine.h"
#import <os/lock.h>
@interface ArgoKitLayoutHelper(){
    CFRunLoopObserverRef _observer;
}
@property(nonatomic,strong)ArgoKitLayoutEngine *layoutEngine;
@end


@implementation ArgoKitLayoutHelper
static ArgoKitLayoutHelper* _instance;
+ (instancetype)sharedInstance{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _instance = [[self alloc] init];
        [_instance startLayoutEngine];
    });
    return _instance;
}
-(void)dealloc{
    [self stopLayoutEngine];
}
- (ArgoKitLayoutEngine *)layoutEngine{
    if (!_layoutEngine) {
        _layoutEngine = [[ArgoKitLayoutEngine alloc]init];
    }
    return _layoutEngine;
}
+ (void)addLayoutNode:(ArgoKitNode *)node{
    [[ArgoKitLayoutHelper sharedInstance] addLayoutNode:node];
}

+ (void)forLayoutNode:(nullable Class)anyClass{
    [[ArgoKitLayoutHelper sharedInstance].layoutEngine forLayoutNode:anyClass];
}
#pragma mark --- private methods ---
- (void)startLayoutEngine {
    __weak typeof(self)wealSelf = self;
    [self.layoutEngine startRunloop:kCFRunLoopBeforeWaiting | kCFRunLoopExit repeats:true order:0 block:^(ArgoKitNode * _Nonnull node) {
        [wealSelf layout:node];
    }];
}
- (void)stopLayoutEngine{
    [self.layoutEngine stopRunloop];
}
- (void)addLayoutNode:(nullable ArgoKitNode *)node{
    [self.layoutEngine addLayoutNode:node];
}

- (void)removeLayoutNode:(nullable ArgoKitNode *)node{
    [self.layoutEngine removeLayoutNode:node];
}
- (void)layout:(ArgoKitNode *)node{
    if(node && node.isDirty){
        [node applyLayout];
    }
}
@end
