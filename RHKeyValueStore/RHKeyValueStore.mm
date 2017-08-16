//
//  RHKeyValueStore.m
//  KVStoreDemo
//
//  Created by ran on 2017/8/16.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "RHKeyValueStore.h"
#import <WCDB.h>

@interface RHKeyValueStore ()

@end

@implementation RHKeyValueStore

#pragma mark - Initialization
+ (instancetype)store {
    static dispatch_once_t onceToken;
    static RHKeyValueStore *kvStore;
    dispatch_once(&onceToken, ^{
        kvStore = [[RHKeyValueStore alloc] initStore:nil];
    });
    return kvStore;
}

+ (instancetype)storeWithLabel:(NSString *)label {
    if (!label) {
        return [RHKeyValueStore store];
    }
    
    static dispatch_once_t onceToken;
    static RHKeyValueStore *kvStore;
    dispatch_once(&onceToken, ^{
        kvStore = [[RHKeyValueStore alloc] initStore:label];
    });
    return kvStore;
}

- (instancetype)initStore:(NSString *)isolation {
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark - Getters & Helpers
- (NSArray<NSString *> *)allKeys {
    return nil;
}

- (NSUInteger)getKVCount {
    return 0;
}

- (BOOL)clear {
    return NO;
}

#pragma mark - Integer
- (NSInteger)integerForKey:(NSString *)key {
    return 0;
}

- (NSInteger)integerForKey:(NSString *)key defaultValue:(NSInteger)defaultValue {
    return 0;
}

- (BOOL)setInteger:(NSInteger)value forKey:(NSString *)key {
    return NO;
}

#pragma mark - Boolean
- (BOOL)boolForKey:(NSString *)key {
    return NO;
}

- (BOOL)boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue {
    return NO;
}

- (BOOL)setBool:(BOOL)value forKey:(NSString *)key {
    return NO;
}

#pragma mark - Double
- (double)doubleForKey:(NSString *)key {
    return 0.0;
}

- (double)doubleForKey:(NSString *)key defaultValue:(double)defaultValue {
    return 0.0;
}

- (BOOL)setDouble:(double)value forKey:(NSString *)key {
    return NO;
}

#pragma mark - String
- (NSString *)stringForKey:(NSString *)key {
    return nil;
}

- (BOOL)setString:(NSString *)value forKey:(NSString *)key {
    return NO;
}

#pragma mark - Object
- (id)jsonObjectForKey:(NSString *)key {
    return nil;
}

- (BOOL)setJsonObject:(id)value forKey:(NSString *)key {
    return NO;
}

- (id)unarchiveObjectForKey:(NSString *)key {
    return nil;
}
- (BOOL)setArchiveObject:(id)value forKey:(NSString *)key {
    return NO;
}

@end
