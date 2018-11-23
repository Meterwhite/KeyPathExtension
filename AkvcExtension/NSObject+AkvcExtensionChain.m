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
        
        _akvc_block_akvcValueForFullPath = ^id(NSString* fullPath){
            
            return [self akvc_valueForFullPath:fullPath];
        };
    });
    
    return _akvc_block_akvcValueForFullPath;
}

- (NSObject *(^)(id _Nullable, NSString * _Nonnull))akvcSetValueForFullPath
{
    static id _akvc_block_akvcSetValueForFullPath;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _akvc_block_akvcSetValueForFullPath = ^id(id value, NSString* fullPath){
            
            [self akvc_setValue:value forFullPath:fullPath];
            return self;
        };
    });
    
    return _akvc_block_akvcSetValueForFullPath;
}
@end
