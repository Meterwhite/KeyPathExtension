//
//  NSObject+KeyPathExtensionChain.m
//  KeyPathExtensionSample
//
//  Created by NOVO on 2018/10/19.
//  Copyright © 2018 NOVO. All rights reserved.
//  https://github.com/qddnovo/KeyPathExtension
//

#import "NSObject+KeyPathExtensionChain.h"
#import "NSObject+KeyPathExtension.h"

@implementation NSObject(NSObject_KPEChain)

- (NSString *(^)(id _Nullable path))akvcPathAppend
{
    return ^id(id _Nullable path){
        
        NSString* _self = (id)self;
        if([_self isKindOfClass:NSString.class] == NO){
            
            _self = [_self description];
        }
        
        return [_self stringByAppendingFormat:@".%@",path];
    };
}

- (NSObject *(^)(NSString * _Nonnull))akvcValueForFullPath
{
    return ^id(NSString* k){
        
        return [self kpe_valueForFullPath:k];
    };
}

- (NSObject *(^)(id _Nullable, NSString * _Nonnull))akvcSetValueForFullPath
{
    return ^id(id v, NSString* k){
        
        [self kpe_setValue:v forFullPath:k];
        return self;
    };
}

- (NSArray *(^)(NSString * _Nonnull))akvcValuesForSubkey
{
    return ^ id (NSString* k) {
        
        return [self kpe_valuesForSubkey:k];
    };
}

- (NSObject *(^)(id _Nullable, NSString * _Nonnull))akvcSetValueForSubkey
{
    return ^ id (id v, NSString* k) {
        
        [self kpe_setValue:v forSubkey:k];
        return self;
    };
}

- (NSArray *(^)(NSString * _Nonnull))akvcValuesForRegkey
{
    return ^ id (NSString* k) {
        
        return [self kpe_valuesForRegkey:k];
    };
}

- (NSObject *(^)(id _Nullable, NSString * _Nonnull))akvcSetValueForRegkey
{
    return ^ id (id v, NSString* k) {
        
        [self kpe_setValue:v forRegkey:k];
        return self;
    };
}

- (NSObject *(^)(NSString * _Nonnull))akvcValueForExtensionPath
{
    return ^ id (NSString* k) {
        
        return [self kpe_valueForExtensionPath:k];
    };
}

- (NSObject *(^)(id _Nullable, NSString * _Nonnull))akvcSetValueForExtensionPath
{
    return ^ id (id v, NSString* k) {
        
        [self kpe_setValue:v forExtensionPath:k];
        return self;
    };
}

- (NSObject *(^)(NSString * _Nonnull, ...))akvcValueForExtensionPathWithFormat
{
    return ^ id (NSString* k, ...) {
        
        va_list arguments;
        
        va_start(arguments, k);
        
        return [self kpe_valueForExtensionPathWithPredicateFormat:[[NSString alloc] initWithFormat:k arguments:arguments] arguments:nil];
    };
}

- (NSObject *(^)(id _Nullable, NSString * _Nonnull, ...))akvcSetValueForExtensionPathWithFormat
{
    return ^id(id v, NSString* k, ...){
        
        va_list arguments;
        
        va_start(arguments, k);
        
        [self kpe_setValue:v forExtensionPathWithPredicateFormat:[[NSString alloc] initWithFormat:k arguments:arguments]
                  arguments:nil];
        return self;
    };
}

- (NSObject *(^)(NSString * _Nonnull, ...))akvcValueForExtensionPathWithPredicateFormat
{
    return ^id (NSString* k, ...) {
        
        va_list arguments;
        
        va_start(arguments, k);
        
        return [self kpe_valueForExtensionPathWithPredicateFormat:k
                                                         arguments:arguments];;
    };
}

- (NSObject *(^)(id _Nullable, NSString * _Nonnull, ...))akvcSetValueForExtensionPathWithPredicateFormat
{
    return ^id(id v, NSString* k, ...){
        
        va_list arguments;
        
        va_start(arguments, k);
        
        [self kpe_setValue:v forExtensionPathWithPredicateFormat:k
                  arguments:arguments];
        return self;
    };
}
@end
