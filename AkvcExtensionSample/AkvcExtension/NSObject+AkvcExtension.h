//
//  NSObject+AkvcExtension.h
//  KVCExtensionProgram
//
//  Created by NOVO on 2018/10/19.
//  Copyright © 2018 NOVO. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef AkvcFormatPath
#define AkvcFormatPath(path,args...) ([NSString stringWithFormat:path,##args])
#endif

@interface NSObject(NSObjectAkvcExtension)


- (id _Nullable)valueForFullPath:(NSString* _Nonnull)fullPath;

- (void)setValue:(id _Nullable)value forFullPath:(NSString* _Nonnull)fullPath;


- (id _Nullable)valueForExtensionPath:(NSString* _Nonnull)extensionPath;
- (void)setValue:(id _Nullable)value forExtensionPath:(NSString* _Nonnull)extensionPath;

- (id _Nullable)valueForExtensionPathWithFormat:(NSString* _Nonnull)extensionPathWithFormat, ... NS_FORMAT_FUNCTION(1,2);
- (void)setValue:(id _Nullable)value forExtensionPathWithFormat:(NSString* _Nonnull)extensionPathWithFormat, ... NS_FORMAT_FUNCTION(2,3);

- (id _Nullable)valueForExtensionPathWithPredicateFormat:(NSString* _Nonnull)extendPathWithPredicateFormat,...NS_REQUIRES_NIL_TERMINATION;
- (void)setValue:(id _Nullable)value forExtensionPathWithPredicateFormat:(NSString* _Nonnull)extendPathWithPredicateFormat, ...NS_REQUIRES_NIL_TERMINATION;

/**
 This method is invalid for the Foundation propertys.It works for custom propertys.Because the Foundation Class is a black box.
 
 @param regkey Regular expression matching rules for keys
 */
- (void)setValue:(id _Nullable)value forRegkey:(NSString* _Nonnull)regkey;
/**
 This method is invalid for the Foundation propertys.It works for custom propertys.Because the Foundation Class is a black box.
 
 @param regkey Regular expression matching rules for keys
 */
- (NSArray* _Nonnull)valuesForRegkey:(NSString* _Nonnull)regkey;

/**
 This method is invalid for the Foundation propertys.It works for custom propertys.Because the Foundation Class is a black box.

 @param subkey substring of key.Search is ignoring Case.
 */
- (void)setValue:(id _Nullable)value forSubkey:(NSString* _Nonnull)subkey;
/**
 This method is invalid for the Foundation propertys.It works for custom propertys.Because the Foundation Class is a black box.
 
 @param subkey substring of key.Search is ignoring Case.
 */
- (NSArray* _Nonnull)valuesForSubkey:(NSString* _Nonnull)subkey;
@end


