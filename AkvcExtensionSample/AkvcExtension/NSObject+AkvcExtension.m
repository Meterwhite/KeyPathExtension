//
//  NSObject+KVCExtension.m
//  KVCExtensionProgram
//
//  Created by NOVO on 2018/10/19.
//  Copyright © 2018 NOVO. All rights reserved.
//

#import "NSObject+AkvcExtension.h"
#import "NSValue+AkvcExtension.h"
#import "AkvcExtensionPath.h"
#import "AkvcPathComponent.h"
#import <objc/runtime.h>
#import "AkvcClass.h"

@implementation NSObject(NSObjectAkvcExtension)

- (id _Nullable)akvc_valueForFullPath:(NSString* _Nonnull)fullPath;
{
    if(!fullPath){
        
    CALL_RET_NULL:
        
        return nil;
    }
    
    
    if([self respondsToSelector:@selector(objectEnumerator)] == YES
       &&
       [self respondsToSelector:@selector(keyEnumerator)] == NO){
        
        id              item        = nil;
        NSMutableArray  *rets        = [NSMutableArray array];
        NSEnumerator    *enumerator  = [(id)self objectEnumerator];
        while ((item = enumerator.nextObject)) {
            
            [rets addObject:[item akvc_valueForFullPath:fullPath]];
        }
        return [rets copy];
    }
    
    if(![fullPath containsString:@"->"]){
        
    CALL_NORMAL_KVC:
        /// <CGRect> ==> @"size"
        if([self isKindOfClass:NSValue.class]){
            
            if([((NSValue*)self) akvc_valueIsStructRepresentation]){
                return [((NSValue*)self) akvc_structValueForKey:fullPath];
            }
        }
        
        ///Are you confusing '.' and '->'?
        return [self valueForKeyPath:fullPath];
    }
    
    ///separete struct path from full path
    NSUInteger   opIdx       = [fullPath rangeOfString:@"->"].location;
    NSString*    keyPath     = [fullPath substringToIndex:opIdx];
    if(opIdx + 1 == fullPath.length-1) goto CALL_NORMAL_KVC;//wrong struct path like @"...->"
    NSString*    structPath  = [fullPath substringFromIndex:opIdx+2];
    
    
    NSValue*     keyPathValue = [self valueForKeyPath:keyPath];
    if(![keyPathValue isKindOfClass:NSValue.class]) goto CALL_RET_NULL;//wrong keypath befor structPath
    
    ///Adjust oprator : @"->" => @"."
    structPath = [structPath stringByReplacingOccurrencesOfString:@"->" withString:@"."];
    return [keyPathValue akvc_structValueForKeyPath:structPath];
}

- (void)akvc_setValue:(id _Nullable)value forFullPath:(NSString* _Nonnull)fullPath
{
    if(!fullPath) return;
    
    if([self respondsToSelector:@selector(objectEnumerator)] == YES
       &&
       [self respondsToSelector:@selector(keyEnumerator)] == NO){
        
        id              item        = nil;
        NSEnumerator*   enumerator  = [(id)self objectEnumerator];
        while ((item = enumerator.nextObject)) {
            
            [item akvc_setValue:value forFullPath:fullPath];
        }
    }
    
    if(![fullPath containsString:@"->"]){
        
        if(![self isKindOfClass:NSValue.class]){
            
            ///When crash , are you confusing '.' and '->'?
            [self setValue:value forKeyPath:fullPath];
        }
        return;
    }
    
    ///Separete struct path from full path
    NSUInteger  opIdx       = [fullPath rangeOfString:@"->"].location;
    NSString*   keyPath     = [fullPath substringToIndex:opIdx];
    if(opIdx + 1 == fullPath.length-1) return;//wrong struct path like @"...->"
    NSString*   structPath  = [fullPath substringFromIndex:opIdx+2];
    
    ///Find new value
    NSValue* keyPathValue= [self valueForKeyPath:keyPath];
    if(![keyPathValue isKindOfClass:NSValue.class]) return;//wrong
    ///Instead oprator : @"->" => @"."
    structPath = [structPath stringByReplacingOccurrencesOfString:@"->" withString:@"."];
    
    NSValue* newKeyPathValue = [keyPathValue setStructValue:value forKeyPath:structPath];
    [self setValue:newKeyPathValue forKeyPath:keyPath];
    return;
}

- (void)akvc_setValue:(id)value forSubkey:(NSString *)subkey
{
    [self _akvc_setValue:value forSearchingKey:subkey option:NSCaseInsensitiveSearch];
}

- (NSArray *)akvc_valuesForSubkey:(NSString *)subkey
{
    return [self _akvc_valuesForSearchingKey:subkey option:NSCaseInsensitiveSearch];
}

- (void)akvc_setValue:(id)value forRegkey:(NSString*)regkey
{
    [self _akvc_setValue:value forSearchingKey:regkey option:NSRegularExpressionSearch];
}

- (NSArray *)akvc_valuesForRegkey:(NSString *)regkey
{
    return [self _akvc_valuesForSearchingKey:regkey option:NSRegularExpressionSearch];
}

- (id _Nullable)akvc_valueForExtensionPath:(NSString* _Nonnull)extensionPath
{
    return [self akvc_valueForExtensionPathWithPredicateFormat:extensionPath, nil];
}

- (void)akvc_setValue:(id _Nullable)value forExtensionPath:(NSString* _Nonnull)extensionPath
{
    [self akvc_setValue:value forExtensionPathWithPredicateFormat:extensionPath, nil];
}

- (id)akvc_valueForExtensionPathWithFormat:(NSString *)extensionPathWithFormat, ...
{
    va_list args;
    va_start(args, extensionPathWithFormat);
    extensionPathWithFormat = [[NSString alloc] initWithFormat:extensionPathWithFormat arguments:args];
    va_arg(args, id);
    
    return [self akvc_valueForExtensionPathWithPredicateFormat:extensionPathWithFormat, nil];
}

- (void)akvc_setValue:(id)value forExtensionPathWithFormat:(NSString * _Nonnull)extensionPathWithFormat, ...
{
    va_list args;
    va_start(args, extensionPathWithFormat);
    extensionPathWithFormat = [[NSString alloc] initWithFormat:extensionPathWithFormat arguments:args];
    va_arg(args, id);
    
    [self akvc_setValue:value forExtensionPathWithPredicateFormat:extensionPathWithFormat, nil];
}

- (void)akvc_setValue:(id)value forExtensionPathWithPredicateFormat:(NSString * _Nonnull)extendPathWithPredicateFormat, ...
{
    
    if(extendPathWithPredicateFormat == nil) return;
    
    ///ArgumentList
    NSMutableArray* arguments = [NSMutableArray new];
    va_list args;
    va_start(args, extendPathWithPredicateFormat);
    id arg;
    while ((arg = va_arg(args, id))) {
        [arguments addObject:arg];
    }
    va_arg(args, id);
    
    NSUInteger  indexForArgument    = 0;
    
    id          _self               = self;
    
    NSEnumerator<AkvcPathComponent*>* enumerator = [AkvcExtensionPath pathFast:extendPathWithPredicateFormat].componentEnumerator;
    AkvcPathComponent*  currentComponent;
    AkvcPathComponent*  nextComponent = enumerator.nextObject;
    AkvcPathComponent*  componentBeforeStructPath;
    id                  objectBeforeStructPath;
    while (nextComponent && _self) {
        
        currentComponent = nextComponent;
        nextComponent = enumerator.nextObject;///nextComponent == nil means here is last component.
        
        /**
         *  key path of struct is special.
         *  The first set value is only for inner of struct;
         *  The second set value need to target the object holding the struct,set result of first step to it.
         *  Here record information about who holding struct.
         *  第一次设置值仅仅针对结构体内部
         *  第二次设置值需要针对持有结构体的对象，把第一步获取的对象设置给它，这里需要记录持有对象的相关信息
         */
        if(nextComponent.componentType & AkvcPathComponentStructKeyPath){
            
            objectBeforeStructPath = _self;
            componentBeforeStructPath = currentComponent;
        }
        
    CALL_COMPONENT:
        if(currentComponent.componentType & AkvcPathComponentNSKeyPath){
            
            if(nextComponent){
                
                _self = [_self valueForKeyPath:currentComponent.stringValue];
            }else{
                
                [_self setValue:value forKeyPath:currentComponent.stringValue];
            }
        }
        else if(currentComponent.componentType & AkvcPathComponentNSKey){
            
            if(nextComponent){
                
                _self = [_self valueForKey:currentComponent.stringValue];
            }else{
                
                [_self setValue:value forKey:currentComponent.stringValue];
            }
        }
        else if(currentComponent.componentType & AkvcPathComponentStructKeyPath){
            
            if(!nextComponent){
                
                ///Get struct value for NSValue.
                if(currentComponent.isKeyPath){
                    
                    _self = [_self setStructValue:value forKeyPath:currentComponent.stringValue];
                }else{
                    
                    _self = [_self setStructValue:value forKey:currentComponent.stringValue];
                }
                
                if(objectBeforeStructPath){
                    
                    value = _self;
                    _self = objectBeforeStructPath;
                    currentComponent = componentBeforeStructPath;
                    goto CALL_COMPONENT;
                }
            }else{
                
                NSAssert(NO, @"AkvcExtension:\n  Struct key path must be the last component!");
            }
        }
        else if(currentComponent.componentType & AkvcPathComponentSubkey){
            
            if(!nextComponent){
                
                [_self akvc_setValue:value forSubkey:currentComponent.subkey];
            }else{
                
                _self = [_self akvc_valuesForSubkey:currentComponent.regkey];
            }
        }
        else if(currentComponent.componentType & AkvcPathComponentRegkey){
            
            if(!nextComponent){
                
                [_self akvc_setValue:value forRegkey:currentComponent.regkey];
            }else{
                
                _self = [_self akvc_valuesForRegkey:currentComponent.regkey];
            }
        }
        else if(currentComponent.componentType & AkvcPathComponentIndexer){
            
            if(nextComponent){
                
                NSAssert([_self isKindOfClass:NSArray.class], @"AkvcExtension:\n  Indexer must be used for NSArray:%@",_self);
                
                _self = [currentComponent indexerSubarray:_self];
            }else{
                
                NSAssert([_self isKindOfClass:NSMutableArray.class], @"AkvcExtension:\n  Setter for Indexer must be used for NSMutableArray:%@",_self);
                [currentComponent indexerSetValue:value forMutableArray:_self];
            }
        }
        else if(currentComponent.componentType & AkvcPathComponentIsPredicate){
            
            if(nextComponent){
                
                NSUInteger argCount = currentComponent.predicateArgumentCount;
                NSPredicate* predicate =
                [NSPredicate predicateWithFormat:currentComponent.predicateString
                                   argumentArray:[arguments subarrayWithRange:NSMakeRange(indexForArgument, argCount)]];
                indexForArgument += argCount;
                
                if(currentComponent.componentType & AkvcPathComponentPredicateFilter){
                    
                    _self = [_self filteredArrayUsingPredicate:predicate];
                }
            }else{
                NSAssert(NO, @"AkvcExtension:\n  Predicate path unable be used to set value.");
            }
        }
        else if(currentComponent.componentType & AkvcPathComponentPathFunction){
            
            if(nextComponent){
            
                _self = [currentComponent callFunctionByTarget:_self];
            }else{
                
                NSAssert(NO, @"AkvcExtension:\n  Function path unable be used to set value.");
            }
        }
        else if(currentComponent.componentType & AkvcPathComponentKeysAccessor){
            
            if(nextComponent){
                
                _self = [currentComponent callKeysAccessorByTarget:_self];
            }else{
                
                NSAssert(NO, @"AkvcExtension:\n  Keys component unable be used to set value.");
            }
        }
    }
    
    va_end(args);
}

- (id)akvc_valueForExtensionPathWithPredicateFormat:(NSString *)extendPathWithPredicateFormat, ...
{
    if(extendPathWithPredicateFormat == nil) return nil;
    
    ///ArgumentList
    NSMutableArray* arguments = [NSMutableArray new];
    va_list         args;
    id              arg;
    va_start(args, extendPathWithPredicateFormat);
    while ((arg = va_arg(args, id))) {
        [arguments addObject:arg];
    }
    va_arg(args, id);
    
    
    NSUInteger   indexForArgument = 0;
    id          _self             = self;
    
    NSEnumerator<AkvcPathComponent*>* enumerator  = [AkvcExtensionPath pathFast:extendPathWithPredicateFormat].componentEnumerator;
    
    id                 objectBeforeStructPath     = nil;
    AkvcPathComponent* componentBeforeStructPath  = nil;
    AkvcPathComponent* currentComponent           = nil;
    AkvcPathComponent* nextComponent              = enumerator.nextObject;
    while (nextComponent && _self) {
        
        currentComponent = nextComponent;
        nextComponent = enumerator.nextObject;///nextComponent == nil means it last component.
        
        /**
         *  key path of struct is special.
         *  The first set value is only for inner of struct;
         *  The second set value need to target the object holding the struct,set result of first step to it.
         *  Here record information about who holding struct.
         *  第一次设置值仅仅针对结构体内部
         *  第二次设置值需要针对持有结构体的对象，把第一步获取的对象设置给它，这里需要记录持有对象的相关信息
         */
        if(nextComponent.componentType & AkvcPathComponentStructKeyPath){
            
            objectBeforeStructPath = _self;
            componentBeforeStructPath = currentComponent;
        }
        
    CALL_COMPONENT:
        if(currentComponent.componentType & AkvcPathComponentNSKeyPath){
            
            _self = [_self valueForKeyPath:currentComponent.stringValue];
        }
        else if(currentComponent.componentType & AkvcPathComponentNSKey){
            
            _self = [_self valueForKey:currentComponent.stringValue];
        }
        else if(currentComponent.componentType & AkvcPathComponentStructKeyPath){

            ///Get struct value for NSValue.
            if(currentComponent.isKeyPath){
                _self = [_self akvc_structValueForKeyPath:currentComponent.stringValue];
            }else{
                _self = [_self akvc_structValueForKey:currentComponent.stringValue];
            }
        }
        else if(currentComponent.componentType & AkvcPathComponentSubkey){
            
            _self = [_self akvc_valuesForSubkey:currentComponent.subkey];
        }
        else if(currentComponent.componentType & AkvcPathComponentRegkey){
            
            _self = [_self akvc_valuesForRegkey:currentComponent.regkey];
        }
        else if(currentComponent.componentType & AkvcPathComponentIndexer){
            
            _self = [currentComponent indexerSubarray:_self];
        }
        else if(currentComponent.componentType & AkvcPathComponentIsPredicate){
            
            NSUInteger      argCount    = currentComponent.predicateArgumentCount;
            NSPredicate*    predicate
            = [NSPredicate predicateWithFormat:currentComponent.predicateString
                                 argumentArray:[arguments subarrayWithRange:NSMakeRange(indexForArgument, argCount)]];
            indexForArgument += argCount;
            
            if(currentComponent.componentType & AkvcPathComponentPredicateFilter){
                
                _self = [_self filteredArrayUsingPredicate:predicate];
            }else if (currentComponent.componentType & AkvcPathComponentPredicateEvaluate){
                
                _self = @([predicate evaluateWithObject:_self]);
            }
        }
        else if(currentComponent.componentType & AkvcPathComponentPathFunction){
            
            _self = [currentComponent callFunctionByTarget:_self];
        }
        else if(currentComponent.componentType & AkvcPathComponentKeysAccessor){
            
            _self = [currentComponent callKeysAccessorByTarget:_self];
        }
    }
    
    va_end(args);
    
    return _self;
}

#pragma mark - private methos

- (void)_akvc_setValue:(id)value forSearchingKey:(NSString*)key option:(NSStringCompareOptions)option
{
    NSAssert(key != nil, @"AkvcExtension:\n  Key can not be nil!");
    
    if([self respondsToSelector:@selector(objectEnumerator)] == YES){
        
        NSEnumerator*   enumerator  = nil;
        id              object      = nil;
        
        ///Key value pairs
        if([self respondsToSelector:@selector(keyEnumerator)] == YES){
            
            NSAssert([self respondsToSelector:@selector(setObject:forKey:)], @"AkvcExtension:\n  object:%@ for key:%@ is not mutable object!",self , key);
            
            enumerator  = [(id)self keyEnumerator];
            while ((object = enumerator.nextObject)) {
                
                if([object rangeOfString:key options:option].length == 0)
                    continue;
                
                if(value)
                    [(id)self setObject:value forKey:object];
            }
        }
        ///Collection
        else{
            
            enumerator  = [(id)self objectEnumerator];
            
            
            while ((object = enumerator.nextObject)) {
                
                [object _akvc_setValue:value forSearchingKey:key option:option];
            }
        }
    }
    
    __block objc_property_t* properties;
    @try {
        
        [self.class akvc_classEnumerateUsingBlock:^(Class clazz, BOOL *stop) {
            
            unsigned int outCount, i;
            properties = class_copyPropertyList(clazz, &outCount);
            
            NSString    *attrs;
            NSUInteger  dotLoc;
            NSArray     *attrInfos;
            NSString    *code;
            NSString    *pName;
            for(i=0 ; i< outCount; i++){
                
                pName = @(property_getName(properties[i]));
                ///Filter
                if(![pName rangeOfString:key options:option].length) continue;
                
                attrs = @(property_getAttributes(properties[i]));
                dotLoc = [attrs rangeOfString:@","].location;
                attrInfos = [attrs componentsSeparatedByString:@","];
                code = nil;
                if (dotLoc == NSNotFound) { //None
                    code = [attrs substringFromIndex:1];
                } else {
                    code = [attrs substringWithRange:NSMakeRange(1, dotLoc - 1)];
                }
                
                if([attrInfos containsObject:@"R"]){
                    //Readonly
                    continue;
                }else if (![[attrInfos.lastObject substringToIndex:1] isEqualToString:@"V"]){
                    //void
                    continue;
                }
                
                //KVCDisabled
                if (code.length == 0) {
                    continue;
                }else if (
                          [code isEqualToString:@":"] ||//SEL
                          [code isEqualToString:@"^{objc_ivar=}"] ||//ivar
                          [code isEqualToString:@"^{objc_method=}"]//Method
                          ) {
                    continue;
                }
                
                [self setValue:value forKey:pName];
            }
            free(properties);
        } includeBaseClass:NO];
        
    } @catch (NSException *exception) {
        
        free(properties);
        NSLog(@"AkvcExtension:\n  %s;NSException=%@;",__func__,[exception description]);
    }
}

- (NSArray* _Nonnull)_akvc_valuesForSearchingKey:(NSString*)key option:(NSStringCompareOptions)option
{
    
    NSAssert(key != nil, @"AkvcExtension:\n  Key can not be nil!");
    
    if([self respondsToSelector:@selector(objectEnumerator)] == YES){
        
        
        NSEnumerator*   enumerator  = nil;
        id              object      = nil;
        NSMutableArray* rets        = [NSMutableArray array];
        
        ///Key value pairs
        if([self respondsToSelector:@selector(keyEnumerator)] == YES){
            
            enumerator  = [(id)self keyEnumerator];
            while ((object = enumerator.nextObject)) {
                
                if([object rangeOfString:key options:option].length == 0)
                    continue;
                
                [rets addObject:[(id)self objectForKey:object]];
            }
        }
        ///Collection
        else{

            enumerator  = [(id)self objectEnumerator];
            
            
            while ((object = enumerator.nextObject)) {
                
                [rets addObject:[object _akvc_valuesForSearchingKey:key option:option]];
            }
        }
        
        return [rets copy];
    }
    
    
    __block objc_property_t*     properties;
    __block id                   value;
    NSMutableArray*              retValues = [NSMutableArray array];
    @try {
        
        [self.class akvc_classEnumerateUsingBlock:^(Class clazz, BOOL *stop) {
            
            unsigned int outCount, i;
            properties = class_copyPropertyList(clazz, &outCount);
            
            NSString*    attrs;
            NSUInteger  dotLoc;
            NSArray*     attrInfos;
            NSString*    code;
            NSString*    pName;
            for(i=0 ; i< outCount; i++){
                
                pName = @(property_getName(properties[i]));
                ///Filter
                if(![pName rangeOfString:key options:option].length) continue;
                
                attrs = @(property_getAttributes(properties[i]));
                dotLoc = [attrs rangeOfString:@","].location;
                attrInfos = [attrs componentsSeparatedByString:@","];
                code = nil;
                if (dotLoc == NSNotFound) { //None
                    code = [attrs substringFromIndex:1];
                } else {
                    code = [attrs substringWithRange:NSMakeRange(1, dotLoc - 1)];
                }
                
                if([attrInfos containsObject:@"R"]){
                    //Readonly
                    continue;
                }else if (![[attrInfos.lastObject substringToIndex:1] isEqualToString:@"V"]){
                    //void
                    continue;
                }
                
                //KVCDisabled
                if (code.length == 0) {
                    continue;
                }else if (
                          [code isEqualToString:@":"] ||//SEL
                          [code isEqualToString:@"^{objc_ivar=}"] ||//ivar
                          [code isEqualToString:@"^{objc_method=}"]//Method
                          ) {
                    continue;
                }
                
                value = [self valueForKey:pName];
                if(value) [retValues addObject:value];
            }
            free(properties);
        } includeBaseClass:NO];
        
    } @catch (NSException *exception) {
        
        free(properties);
        NSLog(@"AkvcExtension:\n  %s;NSException=%@;",__func__,[exception description]);
    }
    
    return [retValues copy];
}
@end
