//
//  AkvcExtension.m
//  AkvcExtensionSample
//
//  Created by NOVO on 2018/11/3.
//  Copyright © 2018 NOVO. All rights reserved.
//  https://github.com/qddnovo/AkvcExtension
//

#import "AkvcExtension.h"

@implementation AkvcExtension


static NSMutableDictionary* _akvc_path_function_map;
+ (void)registFunction:(NSString*)name withBlock:(id(^)(id caller))block
{
    NSAssert(name && block, @"AkvcExtension:\n  Block or name can not be nil!");
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _akvc_path_function_map = [NSMutableDictionary dictionary];
        [self _akvc_regist_privateFunction];
    });
    
    static dispatch_semaphore_t signalSemaphore;
    static dispatch_once_t onceTokenSemaphore;
    dispatch_once(&onceTokenSemaphore, ^{
        signalSemaphore = dispatch_semaphore_create(1);
    });
    dispatch_semaphore_wait(signalSemaphore, DISPATCH_TIME_FOREVER);
    
    _akvc_path_function_map[name] = block;///Regist function.
    
    dispatch_semaphore_signal(signalSemaphore);
}

+ (void)registStruct:(NSString*)encode getterMap:(NSDictionary*)getterMap
{
    [NSValue akvc_registStruct:encode getterMap:getterMap];
}

+ (void)registStruct:(NSString*)encode setterMap:(NSDictionary*)setterMap
{
    [NSValue akvc_registStruct:encode setterMap:setterMap];
}

+ (id(^)(id))pathFunctionNamed:(NSString*)name
{
    NSAssert(name, @"AkvcExtension:\n  Function name can not be nil!");
    return _akvc_path_function_map[name];
}

+ (void)_akvc_regist_privateFunction
{
    
    [self registFunction:@"firstObject" withBlock:^id(id caller) {
        return [caller firstObject];
    }];
    
    [self registFunction:@"lastObject" withBlock:^id(id caller) {
        return [caller lastObject];
    }];
    
    [self registFunction:@"length" withBlock:^id(id caller) {
        return @([caller length]);
    }];
    
    
    
    /**
     Determine whether each subitem is equal.
     */
    [self registFunction:@"isEachEqual" withBlock:^id(id caller) {
        
        NSEnumerator* enumerator = [caller objectEnumerator];
        
        id value = enumerator.nextObject;
        
        for (id nextValue ; ; ) {

            nextValue = enumerator.nextObject;
            
            if(nextValue){
                
                if([value isEqual:nextValue])
                    continue;
                
                return @NO;
            }
            break;
        }
        return @YES;
    }];
    
    [self registFunction:@"nslog" withBlock:^id(id caller) {
        
        return ((void)(NSLog(@"%@",[caller description])),caller) ;
    }];
}

@end
