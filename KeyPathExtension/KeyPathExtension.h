//
//  KVCExtension.h
//  KVCExtensionProgram
//
//  Created by NOVO on 2018/10/21.
//  Copyright © 2018 NOVO. All rights reserved.
//  https://github.com/qddnovo/KeyPathExtension
//

#import "NSObject+KeyPathExtensionChain.h"
#import <CoreGraphics/CoreGraphics.h>
#import "NSObject+KeyPathExtension.h"
#import "NSValue+KeyPathExtension.h"
#import "KeyPathExtensionConst.h"


/**
 Given a scalar or struct value, wraps it in NSValue
 Base on : https://github.com/SnapKit/Masonry
 */
#define KPEBoxValue(value)    \
    \
kpe_boxValue(@encode(__typeof__((value))), (value))

@interface KeyPathExtension : NSProxy

/**
 Regist a path function for user in KeyPathExtension.
 注册自定义的PathFunction
 Example -
 :
 [self registFunction:@"firstObject" withBlock:^id(id target) {
    return [target firstObject];
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
 @param block Target is the object that calls this block.
 */
+ (void)registFunction:(nonnull NSString*)name withBlock:(id _Nullable(^_Nonnull) (id _Nullable target))block;


/**
 Regist a structure in KeyPathExtension(Getter).
 
 GetBlockType -
 :
 __kindof NSValue*(^GetBlockType)(NSValue* value);
 
 Example -
 :
 [KeyPathExtension registStruct:@(\@encode(CGSize))
                   getterMap:@{
                                @"size"   : ^(NSValue* value){ Get value and return ... }
                                          ,
                                @"origin" : ^(NSValue* value){ ... }
 }];
 
 */
+ (void)registStruct:(nonnull NSString*)encode getterMap:(nonnull NSDictionary*)getterMap;


/**
 Regist a structure in KeyPathExtension(Setter).
 
 SetBlockType -
 :
 __kindof NSValue*(^SetBlockType)(NSValue* value , id newValue);
 
 Example -
 :
 [KeyPathExtension registStruct:@(\@encode(CGSize))
                   setterMap:@{
                                @"size"   : ^(NSValue* value, id newValue){ ...Set value and return... }
                                          ,
                                @"origin" : ^(NSValue* value, id newValue){ ... }
 }];
 
 */
+ (void)registStruct:(nonnull NSString*)encode setterMap:(nonnull NSDictionary*)setterMap;


/**
 Clean all cached path component.清除缓存路径组件
 */
+ (void)cleanCache;


/**
 Get path function from KeyPathExtension
 */
+ (id _Nullable (^_Nonnull) (id _Nonnull target))pathFunctionNamed:(NSString* _Nonnull)name;
@end
