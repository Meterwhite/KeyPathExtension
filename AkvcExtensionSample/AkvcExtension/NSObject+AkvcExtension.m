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
#import "AkvcClass.h"
#import <objc/runtime.h>

@implementation NSObject(NSObjectAkvcExtension)

- (id _Nullable)valueForFullPath:(NSString* _Nonnull)fullPath;
{
    if(!fullPath){
        
    CALL_RET_NULL:
        
        return nil;
    }
    
    if(![fullPath containsString:@"->"]){
        
    CALL_NORMAL_KVC:
        
        if([self isKindOfClass:NSValue.class]){
            
            if([(NSValue*)self valueIsStructRepresentation]){
                return [(NSValue*)self structValueForKey:fullPath];
            }
        }
        
        ///Are you confusing '.' and '->'?
        return [self valueForKeyPath:fullPath];
    }
    
    ///separete struct path from full path
    NSUInteger opIdx = [fullPath rangeOfString:@"->"].location;
    NSString* keyPath = [fullPath substringToIndex:opIdx];
    if(opIdx + 1 == fullPath.length-1) goto CALL_NORMAL_KVC;//wrong struct path like @"...->"
    NSString* structPath = [fullPath substringFromIndex:opIdx+2];
    
    
    NSValue* keyPathValue = [self valueForKeyPath:keyPath];
    if(![keyPathValue isKindOfClass:NSValue.class]) goto CALL_RET_NULL;//wrong keypath befor structPath
    
    ///Adjust oprator : @"->" => @"."
    structPath = [structPath stringByReplacingOccurrencesOfString:@"->" withString:@"."];
    return [keyPathValue structValueForKeyPath:structPath];
}

- (void)setValue:(id _Nullable)value forFullPath:(NSString* _Nonnull)fullPath
{
    if(!fullPath){
        
        return;
    }
    
    if(![fullPath containsString:@"->"]){
        
        if(![self isKindOfClass:NSValue.class]){
            
            ///When crash , are you confusing '.' and '->'?
            [self setValue:value forKeyPath:fullPath];
        }
        return;
    }
    
    ///separete struct path from full path
    NSUInteger opIdx = [fullPath rangeOfString:@"->"].location;
    NSString* keyPath = [fullPath substringToIndex:opIdx];
    if(opIdx + 1 == fullPath.length-1) return;//wrong struct path like @"...->"
    NSString* structPath = [fullPath substringFromIndex:opIdx+2];
    
    ///Find new value
    NSValue* keyPathValue = [self valueForKeyPath:keyPath];
    if(![keyPathValue isKindOfClass:NSValue.class]) return;//wrong
    ///Adjust oprator : @"->" => @"."
    structPath = [structPath stringByReplacingOccurrencesOfString:@"->" withString:@"."];
    
    NSValue* newKeyPathValue = [keyPathValue setStructValue:value forKeyPath:structPath];
    [self setValue:newKeyPathValue forKeyPath:keyPath];
    return;
}

- (void)setValue:(id)value forRegkey:(NSString*)regkey
{
    [self _akvc_setValue:value forSearchingKey:regkey option:NSRegularExpressionSearch];
}

- (NSArray *)valuesForRegkey:(NSString *)regkey
{
   return [self _akvc_valuesForSearchingKey:regkey option:NSRegularExpressionSearch];
}

- (void)setValue:(id)value forSubkey:(NSString *)subkey
{
    [self _akvc_setValue:value forSearchingKey:subkey option:NSCaseInsensitiveSearch];
}

- (NSArray *)valuesForSubkey:(NSString *)subkey
{
    if([self respondsToSelector:@selector(objectEnumerator)]){
        
        id              item        = nil;
        NSMutableArray* rets        = [NSMutableArray array];
        NSEnumerator*   enumerator  = [(id)self objectEnumerator];
        while ((item = enumerator.nextObject)) {
            
            [rets addObject:[item _akvc_valuesForSearchingKey:subkey option:NSCaseInsensitiveSearch]];
        }
        return rets;
    }
    
    return [self _akvc_valuesForSearchingKey:subkey option:NSCaseInsensitiveSearch];
}

- (id _Nullable)valueForExtensionPath:(NSString* _Nonnull)extensionPath
{
    return [self valueForExtensionPathWithPredicateFormat:extensionPath, nil];
}
- (void)setValue:(id _Nullable)value forExtensionPath:(NSString* _Nonnull)extensionPath
{
    [self setValue:value forExtensionPathWithPredicateFormat:extensionPath, nil];
}

- (id)valueForExtensionPathWithFormat:(NSString *)extensionPathWithFormat, ...
{
    va_list args;
    va_start(args, extensionPathWithFormat);
    extensionPathWithFormat = [[NSString alloc] initWithFormat:extensionPathWithFormat arguments:args];
    va_arg(args, id);
    
    return [self valueForExtensionPathWithPredicateFormat:extensionPathWithFormat, nil];
}

- (void)setValue:(id)value forExtensionPathWithFormat:(NSString * _Nonnull)extensionPathWithFormat, ...
{
    va_list args;
    va_start(args, extensionPathWithFormat);
    extensionPathWithFormat = [[NSString alloc] initWithFormat:extensionPathWithFormat arguments:args];
    va_arg(args, id);
    
    [self setValue:value forExtensionPathWithPredicateFormat:extensionPathWithFormat, nil];
}

- (void)setValue:(id)value forExtensionPathWithPredicateFormat:(NSString * _Nonnull)extendPathWithPredicateFormat, ...
{
    ///ArgumentList
    NSMutableArray* arguments = [NSMutableArray new];
    va_list args;
    va_start(args, extendPathWithPredicateFormat);
    id arg;
    while ((arg = va_arg(args, id))) {
        [arguments addObject:arg];
    }
    va_arg(args, id);
    
    NSUInteger indexForArgument = 0;
    
    id _self = self;
    
    NSEnumerator<AkvcPathComponent*>* enumerator = [AkvcExtensionPath pathFast:extendPathWithPredicateFormat].componentEnumerator;
    AkvcPathComponent* currentComponent;
    AkvcPathComponent* nextComponent = enumerator.nextObject;
    id objectBeforeStructPath;
    AkvcPathComponent* componentBeforeStructPath;
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
                
                NSAssert(NO, @"Struct key path must be the last component!");
            }
        }
        else if(currentComponent.componentType & AkvcPathComponentSubkey){
            
            if(!nextComponent){
                
                [_self setValue:value forSubkey:currentComponent.stringValue];
            }else{
                
                _self = [_self valuesForSubkey:currentComponent.stringValue];
            }
        }
        else if(currentComponent.componentType & AkvcPathComponentRegkey){
            
            if(!nextComponent){
                
                [_self setValue:value forRegkey:currentComponent.stringValue];
            }else{
                
                _self = [_self valuesForRegkey:currentComponent.stringValue];
            }
        }
        else if(currentComponent.componentType & AkvcPathComponentIndexer){
            
            NSInteger index = currentComponent.indexForindexer;
            NSAssert(index != NSNotFound, @"Indexer missing index:%@.",currentComponent.stringValue);
            if(nextComponent){
                
                NSAssert([_self isKindOfClass:NSArray.class], @"Indexer must be used for NSArray:%@",_self);
                _self = _self[index];
            }else{
                
                NSAssert([_self isKindOfClass:NSMutableArray.class], @"Setter for Indexer must be used for NSMutableArray:%@",_self);
                _self[index] = value;
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
                NSAssert(NO, @"Predicate path unable be used to set value.");
            }
        }
        else if(currentComponent.componentType & AkvcPathComponentCustomFunction){
            
            if(nextComponent){
            
                _self = [currentComponent callFunctionByTarget:_self];
            }else{
                
                NSAssert(NO, @"Function path unable be used to set value.");
            }
        }
        else if(currentComponent.componentType & AkvcPathComponentKeys){
            
            if(nextComponent){
                
                _self = [currentComponent callKeysByTarget:_self];
            }else{
                
                NSAssert(NO, @"Keys component unable be used to set value.");
            }
        }
    }
    
    va_end(args);
}

- (id)valueForExtensionPathWithPredicateFormat:(NSString *)extendPathWithPredicateFormat, ...
{
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
                _self = [_self structValueForKeyPath:currentComponent.stringValue];
            }else{
                _self = [_self structValueForKey:currentComponent.stringValue];
            }
        }
        else if(currentComponent.componentType & AkvcPathComponentSubkey){
            
            _self = [_self valuesForSubkey:currentComponent.stringValue];
        }
        else if(currentComponent.componentType & AkvcPathComponentRegkey){
            
            _self = [_self valuesForRegkey:currentComponent.stringValue];
        }
        else if(currentComponent.componentType & AkvcPathComponentIndexer){
            
            NSInteger index = currentComponent.indexForindexer;
            NSAssert(index != NSNotFound, @"Indexer missing index:%@.",currentComponent.stringValue);
            _self = _self[index];
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
        else if(currentComponent.componentType & AkvcPathComponentCustomFunction){
            
            _self = [currentComponent callFunctionByTarget:_self];
        }
        else if(currentComponent.componentType & AkvcPathComponentKeys){
            
            _self = [currentComponent callKeysByTarget:_self];
        }
    }
    
    va_end(args);
    
    return _self;
}


- (void)_akvc_setValue:(id)value forSearchingKey:(NSString*)key option:(NSStringCompareOptions)option
{
    __block objc_property_t* properties;
    @try {
        
        [self.class akvc_classEnumerateUsingBlock:^(Class clazz, BOOL *stop) {
            
            unsigned int outCount, i;
            properties = class_copyPropertyList(clazz, &outCount);
            for(i=0 ; i< outCount; i++){
                
                NSString* pName = @(property_getName(properties[i]));
                ///Filter
                if(![pName rangeOfString:key options:option].length) continue;
                
                NSString *attrs = @(property_getAttributes(properties[i]));
                NSUInteger dotLoc = [attrs rangeOfString:@","].location;
                NSArray* attrInfos = [attrs componentsSeparatedByString:@","];
                NSString *code = nil;
                NSUInteger loc = 1;
                if (dotLoc == NSNotFound) { //None
                    code = [attrs substringFromIndex:loc];
                } else {
                    code = [attrs substringWithRange:NSMakeRange(loc, dotLoc - loc)];
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
        NSLog(@"Error from :%s;NSException=%@;",__func__,[exception description]);
    }
}

- (NSArray* _Nonnull)_akvc_valuesForSearchingKey:(NSString*)key option:(NSStringCompareOptions)option
{
    __block objc_property_t* properties;
    NSMutableArray* retValues = [NSMutableArray array];
    __block id value;
    @try {
        
        [self.class akvc_classEnumerateUsingBlock:^(Class clazz, BOOL *stop) {
            
            unsigned int outCount, i;
            properties = class_copyPropertyList(clazz, &outCount);
            for(i=0 ; i< outCount; i++){
                
                NSString* pName = @(property_getName(properties[i]));
                ///Filter
                if(![pName rangeOfString:key options:option].length) continue;
                
                NSString *attrs = @(property_getAttributes(properties[i]));
                NSUInteger dotLoc = [attrs rangeOfString:@","].location;
                NSArray* attrInfos = [attrs componentsSeparatedByString:@","];
                NSString *code = nil;
                NSUInteger loc = 1;
                if (dotLoc == NSNotFound) { //None
                    code = [attrs substringFromIndex:loc];
                } else {
                    code = [attrs substringWithRange:NSMakeRange(loc, dotLoc - loc)];
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
        NSLog(@"Error from :%s;NSException=%@;",__func__,[exception description]);
    }
    
    return [retValues copy];
}
@end
