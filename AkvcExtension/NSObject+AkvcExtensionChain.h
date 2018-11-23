//
//  NSObject+AkvcExtensionChain.h
//  AkvcExtensionSample
//
//  Created by NOVO on 2018/10/19.
//  Copyright © 2018 NOVO. All rights reserved.
//  https://github.com/qddnovo/AkvcExtension
//

#import <Foundation/Foundation.h>

#define AkvcBlock (nonatomic,copy,readonly)

/**
 This file defines the API for chained programming.The return value of all setter is target itself.
 
 Example -
 :
 _NonnullObject.akvcSetValueForExtensionPath(...)akvcSetValueForExtensionPath(...)...
 
 */
@interface NSObject(NSObjectAkvcExtensionChain)

@property AkvcBlock NSObject*(^akvcValueForFullPath)(NSString* _Nonnull fullPath);
@property AkvcBlock NSObject*(^akvcSetValueForFullPath)(id _Nullable value, NSString* _Nonnull fullPath);


@property AkvcBlock NSArray *(^akvcValuesForSubkey)(NSString* _Nonnull subkey);
@property AkvcBlock NSObject*(^akvcSetValueForSubkey)(id _Nullable value, NSString* _Nonnull subkey);

@property AkvcBlock NSArray *(^akvcValuesForRegkey)(NSString* _Nonnull regkey);
@property AkvcBlock NSObject*(^akvcSetValueForRegkey)(id _Nullable value, NSString* _Nonnull regkey);

@property AkvcBlock NSObject*(^akvcValueForExtensionPath)(NSString* _Nonnull extensionPath);
@property AkvcBlock NSObject*(^akvcSetValueForExtensionPath)(id _Nullable value, NSString* _Nonnull extensionPath);

@property AkvcBlock NSObject*(^akvcValueForExtensionPathWithFormat)(NSString* _Nonnull extensionPath, ...);
@property AkvcBlock NSObject*(^akvcSetValueForExtensionPathWithFormat)(id _Nullable value, NSString* _Nonnull extensionPath, ...);

@property AkvcBlock NSObject*(^akvcValueForExtensionPathWithPredicateFormat)(NSString* _Nonnull extensionPath, ...);
@property AkvcBlock NSObject*(^akvcSetValueForExtensionPathWithPredicateFormat)(id _Nullable value, NSString* _Nonnull extensionPath, ...);
@end

