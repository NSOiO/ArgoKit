//
//  ArgoKitDictionary.m
//  ArgoKit
//
//  Created by Bruce on 2020/12/21.
//

#import "ArgoKitDictionary.h"
#import <objc/runtime.h>
@interface NSMutableDictionary(ArgoKit)
@property(strong,nonatomic)NSMutableArray *keys;
@end
@implementation NSMutableDictionary(ArgoKit)
- (NSMutableArray *)keys{
    id keys = objc_getAssociatedObject(self,_cmd);
    if (keys) {
        return keys;
    }else{
        keys = [NSMutableArray new];
        objc_setAssociatedObject(self, _cmd, keys, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return keys;
    }
}
- (void)setKeys:(NSMutableArray *)keys{
    objc_setAssociatedObject(self, @selector(setKeys:), keys, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSArray *)argokit_allKeys{
    return self.keys;
}

- (NSArray *)argokit_allValues{
    NSMutableArray *values = [NSMutableArray array];
    for (NSString *key in self.argokit_allKeys) {
        id value = [self valueForKey:key];
        [values addObject:value];
    }
    return values;
}

- (void)addInnnerKey:(id)key{
    if (!key) {
        return;
    }
    if (![self.keys containsObject:key]) {
        [self.keys addObject:key];
    }
}

- (void)removeInnnerKey:(id)key{
    if (!key) {
        return;
    }
    [self.keys removeObject:key];
}

- (void)argokit_setObject:(id)anObject forKey:(id<NSCopying>)aKey{
    [self addInnnerKey:aKey];
    [self setObject:anObject forKey:aKey];
}

- (void)argokit_setValue:(id)value forKey:(NSString *)key{
    [self addInnnerKey:key];
    [self setValue:value forKey:key];
}

// 移除

- (void)argokit_removeObjectForKey:(id)aKey{
    [self removeInnnerKey:aKey];
    [self removeObjectForKey:aKey];
}

- (void)argokit_removeAllObjects{
    [self.keys removeAllObjects];
    
    [self removeAllObjects];
}

- (void)argokit_removeObjectsForKeys:(NSArray *)keyArray{
    [self.keys removeObjectsInArray:keyArray];
    [self removeObjectsForKeys:keyArray];
}
@end
