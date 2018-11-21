//
//  AkvcExtension.m
//  AkvcExtensionSample
//
//  Created by NOVO on 2018/11/3.
//  Copyright © 2018 NOVO. All rights reserved.
//  https://github.com/qddnovo/AkvcExtension
//

#import "AkvcExtensionPath.h"
#import "AkvcExtension.h"

@implementation AkvcExtension

+ (void)load
{
    [self _akvc_regist_privateFunction];
}

+ (void)cleanCache
{
    [AkvcExtensionPath performSelector:@selector(cleanCache)];
}

static NSMutableDictionary* _akvc_path_function_map;
+ (void)registFunction:(NSString*)name withBlock:(id(^)(id target))block
{
    NSAssert(name && block, @"AkvcExtension:\n  Block or name can not be nil!");
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _akvc_path_function_map = [NSMutableDictionary dictionary];
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
    
    static id _akvc_block_pathFunction;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _akvc_block_pathFunction = ^id(id target){
            
            SEL sel = NSSelectorFromString(name);
            NSMethodSignature *signature = [[target class] instanceMethodSignatureForSelector:sel];
            
            NSAssert(signature != nil, @"AkvcExtension:\n Unknown Method: %@", name);
            
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            invocation.target = target;
            invocation.selector = sel;
            [invocation invoke];
            id __unsafe_unretained returnValue;
            if (signature.methodReturnLength) {
                
                [invocation getReturnValue:&returnValue];
            }
            
            return returnValue?:target;
        };
        
    });
    
    return _akvc_path_function_map[name]?:_akvc_block_pathFunction;
}

+ (void)_akvc_regist_privateFunction
{
    
//    [self registFunction:@"firstObject" withBlock:^id(id target) {
//        return [target firstObject];
//    }];
//    
//    [self registFunction:@"lastObject" withBlock:^id(id target) {
//        return [target lastObject];
//    }];
    
    [self registFunction:@"isNSNull" withBlock:^id(id target) {
        return @(target == [NSNull null]);
    }];
    
    
    /**
     Determine whether each subitem is equal.
     */
    [self registFunction:@"isAllEqual" withBlock:^id(id target) {
        
        NSEnumerator* enumerator = [target objectEnumerator];
        
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

    [self registFunction:@"isAllDifferent" withBlock:^id(id target) {
        
        NSEnumerator*   enumerator  = [target objectEnumerator];
        NSMutableSet*   counter     = [NSMutableSet set];
        id              value;
        while ((value = enumerator.nextObject)) {
            
            [counter addObject:value];
        }
        
        return [NSNumber numberWithBool:counter.count == [target count]];
    }];
    
    [self registFunction:@"nslog" withBlock:^id(id target) {
        
        AkvcLog(@"%@",[target description]);
        return target;
    }];
}

@end
