//
//  ArgoKitDictionary.m
//  ArgoKit
//
//  Created by Bruce on 2020/12/21.
//

#import "ArgoKitDictionary.h"
#import <objc/runtime.h>
@interface NSMutableDictionary(ArgoKit)
@property(strong,nonatomic)NSMutableArray *argokit_keys;
@property(strong,nonatomic)NSLock *argokit_lock;
@end
@implementation NSMutableDictionary(ArgoKit)
- (NSMutableArray *)argokit_keys{
    id keys = objc_getAssociatedObject(self,_cmd);
    if (keys) {
        return keys;
    }else{
        keys = [NSMutableArray new];
        objc_setAssociatedObject(self, _cmd, keys, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return keys;
    }
}

- (NSLock *)argokit_lock{
    id lock = objc_getAssociatedObject(self, _cmd);
    if (lock) {
        return lock;
    }else{
        lock = [NSLock new];
        objc_setAssociatedObject(self, _cmd, lock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return lock;
    }
}

-(NSArray *)argokit_allKeys{
    return self.argokit_keys;
}

- (NSArray *)argokit_allValues{
    NSMutableArray *values = [NSMutableArray array];
    [self.argokit_lock lock];
    for (NSString *key in self.argokit_allKeys) {
        id value = [self valueForKey:key];
        [values addObject:value];
    }
    [self.argokit_lock unlock];
    return values;
}

- (void)addInnnerKey:(id)key{
    if (!key) {
        return;
    }
    if (![self.argokit_keys containsObject:key]) {
        [self.argokit_keys addObject:key];
    }
}

- (void)removeInnnerKey:(id)key{
    if (!key) {
        return;
    }
    [self.argokit_keys removeObject:key];
}

- (void)argokit_setObject:(id)anObject forKey:(id<NSCopying>)aKey{
    [self.argokit_lock lock];
    [self addInnnerKey:aKey];
    [self setObject:anObject forKey:aKey];
    [self.argokit_lock unlock];
}
- (id)argokit_getObjectForKey:(id<NSCopying>)aKey{
    id object = nil;
    [self.argokit_lock lock];
    object = [self objectForKey:aKey];
    [self.argokit_lock unlock];
    return object;
}

- (void)argokit_setValue:(id)value forKey:(NSString *)key{
    [self.argokit_lock lock];
    [self addInnnerKey:key];
    [self setValue:value forKey:key];
    [self.argokit_lock unlock];
}

- (void)argokit_removeObjectForKey:(id)aKey{
    [self.argokit_lock lock];
    [self removeInnnerKey:aKey];
    [self removeObjectForKey:aKey];
    [self.argokit_lock unlock];
}

- (void)argokit_removeAllObjects{
    [self.argokit_lock lock];
    [self.argokit_keys removeAllObjects];
    [self removeAllObjects];
    [self.argokit_lock unlock];
}

- (void)argokit_removeObjectsForKeys:(NSArray *)keyArray{
    [self.argokit_lock lock];
    [self.argokit_keys removeObjectsInArray:keyArray];
    [self removeObjectsForKeys:keyArray];
    [self.argokit_lock unlock];
}
@end
