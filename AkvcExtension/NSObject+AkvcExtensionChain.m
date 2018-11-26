//
//  NSObject+AkvcExtensionChain.m
//  AkvcExtensionSample
//
//  Created by NOVO on 2018/10/19.
//  Copyright © 2018 NOVO. All rights reserved.
//  https://github.com/qddnovo/AkvcExtension
//

#import "NSObject+AkvcExtensionChain.h"
#import "NSObject+AkvcExtension.h"

@implementation NSObject(NSObjectAkvcExtensionChain)

- (NSObject *(^)(NSString * _Nonnull))akvcValueForFullPath
{
    return ^id(NSString* k){
        
        return [self akvc_valueForFullPath:k];
    };
}

- (NSObject *(^)(id _Nullable, NSString * _Nonnull))akvcSetValueForFullPath
{
    return ^id(id v, NSString* k){
        
        [self akvc_setValue:v forFullPath:k];
        return self;
    };
}

- (NSArray *(^)(NSString * _Nonnull))akvcValuesForSubkey
{
    return ^ id (NSString* k) {
        
        return [self akvc_valuesForSubkey:k];
    };
}

- (NSObject *(^)(id _Nullable, NSString * _Nonnull))akvcSetValueForSubkey
{
    return ^ id (id v, NSString* k) {
        
        [self akvc_setValue:v forSubkey:k];
        return self;
    };
}

- (NSArray *(^)(NSString * _Nonnull))akvcValuesForRegkey
{
    return ^ id (NSString* k) {
        
        return [self akvc_valuesForRegkey:k];
    };
}

- (NSObject *(^)(id _Nullable, NSString * _Nonnull))akvcSetValueForRegkey
{
    return ^ id (id v, NSString* k) {
        
        [self akvc_setValue:v forRegkey:k];
        return self;
    };
}

- (NSObject *(^)(NSString * _Nonnull))akvcValueForExtensionPath
{
    return ^ id (NSString* k) {
        
        return [self akvc_valueForExtensionPath:k];
    };
}

- (NSObject *(^)(id _Nullable, NSString * _Nonnull))akvcSetValueForExtensionPath
{
    return ^ id (id v, NSString* k) {
        
        [self akvc_setValue:v forExtensionPath:k];
        return self;
    };
}

- (NSObject *(^)(NSString * _Nonnull, ...))akvcValueForExtensionPathWithFormat
{
    return ^ id (NSString* k, ...) {
        
        va_list arguments;
        
        va_start(arguments, k);
        
        return [self akvc_valueForExtensionPathWithPredicateFormat:[[NSString alloc] initWithFormat:k arguments:arguments] arguments:nil];
    };
}

- (NSObject *(^)(id _Nullable, NSString * _Nonnull, ...))akvcSetValueForExtensionPathWithFormat
{
    return ^id(id v, NSString* k, ...){
        
        va_list arguments;
        
        va_start(arguments, k);
        
        [self akvc_setValue:v forExtensionPathWithPredicateFormat:[[NSString alloc] initWithFormat:k arguments:arguments]
                  arguments:nil];
        return self;
    };
}

- (NSObject *(^)(NSString * _Nonnull, ...))akvcValueForExtensionPathWithPredicateFormat
{
    return ^id (NSString* k, ...) {
        
        va_list arguments;
        
        va_start(arguments, k);
        
        return [self akvc_valueForExtensionPathWithPredicateFormat:k
                                                         arguments:arguments];;
    };
}

- (NSObject *(^)(id _Nullable, NSString * _Nonnull, ...))akvcSetValueForExtensionPathWithPredicateFormat
{
    return ^id(id v, NSString* k, ...){
        
        va_list arguments;
        
        va_start(arguments, k);
        
        [self akvc_setValue:v forExtensionPathWithPredicateFormat:k
                  arguments:arguments];
        return self;
    };
}
@end
