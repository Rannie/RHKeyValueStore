//
//  RHKeyValueStore.m
//  KVStoreDemo
//
//  Created by ran on 2017/8/16.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "RHKeyValueStore.h"
#import <WCDB.h>

#define KVStoreModule @"[RHKeyValueStore]:"

#ifdef DEBUG
#define KVLog(...) NSLog(@"%@ %@", KVStoreModule, [NSString stringWithFormat:__VA_ARGS__])
#else
#define KVLog(...)
#endif

@interface NSData (RHKeyValueStore)
- (nullable NSString *)rhkv_base64EncodedString;
+ (nullable NSData *)rhkv_dataWithBase64EncodedString:(NSString *)base64EncodedString;
@end

@interface RHKeyValueModel : NSObject <WCTTableCoding>

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *value;

@end

@implementation RHKeyValueModel

WCDB_IMPLEMENTATION(RHKeyValueModel)
WCDB_SYNTHESIZE(RHKeyValueModel, key)
WCDB_SYNTHESIZE(RHKeyValueModel, value)

WCDB_PRIMARY(RHKeyValueModel, key)

@end

static NSString * const kGlobalTableName = @"kvtable";

@interface RHKeyValueStore ()

@property (nonatomic, strong) WCTDatabase *database;
@property (nonatomic, strong, readonly) NSString *tableName;
@property (nonatomic, strong) NSString *isolationLabel;

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
    
    if (![kvStore.isolationLabel isEqualToString:label]) {
        kvStore.isolationLabel = label;
    }
    return kvStore;
}

- (instancetype)initStore:(NSString *)isolation {
    if (self = [super init]) {
        _isolationLabel = isolation;
        if (![self.database canOpen]) {
            KVLog(@"(ERROR) database can't open!");
        }
        [self.database createTableAndIndexesOfName:self.tableName
                                         withClass:RHKeyValueModel.class];
        KVLog(@"create or update table success");
    }
    return self;
}

#pragma mark - Getters & Helpers
- (NSString *)path {
    static dispatch_once_t onceToken;
    static NSString *path;
    dispatch_once(&onceToken, ^{
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        path = [documentPath stringByAppendingPathComponent:@"keyvalue/rhstore.db"];
    });
    return path;
}

- (WCTDatabase *)database {
    if (!_database) {
        _database = [[WCTDatabase alloc] initWithPath:self.path];
    }
    return _database;
}

- (NSString *)tableName {
    if (!self.isolationLabel) {
        return kGlobalTableName;
    } else {
        return [NSString stringWithFormat:@"%@_%@", kGlobalTableName, self.isolationLabel];
    }
}

- (void)setIsolationLabel:(NSString *)isolationLabel {
    _isolationLabel = isolationLabel;
    [self.database createTableAndIndexesOfName:self.tableName
                                     withClass:RHKeyValueModel.class];
    KVLog(@"create or update table success");
}

- (NSArray<NSString *> *)allKeys {
    return (NSArray *)[self.database getOneColumnOnResult:RHKeyValueModel.key
                                            fromTable:self.tableName];
}

- (NSUInteger)getKVCount {
    return [[self.database getOneValueOnResult:RHKeyValueModel.key.count()
                                 fromTable:self.tableName] unsignedIntegerValue];
}

- (BOOL)clear {
    return [self.database deleteAllObjectsFromTable:self.tableName];
}

- (RHKeyValueModel *)getModelForKey:(NSString *)key {
    return [self.database getOneObjectOfClass:RHKeyValueModel.class
                                    fromTable:self.tableName
                                        where:RHKeyValueModel.key == key];
}

- (void)logReplaceIntoLogForKey:(NSString *)key ret:(BOOL)success {
    NSString *retDes = success?@"success":@"failed";
    KVLog(@"replace into kvpair{key:%@} %@", key, retDes);
}

#pragma mark - Integer
- (BOOL)setInteger:(NSInteger)value forKey:(NSString *)key {
    NSParameterAssert(key);
    RHKeyValueModel *kvm = [[RHKeyValueModel alloc] init];
    kvm.key = key;
    kvm.value = [NSString stringWithFormat:@"%zd", value];
    
    BOOL ret = [self.database insertOrReplaceObject:kvm
                                               into:self.tableName];
    [self logReplaceIntoLogForKey:key ret:ret];
    return ret;
}

- (NSInteger)integerForKey:(NSString *)key {
    return [self integerForKey:key defaultValue:0];
}

- (NSInteger)integerForKey:(NSString *)key defaultValue:(NSInteger)defaultValue {
    NSParameterAssert(key);
    RHKeyValueModel *kvm = [self getModelForKey:key];
    if (kvm) {
        return [kvm.value integerValue];
    } else {
        return defaultValue;
    }
}

#pragma mark - Boolean
- (BOOL)setBool:(BOOL)value forKey:(NSString *)key {
    NSParameterAssert(key);
    RHKeyValueModel *kvm = [[RHKeyValueModel alloc] init];
    kvm.key = key;
    kvm.value = [NSString stringWithFormat:@"%zd", value?1:0];
    
    BOOL ret = [self.database insertOrReplaceObject:kvm
                                               into:self.tableName];
    [self logReplaceIntoLogForKey:key ret:ret];
    return ret;
}

- (BOOL)boolForKey:(NSString *)key {
    return [self boolForKey:key defaultValue:NO];
}

- (BOOL)boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue {
    NSParameterAssert(key);
    RHKeyValueModel *kvm = [self getModelForKey:key];
    if (kvm) {
        return [kvm.value boolValue];
    } else {
        return defaultValue;
    }
}

#pragma mark - Double
- (BOOL)setDouble:(double)value forKey:(NSString *)key {
    NSParameterAssert(key);
    RHKeyValueModel *kvm = [[RHKeyValueModel alloc] init];
    kvm.key = key;
    kvm.value = [NSString stringWithFormat:@"%lf", value];
    
    BOOL ret = [self.database insertOrReplaceObject:kvm
                                               into:self.tableName];
    [self logReplaceIntoLogForKey:key ret:ret];
    return ret;
}

- (double)doubleForKey:(NSString *)key {
    return [self doubleForKey:key defaultValue:0.0];
}

- (double)doubleForKey:(NSString *)key defaultValue:(double)defaultValue {
    NSParameterAssert(key);
    RHKeyValueModel *kvm = [self getModelForKey:key];
    if (kvm) {
        return [kvm.value doubleValue];
    } else {
        return defaultValue;
    }
}

#pragma mark - String
- (BOOL)setString:(NSString *)value forKey:(NSString *)key {
    NSParameterAssert(key);
    NSParameterAssert(value);
    RHKeyValueModel *kvm = [[RHKeyValueModel alloc] init];
    kvm.key = key;
    kvm.value = value;
    
    BOOL ret = [self.database insertOrReplaceObject:kvm
                                               into:self.tableName];
    [self logReplaceIntoLogForKey:key ret:ret];
    return ret;
}

- (NSString *)stringForKey:(NSString *)key {
    NSParameterAssert(key);
    RHKeyValueModel *kvm = [self getModelForKey:key];
    if (kvm) {
        return kvm.value;
    }
    return nil;
}

#pragma mark - Object
- (BOOL)setJsonObject:(id)value forKey:(NSString *)key {
    NSParameterAssert(key);
    NSParameterAssert(value);
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:value options:0 error:&error];
    if (error) {
        KVLog(@"failed serialize object for key %@ error -- %@", key, error.localizedDescription);
        return NO;
    }
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    RHKeyValueModel *kvm = [[RHKeyValueModel alloc] init];
    kvm.key = key;
    kvm.value = jsonStr;
    
    BOOL ret = [self.database insertOrReplaceObject:kvm
                                               into:self.tableName];
    [self logReplaceIntoLogForKey:key ret:ret];
    return ret;
}

- (id)jsonObjectForKey:(NSString *)key {
    NSParameterAssert(key);
    RHKeyValueModel *kvm = [self getModelForKey:key];
    if (kvm) {
        NSString *jsonStr = kvm.value;
        NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        id jsonObj = [NSJSONSerialization JSONObjectWithData:data
                                                     options:NSJSONReadingAllowFragments
                                                       error:&error];
        if (error) {
            KVLog(@"failed parse json for key %@ error -- %@", key, error.localizedDescription);
            return nil;
        }
        return jsonObj;
    }
    return nil;
}

- (BOOL)setArchiveObject:(id)value forKey:(NSString *)key {
    NSParameterAssert(key);
    
    if (![value conformsToProtocol:@protocol(NSCoding)]) {
        KVLog(@"archive obj not conform <NSCoding> protocol");
    }
    
    BOOL ret = NO;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:value];
    if (data) {
        NSString *str = [data rhkv_base64EncodedString];
        RHKeyValueModel *kvm = [[RHKeyValueModel alloc] init];
        kvm.key = key;
        kvm.value = str;
        
        ret = [self.database insertOrReplaceObject:kvm
                                              into:self.tableName];
        [self logReplaceIntoLogForKey:key ret:ret];
    }
    return ret;
}

- (id)unarchiveObjectForKey:(NSString *)key {
    NSParameterAssert(key);
    RHKeyValueModel *kvm = [self getModelForKey:key];
    if (kvm) {
        NSString *dataStr = kvm.value;
        NSData *data = [NSData rhkv_dataWithBase64EncodedString:dataStr];
        id obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return obj;
    }
    return nil;
}

@end

@implementation NSData (RHKeyValueStore)

static const char base64EncodingTable[65]
= "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static const short base64DecodingTable[256] = {
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1, -2,  -1,  -1, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,  -2,  -2, -2, -2,
    -1, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, 62,  -2,  -2, -2, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -2, -2,  -2,  -2, -2, -2,
    -2, 0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  10,  11,  12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -2,  -2,  -2, -2, -2,
    -2, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36,  37,  38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -2,  -2,  -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,  -2,  -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,  -2,  -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,  -2,  -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,  -2,  -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,  -2,  -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,  -2,  -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,  -2,  -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,  -2,  -2, -2, -2
};

- (NSString *)rhkv_base64EncodedString {
    NSUInteger length = self.length;
    if (length == 0)
        return @"";
    
    NSUInteger out_length = ((length + 2) / 3) * 4;
    uint8_t *output = (uint8_t *)malloc(((out_length + 2) / 3) * 4);
    if (output == NULL)
        return nil;
    
    const char *input = (char *)self.bytes;
    NSInteger i, value;
    for (i = 0; i < length; i += 3) {
        value = 0;
        for (NSInteger j = i; j < i + 3; j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        NSInteger index = (i / 3) * 4;
        output[index + 0] = base64EncodingTable[(value >> 18) & 0x3F];
        output[index + 1] = base64EncodingTable[(value >> 12) & 0x3F];
        output[index + 2] = ((i + 1) < length)
        ? base64EncodingTable[(value >> 6) & 0x3F]
        : '=';
        output[index + 3] = ((i + 2) < length)
        ? base64EncodingTable[(value >> 0) & 0x3F]
        : '=';
    }
    
    NSString *base64 = [[NSString alloc] initWithBytes:output
                                                length:out_length
                                              encoding:NSASCIIStringEncoding];
    free(output);
    return base64;
}

+ (NSData *)rhkv_dataWithBase64EncodedString:(NSString *)base64EncodedString {
    NSInteger length = base64EncodedString.length;
    const char *string = [base64EncodedString cStringUsingEncoding:NSASCIIStringEncoding];
    if (string  == NULL)
        return nil;
    
    while (length > 0 && string[length - 1] == '=')
        length--;
    
    NSInteger outputLength = length * 3 / 4;
    NSMutableData *data = [NSMutableData dataWithLength:outputLength];
    if (data == nil)
        return nil;
    if (length == 0)
        return data;
    
    uint8_t *output =  (uint8_t *)data.mutableBytes;
    NSInteger inputPoint = 0;
    NSInteger outputPoint = 0;
    while (inputPoint < length) {
        char i0 = string[inputPoint++];
        char i1 = string[inputPoint++];
        char i2 = inputPoint < length ? string[inputPoint++] : 'A';
        char i3 = inputPoint < length ? string[inputPoint++] : 'A';
        
        output[outputPoint++] = (base64DecodingTable[i0] << 2)
        | (base64DecodingTable[i1] >> 4);
        if (outputPoint < outputLength) {
            output[outputPoint++] = ((base64DecodingTable[i1] & 0xf) << 4)
            | (base64DecodingTable[i2] >> 2);
        }
        if (outputPoint < outputLength) {
            output[outputPoint++] = ((base64DecodingTable[i2] & 0x3) << 6)
            | base64DecodingTable[i3];
        }
    }
    
    return data;
}

@end
