//
//  NSObject+KeyPathExtensionChain.h
//  KeyPathExtensionSample
//
//  Created by NOVO on 2018/10/19.
//  Copyright © 2018 NOVO. All rights reserved.
//  https://github.com/qddnovo/KeyPathExtension
//

#import <Foundation/Foundation.h>

#define KPEBlock     (nonatomic,copy,readonly,nonnull)

#define KPEBlockG(g) (nonatomic,copy,readonly,nonnull,getter=g)

/**
 This file defines the API for chained programming.The return value of all setter is target itself.
 
 Example -
 :
 _NonnullObject.akvcSetValueForExtensionPath(...)akvcSetValueForExtensionPath(...)...
 
 */
@interface NSObject(NSObject_KPEChain)

@property KPEBlock NSString*_Nullable(^akvcPathAppend)(id _Nullable path);

@property KPEBlock NSObject*_Nullable(^akvcValueForFullPath)(NSString* _Nonnull fullPath);
@property KPEBlock NSObject*_Nullable(^akvcSetValueForFullPath)(id _Nullable value, NSString* _Nonnull fullPath);


@property KPEBlock NSArray *_Nullable(^akvcValuesForSubkey)(NSString* _Nonnull subkey);
@property KPEBlock NSObject*_Nullable(^akvcSetValueForSubkey)(id _Nullable value, NSString* _Nonnull subkey);

@property KPEBlock NSArray *_Nullable(^akvcValuesForRegkey)(NSString* _Nonnull regkey);
@property KPEBlock NSObject*_Nullable(^akvcSetValueForRegkey)(id _Nullable value, NSString* _Nonnull regkey);

@property KPEBlock NSObject*_Nullable(^akvcValueForExtensionPath)(NSString* _Nonnull extensionPath);
@property KPEBlock NSObject*_Nullable(^akvcSetValueForExtensionPath)(id _Nullable value, NSString* _Nonnull extensionPath);

@property KPEBlock NSObject*_Nullable(^akvcValueForExtensionPathWithFormat)(NSString* _Nonnull extensionPath, ...);
@property KPEBlock NSObject*_Nullable(^akvcSetValueForExtensionPathWithFormat)(id _Nullable value, NSString* _Nonnull extensionPath, ...);

@property KPEBlock NSObject*_Nullable(^akvcValueForExtensionPathWithPredicateFormat)(NSString* _Nonnull extensionPath, ...);
@property KPEBlock NSObject*_Nullable(^akvcSetValueForExtensionPathWithPredicateFormat)(id _Nullable value, NSString* _Nonnull extensionPath, ...);

@property KPEBlockG(akvcPathAppend)NSString*_Nullable(^akvcAppendCode)(id _Nonnull code);

@end

