//
//  KeyPathExtension.m
//  KeyPathExtensionSample
//
//  Created by NOVO on 2018/11/3.
//  Copyright © 2018 NOVO. All rights reserved.
//  https://github.com/qddnovo/KeyPathExtension
//

#import "NSObject+KPECategory.h"
#import "KPEPathComponent.h"
#import "KPEExtensionPath.h"
#import "KeyPathExtension.h"

@implementation KeyPathExtension

+ (void)load
{
    [self _kpe_regist_privateFunction];
}

+ (void)cleanCache
{
    [KPEExtensionPath performSelector:@selector(cleanCache)];
    [KPEPathComponent performSelector:@selector(cleanCache)];
}

static NSMutableDictionary* _kpe_path_function_map;
+ (void)registFunction:(NSString*)name withBlock:(id(^)(id target))block
{
    NSAssert(name && block, @"KeyPathExtension:\n  Block or name can not be nil!");
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _kpe_path_function_map = [NSMutableDictionary dictionary];
    });
    
    static dispatch_semaphore_t signalSemaphore;
    static dispatch_once_t onceTokenSemaphore;
    dispatch_once(&onceTokenSemaphore, ^{
        signalSemaphore = dispatch_semaphore_create(1);
    });
    dispatch_semaphore_wait(signalSemaphore, DISPATCH_TIME_FOREVER);
    
    _kpe_path_function_map[name] = block;///Regist function.
    
    dispatch_semaphore_signal(signalSemaphore);
}

+ (void)registStruct:(NSString*)encode getterMap:(NSDictionary*)getterMap
{
    [NSValue kpe_registStruct:encode getterMap:getterMap];
}

+ (void)registStruct:(NSString*)encode setterMap:(NSDictionary*)setterMap
{
    [NSValue kpe_registStruct:encode setterMap:setterMap];
}

+ (id(^)(id))pathFunctionNamed:(NSString*)name
{
    NSAssert(name, @"KeyPathExtension:\n  Function name can not be nil!");
    
    static id _kpe_block_pathFunction;
    if(!_kpe_block_pathFunction){
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            _kpe_block_pathFunction = ^id (id target){
                
                return
                
                [target kpe_performSelector:NSSelectorFromString(name)]
                ?:
                target;
            };
            
        });
    }
    
    return _kpe_path_function_map[name]?:_kpe_block_pathFunction;
}

+ (void)_kpe_regist_privateFunction
{
    
    
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
        
        KPELog(@"%@",[target description]);
        return target;
    }];
    
    [self registFunction:@"firstObject" withBlock:^id(id target) {
        
        return [target firstObject];
    }];
    
    [self registFunction:@"lastObject" withBlock:^id(id target) {
        
        return [target lastObject];
    }];
}

@end
