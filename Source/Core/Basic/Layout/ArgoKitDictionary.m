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
@property(strong,atomic)NSLock *argokit_lock;
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
        lock = [[NSLock alloc] init];
        objc_setAssociatedObject(self, _cmd, lock, OBJC_ASSOCIATION_RETAIN);
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

- (void)addInnnerKey:(NSString *)key{
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

- (void)argokit_setObject:(id)object forKey:(NSString *)key{
    if(!object){
        return;
    }
    [self.argokit_lock lock];
    [self addInnnerKey:key];
    [self setObject:object forKey:key];
    [self.argokit_lock unlock];
}
- (id)argokit_getObjectForKey:(NSString *)key{
    id object = nil;
    [self.argokit_lock lock];
    object = [self objectForKey:key];
    [self.argokit_lock unlock];
    return object;
}

- (void)argokit_setValue:(id)object forKey:(NSString *)key{
    if(!object){
        return;
    }
    [self.argokit_lock lock];
    [self addInnnerKey:key];
    [self setValue:object forKey:key];
    [self.argokit_lock unlock];
}

- (void)argokit_removeObjectForKey:(NSString *)aKey{
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
