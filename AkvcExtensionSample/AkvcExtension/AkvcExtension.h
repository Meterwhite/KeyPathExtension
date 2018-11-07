//
//  KVCExtension.h
//  KVCExtensionProgram
//
//  Created by NOVO on 2018/10/21.
//  Copyright © 2018 NOVO. All rights reserved.
//

#import "NSObject+AKVCExtension.h"
#import "NSValue+AKVCExtension.h"

@interface AkvcExtension : NSProxy

/**
 Regist a functin for user.
 Example-
 :
 [self registFunction:@"firstObject" withBlock:^id(id caller) {
    return [caller firstObject];
 }];

 @param name Function name
 @param block Process caller and then function returns results
 */
+ (void)registFunction:(NSString* _Nonnull)name withBlock:(id(^)(id _Nullable caller))block;

+ (id(^)(id caller))customFunctionNamed:(NSString*)name;
@end
