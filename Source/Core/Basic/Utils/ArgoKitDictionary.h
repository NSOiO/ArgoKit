//
//  ArgoKitDictionary.h
//  ArgoKit
//
//  Created by Bruce on 2020/12/21.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary(ArgoKit)
- (void)create_argokit_lock;
- (void)setArgokit_lock:(NSLock *)argokit_lock;
-(NSArray *)argokit_allKeys;
- (NSArray *)argokit_allValues;
- (void)argokit_setObject:(id)object forKey:(NSString *)key;
- (id)argokit_getObjectForKey:(NSString *)key;
- (void)argokit_setValue:(id)object forKey:(NSString *)key;
- (void)argokit_removeObjectForKey:(NSString *)aKey;
- (void)argokit_removeAllObjects;
- (void)argokit_removeObjectsForKeys:(NSArray *)keyArray;
@end

NS_ASSUME_NONNULL_END
