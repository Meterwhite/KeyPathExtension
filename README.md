# AkvcExtension
![AkvcExtension icon](http://ico.58pic.com/iconset01/Simple-Social-Media-Icons/gif/154298.gif)

## 【Introduction】
* AkvcExtension is an extension of KVC in the Foundation Framework,which extends the many functions of the KeyPath.It can help you do more when you access deep path.

## 【Import】
* Drag directory `AkvcExtension` into project or use `CocoaPods`.
```objc
#import "AkvcExtension.h"
```


## 【Overview】
### Examples
```objc

[person akvc_setValue:@(YES) forExtensionPath:@"dogs.@:age<1!.smallDog"];

[person akvc_valueForExtensionPath:@"dogs.@:name == 'Loli'!.location->x"];

[person akvc_valueForExtensionPath:@"firendList.@sortFirends"];
///Use custom path-function 'sortFirends' in key path.

```

## 【FullPath】
###  FullPath can access the structure.
-  Accessing properties in a structure using the accessor '->'.
```objc
@"...NSKeyPath->StructKey->StructKey->....";
```
### Regist custom struct
-  Use the following two functions at the same time to register struct,Refer to `AkvcExtension.h`

## 【Subkey】
### Sub string of property key.
- Refer to `NSObject+AkvcExtension.h`

## 【Regkey】
### Expressions of property key.
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
