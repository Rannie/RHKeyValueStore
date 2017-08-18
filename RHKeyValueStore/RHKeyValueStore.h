//
//  RHKeyValueStore.h
//  KVStoreDemo
//
//  Created by ran on 2017/8/16.
//  Copyright © 2017年 ran. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef KeyValueStore
#define KeyValueStore [RHKeyValueStore store]
#endif

@interface RHKeyValueStore : NSObject

/**
 Database path.
 */
@property (nonatomic, strong, readonly) NSString *path;


/**
 Global key value storage instance.

 @return store instance
 */
+ (instancetype)store;

/**
 Isolation storage.

 @param label isolating string
 @return store instance
 */
+ (instancetype)storeWithLabel:(NSString *)label;

- (instancetype)init NS_UNAVAILABLE;

/**
 Get all keys.

 @return key list
 */
- (NSArray<NSString *> *)allKeys;

/**
 Get K-V pair count.
 
 @return kv count number
 */
- (NSUInteger)getKVCount;

/**
 Clear all data of current table

 @return query success or not
 */
- (BOOL)clear;

/**
 Get integer value for the specified key, if no data return 0.

 @param key key
 @return integer value
 */
- (NSInteger)integerForKey:(NSString *)key;

/**
 Get integer value for the specified key, if no data return default value.

 @param key key
 @param defaultValue default result value
 @return query success or not
 */
- (NSInteger)integerForKey:(NSString *)key defaultValue:(NSInteger)defaultValue;

/**
 Set integer value for the specified key.

 @param value integer value
 @param key key
 @return insert success or not
 */
- (BOOL)setInteger:(NSInteger)value forKey:(NSString *)key;

/**
 Get bool value for the specified key, if no data return NO.

 @param key key
 @return query success or not
 */
- (BOOL)boolForKey:(NSString *)key;

/**
 Get bool value for the spcified key, if no data return default value.

 @param key key
 @param defaultValue default result value
 @return query success or not
 */
- (BOOL)boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue;

/**
 Set bool value for the specified key.
 
 @param value bool value
 @param key key
 @return insert success or not
 */
- (BOOL)setBool:(BOOL)value forKey:(NSString *)key;

/**
 Get double value for the specified key, if no data return 0.0.
 
 @param key key
 @return query success or not
 */
- (double)doubleForKey:(NSString *)key;

/**
 Get double value for the spcified key, if no data return default value.
 
 @param key key
 @param defaultValue default result value
 @return query success or not
 */
- (double)doubleForKey:(NSString *)key defaultValue:(double)defaultValue;

/**
 Set double value for the specified key.
 
 @param value double value
 @param key key
 @return insert success or not
 */
- (BOOL)setDouble:(double)value forKey:(NSString *)key;

/**
 Get string value for the specified key, if no data return nil.
 
 @param key key
 @return query success or not
 */
- (NSString *)stringForKey:(NSString *)key;

/**
 Set string value for the specified key.
 
 @param value string value
 @param key key
 @return insert success or not
 */
- (BOOL)setString:(NSString *)value forKey:(NSString *)key;

/**
 Get JSON decoded object for the specified key.

 @param key key
 @return json object (dict/array)
 */
- (id)jsonObjectForKey:(NSString *)key;

/**
 Set JSON encoded object for the specified key, must transfer object to json object (NSDictionary/NSArray) first.

 @param value json object (dict/array)
 @param key key
 @return insert success or not
 */
- (BOOL)setJsonObject:(id)value forKey:(NSString *)key;

/**
 Get object for the specified key.

 @param key key
 @return result object
 */
- (id)unarchiveObjectForKey:(NSString *)key;

/**
 Set object for the spcified key, object class must confirm NSCoding protocol and implement `initWithCoder:` `encodeWithCoder:` methods.

 @param value object
 @param key key
 @return insert success or not
 */
- (BOOL)setArchiveObject:(id)value forKey:(NSString *)key;

@end
