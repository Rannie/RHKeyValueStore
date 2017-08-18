# RHKeyValueStore
Key-Value storage tool,based on WCDB (WeChat DataBase).

About WCDB : [Tencent/WCDB](https://github.com/Tencent/wcdb) , [微信WCDB进化之路 - 开源与开始](https://mp.weixin.qq.com/s?__biz=MzAwNDY1ODY2OQ%3D%3D&mid=2649286603&idx=1&sn=d243dd27f2c6614631241cd00570e853&chksm=8334c349b4434a5fd81809d656bfad6072f075d098cb5663a85823e94fc2363edd28758ab882&mpshare=1&scene=1&srcid=0609GLAeaGGmI4zCHTc2U9ZX)

Easy KV database, can use it instead of NSUserDefaults.

### Installation
---
Add `pod 'RHKeyValueStore'` to your Podfile and run `pod install`. <br/>
Import \<RHKeyValueStore.h\>.

### Usage
---

Already `#define KeyValueStore [RHKeyValueStore store]` , <br/>
so you can use *KeyValuStore* to get the store instance.

* Integer

``` Objc
[KeyValueStore setInteger:10 forKey:@"someInteger"];
[KeyValueStore integerForKey:@"someInteger"];
```

* Double

``` Objc
[KeyValueStore setDouble:12.4 forKey:@"someDouble"];
[KeyValueStore doubleForKey:@"someDouble"];
```

* Bool

``` Objc
[KeyValueStore setBool:YES forKey:@"boolean"];
[KeyValueStore boolForKey:@"boolean"]; 
```
    
* String

``` Objc
[KeyValueStore setString:@"lalal" forKey:@"onestring"];
[KeyValueStore stringForKey:@"onestring"];
```
    
* Object

JSON encoding/decoding

``` Objc
TestObject *obj = [TestObject new];
obj.host = @"github";
obj.ipAddress = @"127.0.0.1";
obj.count = 10;
[KeyValueStore setJsonObject:[obj yy_modelToJSONObject] forKey:@"jsonModel"];
    
NSDictionary *ano = [KeyValueStore jsonObjectForKey:@"jsonModel"];
TestObject *obj2 = [TestObject yy_modelWithDictionary:ano];
```

Archive/Unarchive (confirm NSCoding Protocol)

``` Objc
[KeyValueStore setArchiveObject:obj forKey:@"archiveObj"];
TestObject *obj3 = [KeyValueStore unarchiveObjectForKey:@"archiveObj"];
```

* Isolation Store

Use method `+ (instancetype)storeWithLabel:(NSString *)label` to create a new table.

Like:
``` Objc
NSString *userId = @"my_user_id";
RHKeyValueStore *userStore = [RHKeyValueStore storeWithLabel:userId];
[userStore setInteger:30 forKey:@"someInteger"];
    
NSLog(@"global -- %zd, user -- %zd", [KeyValueStore integerForKey:@"someInteger"], [userStore integerForKey:@"someInteger"]);
```
Console output `global -- 10, user -- 30` .

* Other Methods

``` Objc
// get all keys
NSArray *keys = [KeyValueStore allKeys];
// get pair count
NSUInteger count = [KeyValueStore getKVCount];
// clear current table
[userStore clear];
```

### Documentation
---
Full API documentation is available on [CocoaDocs](http://cocoadocs.org/docsets/RHKeyValueStore/).

### License
---
The MIT License (MIT)

Copyright (c) 2017 Hanran Liu

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.



