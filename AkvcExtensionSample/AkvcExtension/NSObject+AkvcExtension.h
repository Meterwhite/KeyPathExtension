//
//  NSObject+AkvcExtension.h
//  KVCExtensionProgram
//
//  Created by NOVO on 2018/10/19.
//  Copyright © 2018 NOVO. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef AkvcPath
#define AkvcPath(path,args...) ([NSString stringWithFormat:path,##args])
#endif

@interface NSObject(NSObjectAkvcExtension)


/**
 Get value from FullPath that can access the structure.
 FullPath adds the ability to access the structure on the basis of NSKeyPath.
 Accessing properties in a structure using the accessor '->'.
 
 Example -
 :
 'view.frame->size->width'
 
 fullPath在NSkeyPath的基础上增加了访问结构体的功能
 使用访问器'->'访问结构体中的属性

 @return The return values are boxed.返回值都是装箱的
 */
- (id _Nullable)valueForFullPath:(NSString* _Nonnull)fullPath;

- (void)setValue:(id _Nullable)value forFullPath:(NSString* _Nonnull)fullPath;


/**
 Get values by sub string of key.
 `Subkey` can be used as a sub string to match properties.(Case insensitive)
 This method is invalid for the `base type` propertys.It works for custom propertys.Because the Foundation Class is a black box.
 
 Example -
 :
 `name` can match 'name' and 'nickName'.
 
 通过键的子字符串获取值
 subkey可以作为字符串进行属性的匹配，但是该方法对基础类型的属性无效
 
 @param subkey substring of key.Search is ignoring Case.
 @return The properties that match to are unordered.匹配到的属性是无序的
 */
- (NSArray* _Nonnull)valuesForSubkey:(NSString* _Nonnull)subkey;
/** Refer to valuesForSubkey: */
- (void)setValue:(id _Nullable)value forSubkey:(NSString* _Nonnull)subkey;


/**
 Get values by regular expressions of key.
 `regkey` is regular expressions to match properties.
 This method is invalid for the `base type` propertys.It works for custom propertys.Because the Foundation Class is a black box.
 
 Example -
 :
 `lable\d+` can match 'lable0' and 'lable1'.
 
 通过键的正则表达式获取值。
 regkey是用于匹配属性名的正则表达式，但是该方法对基础类型的属性无效
 
 @param regkey Regular expressions to match properties.
 @return The properties that match to are unordered.匹配到的属性是无序的
 */
- (NSArray* _Nonnull)valuesForRegkey:(NSString* _Nonnull)regkey;
/** Refer to valuesForRegkey: */
- (void)setValue:(id _Nullable)value forRegkey:(NSString* _Nonnull)regkey;


#warning <#message#>
/**
 ExtensionPath is a versatile path.
 
 StructPath     :       NSPath->StructPath->StructPath->...
 SubKey         :       <...>
 RegKey         :       <$...$>
 ArrayIndexer   :       @[...]
 
 CustomFunction :       @CustomFunction
 
 @param extensionPath d
 @return d
 */
- (id _Nullable)valueForExtensionPath:(NSString* _Nonnull)extensionPath;
- (void)setValue:(id _Nullable)value forExtensionPath:(NSString* _Nonnull)extensionPath;

- (id _Nullable)valueForExtensionPathWithFormat:(NSString* _Nonnull)extensionPathWithFormat, ... NS_FORMAT_FUNCTION(1,2);
- (void)setValue:(id _Nullable)value forExtensionPathWithFormat:(NSString* _Nonnull)extensionPathWithFormat, ... NS_FORMAT_FUNCTION(2,3);

- (id _Nullable)valueForExtensionPathWithPredicateFormat:(NSString* _Nonnull)extendPathWithPredicateFormat,...NS_REQUIRES_NIL_TERMINATION;
- (void)setValue:(id _Nullable)value forExtensionPathWithPredicateFormat:(NSString* _Nonnull)extendPathWithPredicateFormat, ...NS_REQUIRES_NIL_TERMINATION;
@end


