//
//  AkvcExtensionPath.m
//  AkvcExtensionSample
//
//  Created by NOVO on 2018/10/27.
//  Copyright © 2018 NOVO. All rights reserved.
//

#import "AkvcExtensionPath.h"
#import "AkvcPathComponent.h"
#import "AkvcPathReader.h"

@interface AkvcExtensionPath ()
@property (nonatomic,strong) NSMutableArray<AkvcPathComponent*>* components;
@end

@implementation AkvcExtensionPath

+ (instancetype)pathFast:(NSString *)path
{
    NSAssert(path != nil, @"Path can not be nil!");
    
    ///Try get data from cache first.
    AkvcExtensionPath* _self = [self cachedExtensionPath:path];
    if(_self) return _self;
    
    
    ///New path.
    _self = [[self alloc] init];
    _self->_stringValue = path;
    
    NSMutableArray* unfinishedComponents = [NSMutableArray new];
    AkvcPathReader* reader = [AkvcPathReader defaultReder];
    __block AkvcPathComponent* component;
    [path enumerateSubstringsInRange:NSMakeRange(0, path.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString* value, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
        
        component = [reader readValueFast:value];
        
        if(component){
            
            NSAssert(component.componentType != AkvcPathComponentError, @"Unrecognize path:%@",component.stringValue);
            [unfinishedComponents addObject:component];
        }
    }];
    
    component = [reader endRead];
    if(component){
        
        NSAssert(component.componentType != AkvcPathComponentError, @"Unrecognize path:%@",component.stringValue);
        
        if([unfinishedComponents.lastObject componentType] == AkvcPathComponentStructKeyPath){
            
            component.componentType = AkvcPathComponentStructKeyPath;
        }
        [unfinishedComponents addObject:component];
    }
    
    
    NSMutableArray* components = [NSMutableArray new];
    NSUInteger suffixLength = 0;
    AkvcPathComponent* reorganizedComponents;
    AkvcPathComponentType lastComponentType = AkvcPathComponentNon;
    AkvcPathComponentType componentType = AkvcPathComponentNon;
    BOOL reorganizationNeedFinish = NO;
    BOOL componentNeedFinish = NO;
    for (NSUInteger i = 0; i < unfinishedComponents.count; i++) {
        
        component = unfinishedComponents[i];
        componentType = component.componentType;
        suffixLength = component.suffixLength;
        componentNeedFinish = YES;
        
        ///Mark NSKeyValueOperatorForFunction and custom.
        if (componentType == AkvcPathComponentIsFunction){
            
            
            ///`\@Function.`
            NSString* funcName = [component.stringValue substringWithRange:NSMakeRange(1, component.stringValue.length-2)];
            
            if([self.class isNSKeyValueOperatorForFunction:funcName]){
                
                component.componentType=AkvcPathComponentNSKeyValueOperator;
                componentType = AkvcPathComponentNSKeyValueOperator;
            }else{
                component.componentType = AkvcPathComponentCustomFunction;
                componentType = AkvcPathComponentCustomFunction;
            }
        }
        
        
        
        if(lastComponentType & AkvcPathComponentStructKeyPath){
            
            if(component.suffixLength == 0){
                /**
                 StructPath at tail
                 (StructPath->)(StructPath) ==> (StructPath->StructPath)
                 :
                 */
                reorganizedComponents.stringValue = [reorganizedComponents.stringValue stringByAppendingString:component.stringValue];
                reorganizedComponents.stringValue = [reorganizedComponents.stringValue stringByReplacingOccurrencesOfString:@"->" withString:@"."];
                reorganizedComponents.suffixLength = 0;
                
                reorganizationNeedFinish = YES;
                componentNeedFinish = NO;
                goto CALL_END;
            }
            
            if(componentType & AkvcPathComponentStructKeyPath){
                
                /**
                 StructPath in body
                 (StructPath->)(StructPath->) ==> (StructPath->StructPath->)
                 :
                 Append.
                 */
                reorganizedComponents.stringValue = [reorganizedComponents.stringValue stringByAppendingString:component.stringValue];
                lastComponentType = componentType;
                continue;
            }else{
                /**
                 Error
                 (StructPath->)(?)
                 :
                 */
                NSAssert(NO, @"Error:StructPath of ExtensionPath must be the last one.");
                /**
                 reorganizationNeedFinish = NO;
                 componentNeedFinish = YES;
                 */
            }
        }
        else if (lastComponentType & (AkvcPathComponentNSKey|AkvcPathComponentNSKeyValueOperator|AkvcPathComponentStructKeyPath))
        {
            
            
            if(componentType & AkvcPathComponentStructKeyPath)
            {
                if(reorganizedComponents)
                {
                    /**
                     struct body
                     :
                     (Single.)(NSKey-StructPath-Head.)(StructPath->)
                     */
                    reorganizedComponents.stringValue = [reorganizedComponents.stringValue stringByAppendingString:component.stringValue];//that need append to previous path.
                    reorganizedComponents.suffixLength = 2;
                    lastComponentType = componentType;
                    continue;
                }
                else
                {
                    /**
                     struct head
                     :
                     (NSKeyPath.)(StructPath->)
                     */
                    reorganizedComponents = component;
                    continue;
                }
            }
            else if(componentType & (AkvcPathComponentNSKey|AkvcPathComponentNSKeyValueOperator|AkvcPathComponentStructKeyPath)){
                
                /**
                 (NSKeyPath.)(NSKey[.])
                 :
                 Append and continue
                 */
                reorganizedComponents.stringValue = [reorganizedComponents.stringValue stringByAppendingString:component.stringValue];
                reorganizedComponents.componentType = AkvcPathComponentNSKeyPath;
                lastComponentType = componentType;
                
                if(component.suffixLength == 0){
                    
                    /**
                     NSKeyPath tail
                     (NSKeyPath.)(NSKey) ==> (NSKeyPath.NSKey)
                     :
                     Append and continue;
                     */
                    reorganizedComponents.suffixLength = 0;
                    reorganizationNeedFinish = YES;
                    componentNeedFinish = NO;
                }
                else{
                    /**
                     NSKeyPath body
                     :
                     (NSKeyPath.)(NSKey.) ==> (NSKeyPath.NSKey.)
                     */
                    lastComponentType = componentType;
                    continue;
                }
            }
            else {
                
                /**
                 NSKeyPath tail;
                 (NSKeyPath.)(Single.)
                 :
                 Finish last NSKeyPath.
                 Add the component.
                 */
                reorganizationNeedFinish = YES;
                componentNeedFinish = YES;
            }
        }
        else
        {
            
            if(componentType & AkvcPathComponentStructKeyPath){
                /**
                 Struct head (NSKey)
                 (Single.)(StructPath->) ==> (Single.)(NSKey)
                 or
                 ()(StructPath->)
                 :
                 Change type as NSKey and adding component.
                 Make an empty StructPath body
                 */
                reorganizedComponents = [component copy];
                reorganizedComponents.stringValue = [NSString string];
                
                component.componentType = AkvcPathComponentNSKey;
                reorganizationNeedFinish = NO;
                componentNeedFinish = YES;
            }
            else if (componentType & (AkvcPathComponentNSKey|AkvcPathComponentNSKeyValueOperator)){
                /**
                 NSKey Head
                 (Single.)(NSKey.) or (NSKey)
                 :
                 Make NSKeyPath.
                 continue.
                 */
                reorganizedComponents = component;
                lastComponentType = componentType;
                continue;
            }else{
                
                /**
                 Single
                 (Single.)(Single.)
                 :
                 Add component
                 */
                reorganizationNeedFinish = NO;
                componentNeedFinish = YES;
            }
        }
        
        
    CALL_END:
        
        if(reorganizationNeedFinish){
            
            if(reorganizedComponents.suffixLength){
                
                reorganizedComponents.stringValue = [reorganizedComponents.stringValue substringToIndex:reorganizedComponents.stringValue.length-reorganizedComponents.suffixLength];
            }
            [components addObject:reorganizedComponents];
            lastComponentType = reorganizedComponents.componentType;
            reorganizationNeedFinish = NO;
            reorganizedComponents = nil;
        }
        
        if(componentNeedFinish){
            
            if(component.suffixLength){
                
                component.stringValue = [component.stringValue substringToIndex:component.stringValue.length-component.suffixLength];
            }
            [components addObject:component];
            lastComponentType = component.componentType;
        }
        
        
    }
    
    if(reorganizedComponents){
        
        if(reorganizedComponents.suffixLength){
            
            reorganizedComponents.stringValue = [reorganizedComponents.stringValue substringToIndex:reorganizedComponents.stringValue.length-reorganizedComponents.suffixLength];
        }
        [components addObject:reorganizedComponents];
    }
    
    _self.components = components;
    [_self cache];
    return _self;
}

- (NSEnumerator<AkvcPathComponent*>*)componentEnumerator
{
    return self.components.objectEnumerator;
}


+ (BOOL)isNSKeyValueOperatorForFunction:(NSString*)function
{
    NSUInteger cmp = function.length;
    //check length
    if(cmp!=3 && cmp!=5 && cmp!=11 &&
       cmp!=13 && cmp!=14 && cmp!=19 &&
       cmp!=21 && cmp!=22
       ){
        return NO;
    }
    //check first char
    cmp = [function characterAtIndex:0];
    if(cmp!='m' && cmp!='s' && cmp!='a' &&
       cmp!='c' && cmp!='u' && cmp!='d'
       ){
        return NO;
    }
    //check complete string
    if([function isEqualToString:NSMaximumKeyValueOperator]) return YES;//max-3
    if([function isEqualToString:NSMinimumKeyValueOperator]) return YES;//min-3
    if([function isEqualToString:NSSumKeyValueOperator]) return YES;//sum-3
    if([function isEqualToString:NSAverageKeyValueOperator]) return YES;//avg-3
    if([function isEqualToString:NSCountKeyValueOperator]) return YES;//count-5
    if([function isEqualToString:NSUnionOfSetsKeyValueOperator]) return YES;//unionOfSets-11
    if([function isEqualToString:NSUnionOfArraysKeyValueOperator]) return YES;//unionOfArrays-13
    if([function isEqualToString:NSUnionOfObjectsKeyValueOperator]) return YES;//unionOfObjects-14
    if([function isEqualToString:NSDistinctUnionOfSetsKeyValueOperator]) return YES;//distinctUnionOfSets-19
    if([function isEqualToString:NSDistinctUnionOfArraysKeyValueOperator]) return YES;//distinctUnionOfArrays-21
    if([function isEqualToString:NSDistinctUnionOfObjectsKeyValueOperator]) return YES;//distinctUnionOfObjects-22
    
    return NO;
}

static NSMutableDictionary* _cachedComponent;

- (void)cache
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _cachedComponent = [NSMutableDictionary new];
    });
    
    
    static dispatch_semaphore_t signalSemaphore;
    static dispatch_once_t onceTokenSemaphore;
    dispatch_once(&onceTokenSemaphore, ^{
        signalSemaphore = dispatch_semaphore_create(1);
    });
    
    dispatch_semaphore_wait(signalSemaphore, DISPATCH_TIME_FOREVER);
    
    AkvcExtensionPath* component = _cachedComponent[_stringValue];
    if(component == nil){
        _cachedComponent[_stringValue] = self;
    }
    
    dispatch_semaphore_signal(signalSemaphore);
}

+ (instancetype)cachedExtensionPath:(NSString*)path
{
    return _cachedComponent[path];
}
@end
