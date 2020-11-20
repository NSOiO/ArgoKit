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
    [self switchMethod];
}

+ (void)switchMethod
{
    SEL removeSel = @selector(removeObserver:forKeyPath:);
    SEL customRemoveSel = @selector(removeArgoKitObserver:forKeyPath:);
    SEL addSel = @selector(addObserver:forKeyPath:options:context:);
    SEL customAddSel = @selector(addArgoKitObserver:forKeyPath:options:context:);
    
    Method systemRemoveMethod = class_getClassMethod([self class],removeSel);
    Method DasenRemoveMethod = class_getClassMethod([self class], customRemoveSel);
    Method systemAddMethod = class_getClassMethod([self class],addSel);
    Method DasenAddMethod = class_getClassMethod([self class], customAddSel);
    
    method_exchangeImplementations(systemRemoveMethod, DasenRemoveMethod);
    method_exchangeImplementations(systemAddMethod, DasenAddMethod);
}
#pragma mark - 第三种方案，利用私有属性
// 交换后的方法
- (void)removeArgoKitObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath
{
    if ([self observerKeyPath:keyPath observer:observer]) {
        [self removeArgoKitObserver:observer forKeyPath:keyPath];
    }
}

// 交换后的方法
- (void)addArgoKitObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    if (![self observerKeyPath:keyPath observer:observer]) {
        [self addArgoKitObserver:observer forKeyPath:keyPath options:options context:context];
    }
}

// 进行检索获取Key
- (BOOL)observerKeyPath:(NSString *)key observer:(id )observer
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
