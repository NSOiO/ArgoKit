//
//  ArgoKitDictionary.m
//  ArgoKit
//
//  Created by Bruce on 2020/12/21.
//

#import "ArgokitThreadSafeDictionary.h"
#import <pthread.h>

// 需要预先定义一个实例变量 pthread_mutex_t _lock;
#define Argokit_Mutex_LockInit() _lock = [[NSLock alloc] init]
#define Argokit_Mutex_Lock()  [self.lock lock]
#define Argokit_Mutex_UnLock() [self.lock unlock]
#define Argokit_Mutex_LockDestroy() _lock = nil

#define ThreadSafeHandle(...) Argokit_Mutex_Lock(); \
__VA_ARGS__; \
Argokit_Mutex_UnLock();

@interface ArgokitThreadSafeDictionary()
@property(nonatomic, strong)NSMutableDictionary *dic;
@property(nonatomic, strong)NSLock *lock;
@end
@implementation ArgokitThreadSafeDictionary
- (instancetype)init
{
    self = [super init];
    if (self) {
        Argokit_Mutex_LockInit();
      _dic = [[NSMutableDictionary alloc] init];
    }
    return self;
}
- (void)dealloc
{
    Argokit_Mutex_LockDestroy();
}

- (instancetype)initWithDictionary:(NSDictionary *)adictionary
{
    self = [super init];
    if (self) {
        Argokit_Mutex_LockInit();
        _dic = [[NSMutableDictionary alloc] initWithDictionary:adictionary];
    }
    return self;
}

- (instancetype)initWithCapacity:(NSUInteger)numItems
{
    self = [super init];
    if (self) {
        Argokit_Mutex_LockInit();
        _dic = [[NSMutableDictionary alloc] initWithCapacity:numItems];
    }
    return self;
}

#pragma mark -- handle

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    ThreadSafeHandle([_dic setObject:anObject forKey:aKey]);
}

- (id)objectForKey:(id)aKey
{
    ThreadSafeHandle(id  obj = [_dic objectForKey:aKey]);
    return obj;
}

- (NSArray *)allKeys
{
    ThreadSafeHandle(NSArray * array = [_dic allKeys]);
    return array;
}

- (NSArray *)allValues
{
    ThreadSafeHandle(NSArray * array = [_dic allValues]);
    return array;
}

- (NSEnumerator *)keyEnumerator
{
    ThreadSafeHandle(NSEnumerator * enumerator = [_dic keyEnumerator]);
    return enumerator;
}

- (NSEnumerator *)objectEnumerator
{
    ThreadSafeHandle(NSEnumerator * enumerator = [_dic objectEnumerator]);
    return enumerator;
}

- (void)enumerateKeysAndObjectsUsingBlock:(void (NS_NOESCAPE^)(id key, id obj, BOOL *stop))block
{
    ThreadSafeHandle([_dic enumerateKeysAndObjectsUsingBlock:block]);
}

- (void)enumerateKeysAndObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (NS_NOESCAPE^)(id key, id obj, BOOL *stop))block
{
    ThreadSafeHandle([_dic enumerateKeysAndObjectsWithOptions:opts usingBlock:block]);
}

- (void)removeObjectForKey:(id)aKey
{
    ThreadSafeHandle([_dic removeObjectForKey:aKey]);
}

- (void)removeAllObjects
{
    ThreadSafeHandle([_dic removeAllObjects]);
}

- (void)removeObjectsForKeys:(NSArray *)keyArray
{
    ThreadSafeHandle([_dic removeObjectsForKeys:keyArray]);
}

- (NSUInteger)count
{
    ThreadSafeHandle(NSUInteger count = _dic.count);
    return count;
}

// copy

- (id)copyWithZone:(NSZone *)zone
{
    return [self mutableCopyWithZone:zone];
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    ThreadSafeHandle(id adictionary = [[self.class allocWithZone:zone] initWithDictionary:_dic]);
    return adictionary;
}

- (NSUInteger)hash {
    ThreadSafeHandle(NSUInteger hash = [_dic hash]);
    return hash;
}

// NSCoding
- (Class)classForCoder
{
    return [self class];
}

@end
