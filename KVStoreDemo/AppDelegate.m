//
//  AppDelegate.m
//  KVStoreDemo
//
//  Created by ran on 2017/8/16.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "AppDelegate.h"
#import "RHKeyValueStore.h"
#import <NSObject+YYModel.h>

@interface TestObject : NSObject <NSCoding>
@property (nonatomic, strong) NSString *host;
@property (nonatomic, strong) NSString *ipAddress;
@property (nonatomic, assign) NSInteger count;
@end

@implementation TestObject

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.host = [aDecoder decodeObjectForKey:@"host"];
        self.ipAddress = [aDecoder decodeObjectForKey:@"ipAddress"];
        self.count = [aDecoder decodeIntegerForKey:@"count"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.host forKey:@"host"];
    [aCoder encodeObject:self.ipAddress forKey:@"ipAddress"];
    [aCoder encodeInteger:self.count forKey:@"count"];
}

@end

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [KeyValueStore setInteger:10 forKey:@"someInteger"];
    [KeyValueStore integerForKey:@"someInteger"];
    [KeyValueStore setDouble:12.4 forKey:@"someDouble"];
    [KeyValueStore doubleForKey:@"someDouble"];
    [KeyValueStore setBool:YES forKey:@"boolean"];
    [KeyValueStore boolForKey:@"boolean"];
    [KeyValueStore setString:@"lalal" forKey:@"onestring"];
    [KeyValueStore stringForKey:@"onestring"];
    
    TestObject *obj = [TestObject new];
    obj.host = @"github";
    obj.ipAddress = @"127.0.0.1";
    obj.count = 10;
    [KeyValueStore setJsonObject:[obj yy_modelToJSONObject] forKey:@"jsonModel"];
    
    NSDictionary *ano = [KeyValueStore jsonObjectForKey:@"jsonModel"];
    TestObject *obj2 = [TestObject yy_modelWithDictionary:ano];
    
    [KeyValueStore setArchiveObject:obj forKey:@"archiveObj"];
    TestObject *obj3 = [KeyValueStore unarchiveObjectForKey:@"archiveObj"];
    
    
    
    NSLog(@"%@", NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES));
    return YES;
}

@end
