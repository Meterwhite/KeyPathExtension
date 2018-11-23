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
    static id _akvc_block_akvcValueForFullPath;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _akvc_block_akvcValueForFullPath = ^id(NSString* k){
            
            return [self akvc_valueForFullPath:k];
        };
    });
    
    return _akvc_block_akvcValueForFullPath;
}

- (NSObject *(^)(id _Nullable, NSString * _Nonnull))akvcSetValueForFullPath
{
    static id _akvc_block_akvcSetValueForFullPath;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _akvc_block_akvcSetValueForFullPath = ^id(id v, NSString* k){
            
            [self akvc_setValue:v forFullPath:k];
            return self;
        };
    });
    
    return _akvc_block_akvcSetValueForFullPath;
}

- (NSArray *(^)(NSString * _Nonnull))akvcValuesForSubkey
{
    static id _akvc_block_akvcValuesForSubkey;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _akvc_block_akvcValuesForSubkey
        
        = ^ id (NSString* k) {
            
            return [self akvc_valuesForSubkey:k];
        };
    });
    
    return _akvc_block_akvcValuesForSubkey;
}

- (NSObject *(^)(id _Nullable, NSString * _Nonnull))akvcSetValueForSubkey
{
    static id _akvc_block_akvcSetValueForSubkey;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _akvc_block_akvcSetValueForSubkey
        
        = ^ id (id v, NSString* k) {
            
            [self akvc_setValue:v forSubkey:k];
            return self;
        };
    });
    
    return _akvc_block_akvcSetValueForSubkey;
}

- (NSArray *(^)(NSString * _Nonnull))akvcValuesForRegkey
{
    static id _akvc_block_akvcValuesForRegkey;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _akvc_block_akvcValuesForRegkey
        
        = ^ id (NSString* k) {
            
            return [self akvc_valuesForRegkey:k];
        };
    });
    
    return _akvc_block_akvcValuesForRegkey;
}

- (NSObject *(^)(id _Nullable, NSString * _Nonnull))akvcSetValueForRegkey
{
    static id _akvc_block_akvcSetValueForRegkey;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _akvc_block_akvcSetValueForRegkey
        
        = ^ id (id v, NSString* k) {
            
            [self akvc_setValue:v forRegkey:k];
            return self;
        };
    });
    
    return _akvc_block_akvcSetValueForRegkey;
}

- (NSObject *(^)(NSString * _Nonnull))akvcValueForExtensionPath
{
    static id _akvc_block_akvcValuesForExtensionPath;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _akvc_block_akvcValuesForExtensionPath
        
        = ^ id (NSString* k) {
            
            return [self akvc_valueForExtensionPath:k];
        };
    });
    
    return _akvc_block_akvcValuesForExtensionPath;
}

- (NSObject *(^)(id _Nullable, NSString * _Nonnull))akvcSetValueForExtensionPath
{
    static id _akvc_block_akvcSetValueForExtensionPath;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _akvc_block_akvcSetValueForExtensionPath
        
        = ^ id (id v, NSString* k) {
            
            [self akvc_setValue:v forExtensionPath:k];
            return self;
        };
    });
    
    return _akvc_block_akvcSetValueForExtensionPath;
}

- (NSObject *(^)(NSString * _Nonnull, ...))akvcValueForExtensionPathWithFormat
{
    static id _akvc_block_akvcValueForExtensionPathWithFormat;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _akvc_block_akvcValueForExtensionPathWithFormat
        
        = ^ id (NSString* k, ...) {
            
            va_list arguments;
            
            va_start(arguments, k);
            
            return [self akvc_valueForExtensionPathWithPredicateFormat:k arguments:arguments];
        };
    });
    
    return _akvc_block_akvcValueForExtensionPathWithFormat;
}

- (NSObject *(^)(id _Nullable, NSString * _Nonnull, ...))akvcSetValueForExtensionPathWithFormat
{
    static id _akvc_block_akvcSetValueForExtensionPathWithFormat;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _akvc_block_akvcSetValueForExtensionPathWithFormat = ^id(id v, NSString* k, ...){
            
            va_list arguments;
            
            va_start(arguments, k);
            
            [self akvc_setValue:v forExtensionPathWithPredicateFormat:k
                      arguments:arguments];
            return self;
        };
    });
    
    return _akvc_block_akvcSetValueForExtensionPathWithFormat;
}

- (NSObject *(^)(NSString * _Nonnull, ...))akvcValueForExtensionPathWithPredicateFormat
{
    static id _akvc_block_akvcValueForExtensionPathWithPredicateFormat;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _akvc_block_akvcValueForExtensionPathWithPredicateFormat
        
        = ^id (NSString* k, ...) {
            
            va_list arguments;
            
            va_start(arguments, k);
            
            return [self akvc_valueForExtensionPathWithPredicateFormat:k
                             arguments:arguments];;
        };
    });
    
    return _akvc_block_akvcValueForExtensionPathWithPredicateFormat;
}

- (NSObject *(^)(id _Nullable, NSString * _Nonnull, ...))akvcSetValueForExtensionPathWithPredicateFormat
{
    static id _akvc_block_akvcSetValueForExtensionPathWithPredicateFormat;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _akvc_block_akvcSetValueForExtensionPathWithPredicateFormat
        
        = ^id(id v, NSString* k, ...){
            
            va_list arguments;
            
            va_start(arguments, k);
            
            [self akvc_setValue:v forExtensionPathWithPredicateFormat:k
                      arguments:arguments];
            return self;
        };
    });
    
    return _akvc_block_akvcSetValueForExtensionPathWithPredicateFormat;
}
@end
