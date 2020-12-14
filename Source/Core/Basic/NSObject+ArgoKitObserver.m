//
//  NSObject+ArgoKitObserver.m
//  ArgoKit
//
//  Created by Bruce on 2020/11/20.
//

#import "NSObject+ArgoKitObserver.h"
#import <objc/runtime.h>
@implementation NSObject(ArgoKitObserver)
+ (void)load
{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        SEL removeSel = @selector(removeObserver:forKeyPath:);
//        SEL customRemoveSel = @selector(removeArgoKitObserver:forKeyPath:);
//        SEL addSel = @selector(addObserver:forKeyPath:options:context:);
//        SEL customAddSel = @selector(addArgoKitObserver:forKeyPath:options:context:);
//
//        Method removeMethod = class_getClassMethod([self class],removeSel);
//        Method cRemoveMethod = class_getClassMethod([self class], customRemoveSel);
//        Method addMethod = class_getClassMethod([self class],addSel);
//        Method cAddMethod = class_getClassMethod([self class], customAddSel);
//
//        method_exchangeImplementations(removeMethod, cRemoveMethod);
//        method_exchangeImplementations(addMethod, cAddMethod);
//    });
   
}

#pragma mark - 第三种方案，利用私有属性
// 交换后的方法
- (void)removeArgoKitObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath
{
    if ([self argokitObserverKeyPath:keyPath observer:observer]) {
        [self removeArgoKitObserver:observer forKeyPath:keyPath];
    }
}

// 交换后的方法
- (void)addArgoKitObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    if (![self argokitObserverKeyPath:keyPath observer:observer]) {
        [self addArgoKitObserver:observer forKeyPath:keyPath options:options context:context];
    }
}

// 进行检索获取Key
- (BOOL)argokitObserverKeyPath:(NSString *)key observer:(id )observer
{
    id info = self.observationInfo;
    NSArray *array = [info valueForKey:@"_observances"];
    for (id objc in array) {
        id Properties = [objc valueForKeyPath:@"_property"];
        id newObserver = [objc valueForKeyPath:@"_observer"];
        
        NSString *keyPath = [Properties valueForKeyPath:@"_keyPath"];
        if ([key isEqualToString:keyPath] && [newObserver isEqual:observer]) {
            return YES;
        }
    }
    return NO;
}

@end
