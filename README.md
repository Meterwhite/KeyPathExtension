# AkvcExtension
![AkvcExtension icon](http://ico.58pic.com/iconset01/Simple-Social-Media-Icons/gif/154298.gif)

## 【Introduction】
* AkvcExtension is an extension of KVC in the Foundation Framework,which extends the many functions of the KeyPath.

## 【Import】
* Drag directory `AkvcExtension` into project or use `CocoaPods`.
```objc
#import "AkvcExtension.h"
```


## 【Overview】
### Examples
```objc

[self akvc_setValue:value forFullPath:@"aView.frame->size->width"];

[person akvc_setValue:value forSubkey:@"name"];
///Matched `name` and `nickName`

[person akvc_setValue:@(YES) forExtensionPath:@"dogs.@:age<1!.smallDog"];

[person akvc_valueForExtensionPath:@"firendList.@sortFirends"];
///Custom function 'sortFirends' in key path.

```

## 【FullPath】
###  Get value by FullPath that can access the structure.
-  Accessing properties in a structure using the accessor '->'.
```objc
"...NSKeyPath->StructPath->StructPath->....";
```
### Regist Struct
-  Use the following two functions at the same time to register struct,Refer to `AkvcExtension.h`

## 【Subkey】
### Get values by sub string of property key.
- Refer to `NSObject+AkvcExtension.h`

## 【Regkey】
### Get values by regular expressions of property key.
- Refer to `NSObject+AkvcExtension.h`


## 【ExtensionPath】
### Multifunctional key path
- All features in ExtensionPath
```objc
Name                   Representation
-------------------------------------
StructPath         :   NSKeyPath->StructPath->StructPath->...
Indexer            :   @[...]
PathFunction       :   @PathFunction
Subkey             :   <...>
Regkey             :   <$...$>
SELInspector       :   SEL(...)?
ClassInspector     :   Class(...)?
KeysAccessor       :   {KeyPath,KeyPath, ...}
PredicateFilter    :   @:...!
PredicateEvaluate  :   @:...?
-------------------------------------
```


## 【Regist PathFunction】
- Refer to `AkvcExtension.h`


## Author
- Contact or join AkvcExtension : quxingyi@outlook.com
