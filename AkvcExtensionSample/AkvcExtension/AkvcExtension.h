//
//  KVCExtension.h
//  KVCExtensionProgram
//
//  Created by NOVO on 2018/10/21.
//  Copyright © 2018 NOVO. All rights reserved.
//  https://github.com/qddnovo/AkvcExtension
//

#import "NSObject+AkvcExtension.h"
#import "NSValue+AkvcExtension.h"

@interface AkvcExtension : NSProxy

/**
 Regist a path function for user in AkvcExtension.
 注册自定义的@CollectionOperator函数
 Example -
 :
 [self registFunction:@"firstObject" withBlock:^id(id caller) {
    return [caller firstObject];
 }];
 
 Default path function
 ----------------------
 @nslog             :   NSLog this object
 @firstObject
 @lastObject
 @isNSNull
 @isTure
 @isFalse
 @isAllEqual        :   Determines whether each subitem of the collection is equal.
 @isAllDifferent    :   Determines whether each subitem of the collection is not equal.
 ----------------------
 @param name Function name
 @param block Caller is the object that calls this block.
 */
+ (void)registFunction:(NSString* _Nonnull)name withBlock:(id(^)(id _Nullable caller))block;


/**
 Regist a structure in AkvcExtension(Getter).
 
 GetBlockType -
 :
 __kindof NSValue*(^GetBlockType)(NSValue* value);
 
 Example -
 :
 [AkvcExtension registStruct:@(\@encode(CGSize))
                   getterMap:@{
                                @"size"   : ^(NSValue* value){ Get value and return ... }
                                          ,
                                @"origin" : ^(NSValue* value){ ... }
 }];
 
 */
+ (void)registStruct:(NSString*)encode getterMap:(NSDictionary*)getterMap;


/**
 Regist a structure in AkvcExtension(Setter).
 
 SetBlockType -
 :
 __kindof NSValue*(^SetBlockType)(NSValue* value , id newValue);
 
 Example -
 :
 [AkvcExtension registStruct:@(\@encode(CGSize))
                   setterMap:@{
                                @"size"   : ^(NSValue* value, id newValue){ ...Set value and return... }
                                          ,
                                @"origin" : ^(NSValue* value, id newValue){ ... }
 }];
 
 */
+ (void)registStruct:(NSString*)encode setterMap:(NSDictionary*)setterMap;


/**
 Clean all cached path component.清除缓存路径组件
 */
+ (void)cleanCache;


/**
 Get path function from AkvcExtension
 */
+ (id(^)(id caller))pathFunctionNamed:(NSString* _Nonnull)name;
@end
