![Logo](http://ico.58pic.com/iconset01/Simple-Social-Media-Icons/gif/154298.gif)AkvcExtension
===
- An extension of KeyPath for KVC.
- Describe complex logic with less code in KeyPath.
- 用较少的代码描述复杂的逻辑

# Import
* Drag directory `AkvcExtension` into project or use `CocoaPods`.
```objc
#import "AkvcExtension.h"
```
# Content
* [Overview](#Overview)
* [ExtensionPath](#ExtensionPath)
        * [StructPath](#StructPath)
        * [StructPath](#Indexer)
        * [StructPath](#PathFunction)
                * [Regist PathFunction](#Regist_PathFunction)
                * [Default PathFunction](#Default_PathFunction)
        * [StructPath](#Subkey)
        * [StructPath](#Regkey)
        * [StructPath](#SELInspector)
        * [StructPath](#ClassInspector)
        * [StructPath](#KeysAccessor)
        * [StructPath](#PredicateFilter)
        * [StructPath](#PredicateEvaluate)
* [Regist custom struct](#Regist_custom_struct)



# <a id="Overview"></a>Overview
### Examples
```objc

[person akvc_setValue:@(YES) forExtensionPath:@"...dogs.@:age<1!.smallDog"];

[person akvc_valueForExtensionPath:@"....frame->size->width"];

```


# <a id="ExtensionPath"></a>ExtensionPath
## All features 
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

## <a id="StructPath"></a> StructPath
###  StructPath can access the structure.
-  Accessing properties in a structure using the accessor '->'.
```objc
@"...NSKeyPath->StructKey->StructKey";
```

## <a id="Indexer"></a> Indexer
###  Provides a simple way to access array elements in key path.
```objc
Provides a simple way to access array elements in key path.
@[0] ; @[0,1] ;

Use the index symbol 'i' to find elements within the array range.
@[i <= 3 , i > 5];

Use the index symbol '!' You can exclude elements from an array.
@[!0,!1] ; @[i != 0 , i != 1] ; @[i<5 , 9] ; @[i<5 , !3] ;

Confirm elements and deny elements cannot exist at the same time.
It's wrong:
@[0,!1] ;
```

## <a id="PathFunction"></a> PathFunction
### PathFunction is a custom NSKeyValueOperator.
```objc
[person akvc_valueForExtensionPath:@"...firendList.@sortFirends..."];
```
### <a id="Regist_PathFunction"></a>Regist PathFunction
```objc
[AkvcExtension registFunction:@"sortFirends" withBlock:^id(id  _Nullable target) {

    //... ...
    return result;
}];
```
### <a id="Default_PathFunction"></a>Default PathFunction
```objc

```

## <a id="Subkey"></a> Subkey
### Sub string of property key.
```objc
`time` can match 'createTime' and 'modifyTime'.

[... akvc_valueForExtensionPath:@"...<time>.@isAllEqual"];

```

## <a id="Regkey"></a> Regkey
### Expressions of property key.
```objc

`button\\d+` can match 'button0','button1', ...

[... akvc_setValue:@(YES) forExtensionPath:@"...<button\\d+>.hidden"];

```

## <a id="SELInspector"></a> SELInspector
### If iSELInspector is the last component, it is equivalent to - respondsToSelector: .
```objc
NSNumber *value = [... akvc_valueForExtensionPath:@"...SEL(addObject:)?"];
```
### If SELInspector is not the last component,  it is a condition for whether execute next path.
```objc
[... akvc_setValue:@"Trump" forExtensionPath:@"...friendList.SEL(setNickName:)?.nickName"];
```

## <a id="ClassInspector"></a> ClassInspector
### If ClassInspector is the last component, it is equivalent to isKindOfClass: .
```objc
[... akvc_valueForExtensionPath:@"...Class(NSArray)?"];
```
### If ClassInspector is not the last component,  it is a condition for whether execute next path.
```objc
[... akvc_setValue:@"Trump" forExtensionPath:@"...friendList.Class(AkvcPerson)?.nickName"];
```

## <a id="KeysAccessor"></a> KeysAccessor
### Use Keysaccessor to access multiple paths at once.The returned results are placed sequentially in the array
-  Discussion : Predicate, Subkey, Regkey are disable in KeysAccessor!In addition, the nil value will be replaced by Nsnull.
```objc
[... akvc_valueForExtensionPath:@"{tody.food.name,yesterday.food.name}.@isAllEqual""];
```

## <a id="PredicateFilter"></a> PredicateFilter


## <a id="PredicateEvaluate"></a> PredicateEvaluate



# <a id="Regist_custom_struct"></a>Regist custom struct
- Refer to `AkvcExtension.h`




# Author
- Contact or join AkvcExtension : quxingyi@outlook.com
