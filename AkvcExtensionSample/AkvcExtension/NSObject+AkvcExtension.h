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
- (id _Nullable)akvc_valueForFullPath:(NSString* _Nonnull)fullPath;

- (void)akvc_setValue:(id _Nullable)value forFullPath:(NSString* _Nonnull)fullPath;


/**
 Get values by sub string of key.
 `Subkey` can be used as a sub string to match properties.(Case insensitive/不区分大小写)
 This method is invalid for the `base type` propertys.It works for custom propertys.Because the Foundation Class is a black box.
 
 Example -
 :
 `name` can match 'name' and 'nickName'.
 
 通过键的子字符串获取值
 subkey可以作为字符串进行属性的匹配，但是该方法对基础类型的属性无效
 
 @param subkey substring of key.Search is ignoring Case.
 @return The properties that match to are unordered.匹配到的属性是无序的
 */
- (NSArray* _Nonnull)akvc_valuesForSubkey:(NSString* _Nonnull)subkey;
/** Refer to akvc_valuesForSubkey: */
- (void)akvc_setValue:(id _Nullable)value forSubkey:(NSString* _Nonnull)subkey;


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
- (NSArray* _Nonnull)akvc_valuesForRegkey:(NSString* _Nonnull)regkey;
/** Refer to akvc_valuesForRegkey: */
- (void)akvc_setValue:(id _Nullable)value forRegkey:(NSString* _Nonnull)regkey;


#warning <#message#>
/**
 ExtensionPath is a versatile path.
 
 
 StructPath         :   NSKeyPath->StructPath->StructPath->...
 Indexer            :   @[...]
 CustomFunction     :   @CustomFunction
 Subkey             :   <...>
 Regkey             :   <$...$>
 SELInspector       :   SEL(...)?
 ClassInspector     :   Class(...)?
 KeysAccessor       :   {KeyPath,KeyPath, ...}
 PredicateFilter    :   @:...!
 PredicateEvaluate  :   @:...?
 
 
 StructPath -
 :
 Refer to akvc_valueForFullPath:
 
 Indexer -
 :
 Provides a simple way to access array elements in key path.
 @[0] , @[0,1]
 Use the index symbol 'i' to find elements within the array range.
 @[i <= 3 , i > 5]
 Use the index symbol '! ' You can exclude elements from an array.
 @[!0,!1] , @[i != 0 , i != 1]
 Or combine them.
 @[i<5 , 9] , @[i<5 , !3]
 Confirm elements and deny elements cannot exist at the same time.
 It's wrong:
 @[0,!1]
 
 CustomFunction -
 :
 Defining some special function to enable Extensionpath to handle more complex things.
 [AkvcExtension registFunction:@"blackList" withBlock:^id(id  _Nullable caller) {
 
    ... ...
    return objectForNextPath;
 }];
 Use CustomFunction like : `...user.@blackList...`
 
 Subkey -
 :
 Refer to akvc_valuesForSubkey:
 
 Regkey -
 :
 Refer to akvc_valuesForRegkey:
 
 SELInspector -
 :
 SELInspector equates to respondsToSelector:
 `SEL(addObject:)?`
 
 ClassInspector -
 :
 ClassInspector equates to isKindOfClass:
 `Class(NSString)?`
 
 KeysAccessor -
 :
 Use Keysaccessor to access multiple paths at once.The returned results are placed sequentially in the array
 `...{tody.food.name,yesterday.food.name}.@isEachEqual`
 Discussion : Predicate, Subkey, Regkey are disable in KeysAccessor!
 
 PredicateFilter -
 :
 PredicateFilter equates to  filteredArrayUsingPredicate:
 Expressions : `@:...!`; Using predicate at the symbol `...`
 `...users.@: age >= 18 && sex == 1 !...`
 Discussion : Can't use symbol `!.` or `?.` , but `?`, `!` or `.` are ok.
 
 PredicateEvaluate -
 :
 PredicateEvaluate equates to  evaluateWithObject:
 Expressions : `@:...?`; Using predicate at the symbol `...`
 `...user.@: age >= 18 && sex == 1 !...`
 Discussion : Can't use symbol `!.` or `?.` , but `?`, `!` or `.` are ok.
 
 @return All return values are boxed,except nil.除nil,所有返回值都是装箱的.
 */
- (id _Nullable)akvc_valueForExtensionPath:(NSString* _Nonnull)extensionPath;
- (void)akvc_setValue:(id _Nullable)value forExtensionPath:(NSString* _Nonnull)extensionPath;

- (id _Nullable)akvc_valueForExtensionPathWithFormat:(NSString* _Nonnull)extensionPathWithFormat, ... NS_FORMAT_FUNCTION(1,2);
- (void)akvc_setValue:(id _Nullable)value forExtensionPathWithFormat:(NSString* _Nonnull)extensionPathWithFormat, ... NS_FORMAT_FUNCTION(2,3);

- (id _Nullable)akvc_valueForExtensionPathWithPredicateFormat:(NSString* _Nonnull)extendPathWithPredicateFormat,...NS_REQUIRES_NIL_TERMINATION;
- (void)akvc_setValue:(id _Nullable)value forExtensionPathWithPredicateFormat:(NSString* _Nonnull)extendPathWithPredicateFormat, ...NS_REQUIRES_NIL_TERMINATION;
@end


