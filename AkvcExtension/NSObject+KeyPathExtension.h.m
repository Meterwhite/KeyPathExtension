//
//  NSObject+KVCExtension.m
//  KVCExtensionProgram
//
//  Created by NOVO on 2018/10/19.
//  Copyright © 2018 NOVO. All rights reserved.
//  https://github.com/qddnovo/KeyPathExtension
//

#import "NSObject+KeyPathExtension.h"
#import "NSValue+KeyPathExtension.h"
#import "KeyPathExtensionConst.h"
#import "KPEExtensionPath.h"
#import "KPEPathComponent.h"
#import <objc/runtime.h>
#import "KPEClass.h"

@implementation NSObject(NSObjectKeyPathExtension)

- (id _Nullable)kpe_valueForFullPath:(NSString* _Nonnull)fullPath;
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
            
            [rets addObject:[item kpe_valueForFullPath:fullPath]];
        }
        return [rets copy];
    }
    
    if(![fullPath containsString:@"->"]){
        
    CALL_NORMAL_KVC:
        /// <CGRect> ==> @"size"
        if([self isKindOfClass:NSValue.class]){
            
            if([((NSValue*)self) kpe_valueIsStructRepresentation]){
                return [((NSValue*)self) kpe_structValueForKey:fullPath];
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
    return [keyPathValue kpe_structValueForKeyPath:structPath];
}

- (void)kpe_setValue:(id _Nullable)value forFullPath:(NSString* _Nonnull)fullPath
{
    if(!fullPath) return;
    
    if([self respondsToSelector:@selector(objectEnumerator)] == YES
       &&
       [self respondsToSelector:@selector(keyEnumerator)] == NO){
        
        id              item        = nil;
        NSEnumerator*   enumerator  = [(id)self objectEnumerator];
        while ((item = enumerator.nextObject)) {
            
            [item kpe_setValue:value forFullPath:fullPath];
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

- (void)kpe_setValue:(id)value forSubkey:(NSString *)subkey
{
    [self _kpe_setValue:value forSearchingKey:subkey option:NSCaseInsensitiveSearch];
}

- (NSArray *)kpe_valuesForSubkey:(NSString *)subkey
{
    return [self _kpe_valuesForSearchingKey:subkey option:NSCaseInsensitiveSearch];
}

- (void)kpe_setValue:(id)value forRegkey:(NSString*)regkey
{
    [self _kpe_setValue:value forSearchingKey:regkey option:NSRegularExpressionSearch];
}

- (NSArray *)kpe_valuesForRegkey:(NSString *)regkey
{
    return [self _kpe_valuesForSearchingKey:regkey option:NSRegularExpressionSearch];
}

- (id _Nullable)kpe_valueForExtensionPath:(NSString* _Nonnull)extensionPath
{
    return [self kpe_valueForExtensionPathWithPredicateFormat:extensionPath arguments:nil];
}

- (void)kpe_setValue:(id _Nullable)value forExtensionPath:(NSString* _Nonnull)extensionPath
{
    [self kpe_setValue:value forExtensionPathWithPredicateFormat:extensionPath arguments:nil];
}

- (id)kpe_valueForExtensionPathWithFormat:(NSString *)extensionPathWithFormat, ...
{
    va_list arguments;
    
    va_start(arguments, extensionPathWithFormat);
    
    extensionPathWithFormat = [[NSString alloc] initWithFormat:extensionPathWithFormat arguments:arguments];
    
    
    return [self kpe_valueForExtensionPathWithPredicateFormat:extensionPathWithFormat arguments:nil];
}

- (void)kpe_setValue:(id)value forExtensionPathWithFormat:(NSString * _Nonnull)extensionPathWithFormat, ...
{
    va_list arguments;
    
    va_start(arguments, extensionPathWithFormat);
    
    extensionPathWithFormat = [[NSString alloc] initWithFormat:extensionPathWithFormat arguments:arguments];
    
    [self kpe_setValue:value forExtensionPathWithPredicateFormat:extensionPathWithFormat arguments:nil];
}

- (void)kpe_setValue:(id)value forExtensionPathWithPredicateFormat:(NSString * _Nonnull)extendPathWithPredicateFormat, ...
{
    
    va_list     args;
    
    va_start(args, extendPathWithPredicateFormat);
    
    [self kpe_setValue:value forExtensionPathWithPredicateFormat:extendPathWithPredicateFormat
              arguments:args];
}


- (id)kpe_valueForExtensionPathWithPredicateFormat:(NSString *)extendPathWithPredicateFormat, ...
{
    va_list     args;

    va_start(args, extendPathWithPredicateFormat);
    
    return [self kpe_valueForExtensionPathWithPredicateFormat:extendPathWithPredicateFormat
                                                     arguments:args];
}


- (void)kpe_setValue:(id)value forExtensionPathWithPredicateFormat:(NSString * _Nonnull)extendPathWithPredicateFormat arguments:(va_list)arguments
{
    if(extendPathWithPredicateFormat == nil)
        return;
    
    NSMutableArray*         argObjects  = nil;
    if(!!arguments){
        
        ///ArgumentList
        argObjects = [NSMutableArray new];
        id                  argObject   = nil;
        while ((argObject = va_arg(arguments, id))) {
            [argObjects addObject:argObject];
        }
        va_end(arguments);
    }
    
    NSUInteger  indexForArgument    = 0;
    
    id          _self               = self;
    
    NSEnumerator<KPEPathComponent*>* enumerator = [KPEExtensionPath pathFast:extendPathWithPredicateFormat].componentEnumerator;
    KPEPathComponent*  currentComponent;
    KPEPathComponent*  nextComponent = enumerator.nextObject;
    KPEPathComponent*  componentBeforeStructPath;
    id                  objectBeforeStructPath;
    while (nextComponent && _self) {
        
        currentComponent    = nextComponent;
        ///nextComponent == nil means here is last component.
        nextComponent       = enumerator.nextObject;
        
        /**
         *  key path of struct is special.
         *  The first set value is only for inner of struct;
         *  The second set value need to target the object holding the struct,set result of first step to it.
         *  Here record information about who holding struct.
         *  第一次设置值仅仅针对结构体内部
         *  第二次设置值需要针对持有结构体的对象，把第一步获取的对象设置给它，这里需要记录持有对象的相关信息
         */
        if(nextComponent.componentType & KPEPathComponentStructKeyPath){
            
            objectBeforeStructPath = _self;
            componentBeforeStructPath = currentComponent;
        }
        
    CALL_COMPONENT:
        if(currentComponent.componentType & KPEPathComponentNSKeyPath){
            
            if(nextComponent){
                
                _self = [_self valueForKeyPath:currentComponent.stringValue];
            }else{
                
                [_self setValue:value forKeyPath:currentComponent.stringValue];
            }
        }
        else if(currentComponent.componentType & KPEPathComponentNSKey){
            
            if(nextComponent){
                
                _self = [_self valueForKey:currentComponent.stringValue];
            }else{
                
                [_self setValue:value forKey:currentComponent.stringValue];
            }
        }
        else if(currentComponent.componentType & KPEPathComponentStructKeyPath){
            
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
                
                NSAssert(NO, @"KeyPathExtension:\n  Wrong path component after StructPath!");
            }
        }
        else if(currentComponent.componentType & KPEPathComponentSubkey){
            
            if(!nextComponent){
                
                [_self kpe_setValue:value forSubkey:currentComponent.subkey];
            }else{
                
                _self = [_self kpe_valuesForSubkey:currentComponent.regkey];
            }
        }
        else if(currentComponent.componentType & KPEPathComponentRegkey){
            
            if(!nextComponent){
                
                [_self kpe_setValue:value forRegkey:currentComponent.regkey];
            }else{
                
                _self = [_self kpe_valuesForRegkey:currentComponent.regkey];
            }
        }
        else if(currentComponent.componentType & KPEPathComponentIndexer){
            
            if(nextComponent){
                
                NSAssert([_self isKindOfClass:NSArray.class], @"KeyPathExtension:\n  Indexer must be used for NSArray:%@",_self);
                
                _self = [currentComponent indexerSubarray:_self];
            }else{
                
                NSAssert([_self isKindOfClass:NSMutableArray.class], @"KeyPathExtension:\n  Setter for Indexer must be used for NSMutableArray:%@",_self);
                [currentComponent indexerSetValue:value forMutableArray:_self];
            }
        }
        else if(currentComponent.componentType & KPEPathComponentIsPredicate){
            
            if(nextComponent){
                
                NSUInteger argCount = currentComponent.predicateArgumentCount;
                NSPredicate* predicate =
                [NSPredicate predicateWithFormat:currentComponent.predicateString
                                   argumentArray:[argObjects subarrayWithRange:NSMakeRange(indexForArgument, argCount)]];
                indexForArgument += argCount;
                
                if(currentComponent.componentType & KPEPathComponentPredicateFilter){
                    
                    _self = [_self filteredArrayUsingPredicate:predicate];
                }else {
                    
                    ///PredicateEvaluate
                    if([predicate evaluateWithObject:_self] == NO)
                        break;
                }
            }else{
                NSAssert(NO, @"KeyPathExtension:\n  Predicate component unable be used to setter.");
            }
        }
        else if(currentComponent.componentType & KPEPathComponentPathFunction){
            
            if(nextComponent){
                
                _self = [currentComponent callPathFunctionByTarget:_self];
            }else{
                
                NSAssert(NO, @"KeyPathExtension:\n  PathFunction unable be set.");
            }
        }
        else if(currentComponent.componentType & KPEPathComponentKeysAccessor){
            
            if(nextComponent){
                
                _self = [currentComponent callKeysAccessorByTarget:_self];
            }else{
                
                NSAssert(NO, @"KeyPathExtension:\n  KeysAccessor unable be set.");
            }
        }
        else if(currentComponent.componentType & KPEPathComponentClassInspector){
            
            if(nextComponent){
                
                if([currentComponent callClassInspectorByTarget:_self] == NO)
                    break;
            }else{
                
                NSAssert(NO, @"KeyPathExtension:\n  ClassInspector unable be set.");
            }
        }
        else if(currentComponent.componentType & KPEPathComponentSELInspector){
            
            if(nextComponent){
                
                if([currentComponent callSELInspectorByTarget:_self] == NO)
                    break;
            }else{
                
                NSAssert(NO, @"KeyPathExtension:\n  SELInspector unable be set.");
            }
        }
    }
}

- (id)kpe_valueForExtensionPathWithPredicateFormat:(NSString *)extendPathWithPredicateFormat arguments:(va_list)arguments
{
    if(extendPathWithPredicateFormat == nil) return nil;
    
    ///ArgumentList
    NSMutableArray*     argObjects  = nil;
    if(!!arguments){
        argObjects = [NSMutableArray new];
        id              argObject   = nil;
        while ((argObject = va_arg(arguments, id))) {
            [argObjects addObject:argObject];
        }
        va_end(arguments);
    }
    
    NSUInteger   indexForArgument = 0;
    id          _self             = self;
    
    NSEnumerator<KPEPathComponent*>* enumerator  = [KPEExtensionPath pathFast:extendPathWithPredicateFormat].componentEnumerator;
    
    id                 objectBeforeStructPath     = nil;
    KPEPathComponent* componentBeforeStructPath  = nil;
    KPEPathComponent* currentComponent           = nil;
    KPEPathComponent* nextComponent              = enumerator.nextObject;
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
        if(nextComponent.componentType & KPEPathComponentStructKeyPath){
            
            objectBeforeStructPath = _self;
            componentBeforeStructPath = currentComponent;
        }
        
    CALL_COMPONENT:
        if(currentComponent.componentType & KPEPathComponentNSKeyPath){
            
            _self = [_self valueForKeyPath:currentComponent.stringValue];
        }
        else if(currentComponent.componentType & KPEPathComponentNSKey){
            
            _self = [_self valueForKey:currentComponent.stringValue];
        }
        else if(currentComponent.componentType & KPEPathComponentStructKeyPath){
            
            ///Get struct value for NSValue.
            if(currentComponent.isKeyPath){
                
                _self = [_self kpe_structValueForKeyPath:currentComponent.stringValue];
            }else{
                
                _self = [_self kpe_structValueForKey:currentComponent.stringValue];
            }
        }
        else if(currentComponent.componentType & KPEPathComponentSubkey){
            
            _self = [_self kpe_valuesForSubkey:currentComponent.subkey];
        }
        else if(currentComponent.componentType & KPEPathComponentRegkey){
            
            _self = [_self kpe_valuesForRegkey:currentComponent.regkey];
        }
        else if(currentComponent.componentType & KPEPathComponentIndexer){
            
            _self = [currentComponent indexerSubarray:_self];
        }
        else if(currentComponent.componentType & KPEPathComponentIsPredicate){
            
            NSUInteger      argCount    = currentComponent.predicateArgumentCount;
            NSPredicate*    predicate
            = [NSPredicate predicateWithFormat:currentComponent.predicateString
                                 argumentArray:[argObjects subarrayWithRange:NSMakeRange(indexForArgument, argCount)]];
            indexForArgument += argCount;
            
            if(currentComponent.componentType & KPEPathComponentPredicateFilter){
                
                _self = [_self filteredArrayUsingPredicate:predicate];
            }else {
                
                ///KPEPathComponentPredicateEvaluate
                if(nextComponent == nil){
                    
                    _self = @([predicate evaluateWithObject:_self]);
                }else{
                    
                    if([predicate evaluateWithObject:_self])
                        continue;
                    
                    _self = nil;
                    break;
                }
            }
        }
        else if(currentComponent.componentType & KPEPathComponentPathFunction){
            
            _self = [currentComponent callPathFunctionByTarget:_self];
        }
        else if(currentComponent.componentType & KPEPathComponentKeysAccessor){
            
            _self = [currentComponent callKeysAccessorByTarget:_self];
        }
        else if(currentComponent.componentType & KPEPathComponentSELInspector){
            
            if(nextComponent == nil){
                
                _self = [NSNumber numberWithBool:[currentComponent callSELInspectorByTarget:_self]];
            }else{
                
                if([currentComponent callSELInspectorByTarget:_self])
                    continue;
                
                _self = nil;
                break;
            }
        }
        else if(currentComponent.componentType & KPEPathComponentClassInspector){
            
            if(nextComponent == nil){
                
                _self = [NSNumber numberWithBool:[currentComponent callClassInspectorByTarget:_self]];
            }else{
                
                if([currentComponent callClassInspectorByTarget:_self])
                    continue;
                
                _self = nil;
                break;
            }
        }
    }
    
    return _self;
}

#pragma mark - private methos

- (void)_kpe_setValue:(id)value forSearchingKey:(NSString*)key option:(NSStringCompareOptions)option
{
    NSAssert(key != nil, @"KeyPathExtension:\n  Key can not be nil!");
    
    if([self respondsToSelector:@selector(objectEnumerator)] == YES){
        
        NSEnumerator*   enumerator  = nil;
        id              object      = nil;
        
        ///Key value pairs
        if([self respondsToSelector:@selector(keyEnumerator)] == YES){
            
            NSAssert([self respondsToSelector:@selector(setObject:forKey:)], @"KeyPathExtension:\n  object:%@ for key:%@ is not mutable object!",self , key);
            
            enumerator  = [(id)self keyEnumerator];
            while ((object = enumerator.nextObject)) {
                
                if([object rangeOfString:key options:option].length == 0)
                    continue;
                
                [(id)self setObject:value forKey:object];
            }
        }
        ///Collection
        else{
            
            enumerator  = [(id)self objectEnumerator];
            
            
            while ((object = enumerator.nextObject)) {
                
                [object _kpe_setValue:value forSearchingKey:key option:option];
            }
        }
    }
    
    __block objc_property_t* properties;
    @try {
        
        [self.class kpe_classEnumerateUsingBlock:^(Class clazz, BOOL *stop) {
            
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
                
                if([attrInfos containsObject:KPEPropertyReadonly]){
                    //Readonly
                    continue;
                }else if (![[attrInfos.lastObject substringToIndex:1] isEqualToString:KPEPropertyVoid]){
                    //void
                    continue;
                }
                
                //KVCDisabled
                if (code.length == 0) {
                    continue;
                }else if (
                          [code isEqualToString:KPETypeSEL]    ||
                          [code isEqualToString:KPETypeIvar]   ||
                          [code isEqualToString:KPETypeMethod]
                          ) {
                    continue;
                }
                
                [self setValue:value forKey:pName];
            }
            free(properties);
        } includeBaseClass:NO];
        
    } @catch (NSException *exception) {
        
        free(properties);
        KPELog(@"KeyPathExtension:\n  %s;NSException=%@;",__func__,[exception description]);
    }
}

- (NSArray* _Nonnull)_kpe_valuesForSearchingKey:(NSString*)key option:(NSStringCompareOptions)option
{
    
    NSAssert(key != nil, @"KeyPathExtension:\n  Key can not be nil!");
    
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
                
                [rets addObject:[object _kpe_valuesForSearchingKey:key option:option]];
            }
        }
        
        return [rets copy];
    }
    
    
    __block objc_property_t*     properties;
    __block id                   value;
    NSMutableArray*              retValues = [NSMutableArray array];
    @try {
        
        [self.class kpe_classEnumerateUsingBlock:^(Class clazz, BOOL *stop) {
            
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
                
                if (![[attrInfos.lastObject substringToIndex:1] isEqualToString:KPEPropertyVoid]){
                    //void
                    continue;
                }
                
                //KVCDisabled
                if (code.length == 0) {
                    continue;
                }else if (
                          [code isEqualToString:KPETypeSEL]    ||
                          [code isEqualToString:KPETypeIvar]   ||
                          [code isEqualToString:KPETypeMethod]
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
        KPELog(@"KeyPathExtension:\n  %s;NSException=%@;",__func__,[exception description]);
    }
    
    return [retValues copy];
}
@end
