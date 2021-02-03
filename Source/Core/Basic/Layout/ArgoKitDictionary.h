//
//  ArgoKitDictionary.h
//  ArgoKit
//
//  Created by Bruce on 2020/12/21.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary(ArgoKit)
-(NSArray *)argokit_allKeys;
- (NSArray *)argokit_allValues;
- (void)argokit_setObject:(id)anObject forKey:(id<NSCopying>)aKey;
- (id)argokit_getObjectForKey:(id<NSCopying>)aKey;
- (void)argokit_setValue:(id)value forKey:(NSString *)key;
- (void)argokit_removeObjectForKey:(id)aKey;
- (void)argokit_removeAllObjects;
- (void)argokit_removeObjectsForKeys:(NSArray *)keyArray;
@end

NS_ASSUME_NONNULL_END
