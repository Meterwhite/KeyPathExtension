//
//  KVCExtension.h
//  KVCExtensionProgram
//
//  Created by NOVO on 2018/10/21.
//  Copyright © 2018 NOVO. All rights reserved.
//

#import "NSObject+AkvcExtension.h"
#import "NSValue+AkvcExtension.h"

@interface AkvcExtension : NSProxy

/**
 Regist a CollectionOperator function for user in AkvcExtension.
 注册自定义的@CollectionOperator函数
 Example -
 :
 [self registFunction:@"firstObject" withBlock:^id(id caller) {
    return [caller firstObject];
 }];

 @param name Function name
 @param block Caller is the object that calls this block.
 */
+ (void)registFunction:(NSString* _Nonnull)name withBlock:(id(^)(id _Nullable caller))block;

+ (void)registStruct:(NSString*)encode getterMap:(NSDictionary*)getterMap;

+ (void)registStruct:(NSString*)encode setterMap:(NSDictionary*)setterMap;




/**
 Get custom function from AkvcExtension
 */
+ (id(^)(id caller))customFunctionNamed:(NSString* _Nonnull)name;
@end
