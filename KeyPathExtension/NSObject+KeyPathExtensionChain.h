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
 _NonnullObject.kpeSetValueForExtensionPath(...)kpeSetValueForExtensionPath(...)...
 
 */
@interface NSObject(NSObject_KPEChain)

@property KPEBlock NSString*_Nullable(^kpePathAppend)(id _Nullable path);

@property KPEBlock NSObject*_Nullable(^kpeValueForFullPath)(NSString* _Nonnull fullPath);
@property KPEBlock NSObject*_Nullable(^kpeSetValueForFullPath)(id _Nullable value, NSString* _Nonnull fullPath);


@property KPEBlock NSArray *_Nullable(^kpeValuesForSubkey)(NSString* _Nonnull subkey);
@property KPEBlock NSObject*_Nullable(^kpeSetValueForSubkey)(id _Nullable value, NSString* _Nonnull subkey);

@property KPEBlock NSArray *_Nullable(^kpeValuesForRegkey)(NSString* _Nonnull regkey);
@property KPEBlock NSObject*_Nullable(^kpeSetValueForRegkey)(id _Nullable value, NSString* _Nonnull regkey);

@property KPEBlock NSObject*_Nullable(^kpeValueForExtensionPath)(NSString* _Nonnull extensionPath);
@property KPEBlock NSObject*_Nullable(^kpeSetValueForExtensionPath)(id _Nullable value, NSString* _Nonnull extensionPath);

@property KPEBlock NSObject*_Nullable(^kpeValueForExtensionPathWithFormat)(NSString* _Nonnull extensionPath, ...);
@property KPEBlock NSObject*_Nullable(^kpeSetValueForExtensionPathWithFormat)(id _Nullable value, NSString* _Nonnull extensionPath, ...);

@property KPEBlock NSObject*_Nullable(^kpeValueForExtensionPathWithPredicateFormat)(NSString* _Nonnull extensionPath, ...);
@property KPEBlock NSObject*_Nullable(^kpeSetValueForExtensionPathWithPredicateFormat)(id _Nullable value, NSString* _Nonnull extensionPath, ...);

@property KPEBlockG(kpePathAppend)NSString*_Nullable(^kpeAppendCode)(id _Nonnull code);

@end

