![Logo](http://ico.58pic.com/iconset01/Simple-Social-Media-Icons/gif/154298.gif)AkvcExtension
===
- An extension of KeyPath for KVC.
- Describe complex logic with less code in KeyPath.Reduce programmer doing work.
- 用较少的代码描述复杂的逻辑，减少程序员做功

# Import
* Drag all source files under folder `AkvcExtension` to your project.
```objc
#import "AkvcExtension.h"
```
* Or use `CocoaPods`.
```ruby
pod 'AkvcExtension'
```

# <a id="Overview"></a> Overview
### Examples
```objc

[... akvc_valueForExtensionPath:@"....frame->size->width"];

[... akvc_setValue:@(YES) forExtensionPath:@"...dogs.@:age<1!.smallDog"];

```

# Content
+ [Overview](#Overview)
+ [ExtensionPath](#ExtensionPath)
    + [StructPath](#StructPath)
    + [Indexer](#Indexer)
    + [PathFunction](#PathFunction) , [Regist PathFunction](#Regist_PathFunction) , [Default PathFunction](#Default_PathFunction)
    + [Subkey](#Subkey)
    + [Regkey](#Regkey)
    + [SELInspector](#SELInspector)
    + [ClassInspector](#ClassInspector)
    + [KeysAccessor](#KeysAccessor)
    + [PredicateFilter](#PredicateFilter)
    + [PredicateEvaluate](#PredicateEvaluate)
+ [Regist custom struct](#Regist_custom_struct)
+ [Clean cache](#Clean_cache)

---


# <a id="ExtensionPath"></a> ExtensionPath
## All features 
```objc
Name                   Representation
-------------------------------------
StructPath         :   NSKeyPath->StructKey
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
-  Accessing properties in a structure using the accessor `->`.结构体访问符
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

Confirm elements and deny elements cannot exist at the same time.真假不能同时存在！
It's wrong : @[0,!1] ;
```

## <a id="PathFunction"></a> PathFunction
### PathFunction is a custom NSKeyValueOperator.自定义路径函数
```objc
[... akvc_valueForExtensionPath:@"...firendList.@sortFirends..."];
```
### <a id="Regist_PathFunction"></a> Regist PathFunction
```objc
[AkvcExtension registFunction:@"sortFirends" withBlock:^id(id  _Nullable target) {

    //... ...
    //return result;
}];
```
### <a id="Default_PathFunction"></a> Default PathFunction 默认路径函数
```objc
name
--------------------
@nslog
@firstObject
@lastObject
@isNSNull
@isTure
@isFalse
@isAllEqual
@isAllDifferent
--------------------
```

## <a id="Subkey"></a> Subkey
### Sub string of property key.
* Expressions :`<...>`
```objc
`time` can match 'createTime' and 'modifyTime'.

[... akvc_valueForExtensionPath:@"...<time>.@isAllEqual"];

```

## <a id="Regkey"></a> Regkey
### Expressions of property key.
* Expressions :`<$...$>`
```objc

`button\\d+` can match 'button0','button1', ...

[... akvc_setValue:@(YES) forExtensionPath:@"...<button\\d+>.hidden"];

```

## <a id="SELInspector"></a> SELInspector
### If iSELInspector is the last component, it is equivalent to - respondsToSelector: .
* Expressions :`SEL(...)?`
```objc
NSNumber *value = [... akvc_valueForExtensionPath:@"...SEL(addObject:)?"];
```
### If SELInspector is not the last component,  it is a condition for whether execute next path.
```objc
[... akvc_setValue:@"Trump" forExtensionPath:@"...friend.SEL(setNickName:)?.nickName"];
```

## <a id="ClassInspector"></a> ClassInspector
### If ClassInspector is the last component, it is equivalent to isKindOfClass: .
* Expressions :`Class(...)?`
```objc
[... akvc_valueForExtensionPath:@"...Class(NSArray)?"];
```
### If ClassInspector is not the last component,  it is a condition for whether execute next path.
```objc
[... akvc_setValue:@"Trump" forExtensionPath:@"...friend.Class(AkvcPerson)?.nickName"];
```

## <a id="KeysAccessor"></a> KeysAccessor
### Use Keysaccessor to access multiple paths at once.The returned results are placed sequentially in the array
-  Discussion : Predicate, Subkey, Regkey are disable in KeysAccessor!In addition,and the nil value will be replaced by NSNull.
* Expressions :`{...}`
```objc
[... akvc_valueForExtensionPath:@"{Breakfast.name, lunch.name, dinner.name}.@isAllEqual"];
```

## <a id="PredicateFilter"></a> PredicateFilter
### PredicateFilter equates to - filteredArrayUsingPredicate:
* Expressions :`@:PredicateString!`
- Discussion : Symbol `!.` or `?.` is forbidden to use, but `?`, `!` , `.` are available.
```objc
[... akvc_valueForExtensionPath:@"...users.@:age>18 && sex == 0!"];
```
### Use placeholders in ExtensionPath for predicate component
- Discussion : The parameter list accepts only boxed values.Use `AkvcBoxValue(...)` to wrap scalar.只接受装箱参数
```objc
[... akvc_valueForExtensionPathWithPredicateFormat:@"...@:@K == %@!...@:SELF == %@?", object0, object1, object2];
```

## <a id="PredicateEvaluate"></a> PredicateEvaluate
###  PredicateEvaluate equates to - evaluateWithObject: . Refert to PredicateFilter
* Expressions :`@:PredicateString?`

## Component  that has suffix `?` like `...?`
### ClassInspector(`Class(...)?`), SELInspector(`SEL(...)?`), PredicateEvaluate(`@:...?`);
- All this component has this feafure : If it's not the last component,  it will as a condition for whether to execute next path.While false it return nil or do noting, else execute next path.在路径中时这类组件表示是否执行的条件，false时返回nil或者什么也不做，true时执行之后



# <a id="Regist_custom_struct"></a> Regist custom struct
### Register a custom struct need 2 method : `+ registStruct:getterMap:` and `+ registStruct:setterMap:`
- Key of getter map or setter map is member name of structural
- Value of getter map is a block like ` __kindof NSValue*(^GetBlockType)(NSValue* value)`
```objc
@{
    @"size"   :   ^(NSValue* value){
    
        return [NSValue valueWithCGSize:[value CGRectValue].size];
    } ,
    ... ...
}
```
- Value of setter map is a block like `__kindof NSValue*(^SetBlockType)(NSValue* value , id newValue)`
```objc
@{
    @"size"   :   ^(NSValue* value , id newValue){

        CGRect rect = [value CGRectValue];
        rect.size = [newValue CGSizeValue];
        return [NSValue valueWithCGRect:rect];
    } ,
    ... ...
}
```
# <a id="Clean_cache"></a> Clean cache
```objc
[AkvcExtension cleanCache];
```


# Author
- Contact or join AkvcExtension : quxingyi@outlook.com
