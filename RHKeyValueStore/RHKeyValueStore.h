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

/// 数据库路径
@property (nonatomic, strong, readonly) NSString *path;

/// 全局 KV 存储
+ (instancetype)store;
/// 隔离数据 KV 存储 (如果 label 为 nil，则返回全局 store)
+ (instancetype)storeWithLabel:(NSString *)label;

- (instancetype)init NS_UNAVAILABLE;

/// 全部键数组
- (NSArray<NSString *> *)allKeys;
/// kv 个数
- (NSUInteger)getKVCount;

/// 清空当前表所有数据
- (BOOL)clear;

/// default is 0
- (NSInteger)integerForKey:(NSString *)key;
- (NSInteger)integerForKey:(NSString *)key defaultValue:(NSInteger)defaultValue; // 如果查不到，返回默认值
- (BOOL)setInteger:(NSInteger)value forKey:(NSString *)key;

/// default is NO
- (BOOL)boolForKey:(NSString *)key;
- (BOOL)boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue;
- (BOOL)setBool:(BOOL)value forKey:(NSString *)key;

/// default is 0.0
- (double)doubleForKey:(NSString *)key;
- (double)doubleForKey:(NSString *)key defaultValue:(double)defaultValue;
- (BOOL)setDouble:(double)value forKey:(NSString *)key;

- (NSString *)stringForKey:(NSString *)key;
- (BOOL)setString:(NSString *)value forKey:(NSString *)key;

/// return JSON object (array/dict...)
- (id)jsonObjectForKey:(NSString *)key;
- (BOOL)setJsonObject:(id)value forKey:(NSString *)key;

/// get object by unarchive
- (id)unarchiveObjectForKey:(NSString *)key;
- (BOOL)setArchiveObject:(id)value forKey:(NSString *)key;

@end
