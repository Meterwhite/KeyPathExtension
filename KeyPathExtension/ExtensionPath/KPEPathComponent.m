//
//  KPEPathReadResult.m
//  KeyPathExtensionSample
//
//  Created by NOVO on 2018/10/21.
//  Copyright © 2018 NOVO. All rights reserved.
//  https://github.com/qddnovo/KeyPathExtension
//

#import "KPEPathComponent.h"
#import "KeyPathExtension.h"

@implementation KPEPathComponent
{
    NSString* _functionName;
}

- (NSString*)subkey
{
    return [_stringValue substringWithRange:NSMakeRange(1, _stringValue.length - 2)];
}

- (NSString*)regkey
{
    return [_stringValue substringWithRange:NSMakeRange(2, _stringValue.length - 4)];
}

- (id)callKeysAccessorByTarget:(id)target
{
    ///Empty keys : `{}`
    NSAssert(_stringValue.length > 2, @"KeyPathExtension:\n  Keys component must contain at least one key.");
    ///Get content.
    NSString* content = [_stringValue substringWithRange:NSMakeRange(1, _stringValue.length - 2)];
    ///Check if illegal character sets are included.
    NSAssert(strchr(content.UTF8String, ':') == NULL
             &&
             strchr(content.UTF8String, '<') == NULL
             &&
             strchr(content.UTF8String, '$') == NULL
             ,
             @"KeyPathExtension:\n  Predicate, subkey, regkey are disable in KeysAccessor.");
    
    
    NSEnumerator*   enumerator  = [[content componentsSeparatedByString:@","] objectEnumerator];
    id              path , ret;
    NSMutableArray* results     = [NSMutableArray array];
    while ((path = enumerator.nextObject)) {
        
        ret = [target kpe_valueForExtensionPath:path];
        [results addObject:ret?:NSNull.null];
    }
    
    return results;
}

 - (id)callPathFunctionByTarget:(id)target
{
    if(!target)
        return nil;
    
    return [KeyPathExtension pathFunctionNamed:self.functionName](target);
}

- (BOOL)callClassInspectorByTarget:(id _Nullable)target
{
    ///Class(~)?
    
    return
    
    
    
    [target isKindOfClass:
     
     NSClassFromString
     (
      [[_stringValue substringWithRange: NSMakeRange(6, _stringValue.length - 8)]
       stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
     )
    ]
    ;
}

- (BOOL)callSELInspectorByTarget:(id)target
{
    ///SEL(~)?
    
    return
     
    [target respondsToSelector:
      
      NSSelectorFromString
      (
       [[_stringValue substringWithRange: NSMakeRange(4, _stringValue.length - 6)]
        stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
      )
    ]
    ;
}


- (NSString*)functionName
{
    if(!_functionName){
        
        _functionName = [_stringValue substringFromIndex:1];
    }
    return _functionName;
}

- (void)setStringValue:(NSString *)stringValue
{
    _stringValue = stringValue;
    
    _functionName = nil;
}

+ (void)cleanCache
{
    static dispatch_semaphore_t signalSemaphore;
    static dispatch_once_t onceTokenSemaphore;
    dispatch_once(&onceTokenSemaphore, ^{
        signalSemaphore = dispatch_semaphore_create(1);
    });
    
    dispatch_semaphore_wait(signalSemaphore, DISPATCH_TIME_FOREVER);
    
    [_cachedFormatCount removeAllObjects];
    
    dispatch_semaphore_signal(signalSemaphore);
}

static NSMutableDictionary* _cachedFormatCount;

- (NSUInteger)predicateArgumentCount
{
    
    static NSCharacterSet* _formatKeyChars;
    static NSCharacterSet* _formatNumberChars;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        /**
         https://developer.apple.com/library/archive/documentation/CoreFoundation/Conceptual/CFStrings/formatSpecifiers.html#//apple_ref/doc/uid/TP40004265
         &
         https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Predicates/Articles/pSyntax.html#//apple_ref/doc/uid/TP40001795
         */
        
        _formatKeyChars = [NSCharacterSet characterSetWithCharactersInString:@"@dDuUxXoOfeEgGcCsSpsAFp"];
        
        _formatNumberChars = [NSCharacterSet decimalDigitCharacterSet];
        
        _cachedFormatCount = [NSMutableDictionary dictionary];
    });
    
    if(_cachedFormatCount[_stringValue] != nil){
        
        return [_cachedFormatCount[_stringValue] unsignedIntegerValue];
    }
    /**
     
     %-n.nlX
     %K
     %zx
    x = {dDuUxXoOfeEgGcCsSpsAFpK}
     
     */
    
    if(strchr([_stringValue UTF8String], '%') == NULL){
        
        _cachedFormatCount[_stringValue] = [NSNumber numberWithUnsignedInteger:0];
        return 0;
    }
    
    __block NSUInteger  count           = 0;
    __block NSUInteger  searchStep      = 0;
    __block unichar     charForStep7    = 0;
    __block unichar     charString      = 0;
    [_stringValue enumerateSubstringsInRange:NSMakeRange(2, _stringValue.length-3) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        
        charString = [substring characterAtIndex:0];
        /**
         0  :   `%`?
         1  :   `-`?
         2  :   `Number`?
         3  :   `.`?
         4  :   `Number`?
         5  :   {lz}?
         6  :   B?
         7  :   `?`?The specified character
         */
        
        switch (searchStep) {
            case 0  :   goto CALL_STEP_0;
            case 1  :   goto CALL_STEP_1;
            case 2  :
            case 4  :   goto CALL_STEP_2_4;
            case 3  :   goto CALL_STEP_3;
            case 5  :   goto CALL_STEP_5;
            case 6  :   goto CALL_STEP_6;
            case 7  :   goto CALL_STEP_7;
            default :   return;
        }
        
        
    CALL_STEP_0:
        {
            if(charString == '%')
            {
                searchStep = 1;
            }
            return;
        }
        
    CALL_STEP_1:
        {
            if(charString == '-')
            {
                searchStep = 2;
                return;
            }
            else if (charString == 'K' || charString == '@')
            {
                ///%K
                count++;
                searchStep = 0;
                return;
            }
            else if (charString == '@')
            {
                ///%%
                searchStep = 0;
                return;
            }
            
        }
        
    CALL_STEP_2_4:
        {
            ///Number
            ///%2
            ///%-2.4
            if([_formatNumberChars characterIsMember:charString]){
                
                searchStep = (searchStep == 3) ? 4 : 2;
                return;
            }
        }

        
    CALL_STEP_3:
        {
            
            if (searchStep < 4 && charString == '.')
            {
                ///%*.
                searchStep = 4;
                return;
            }
            
        }
        
    CALL_STEP_5:
        {
            ///lz
            if(charString == 'z'){
                
                charForStep7 = 'x';
                searchStep = 7;
                return;
            }else if (charString == 'l'){
                
                searchStep = 6;
                return;
            }
            
        }
        
    CALL_STEP_6:
        {
            
            if([_formatKeyChars characterIsMember:charString]){
                
                count++;
            }
            searchStep = 0;
        }
        
        return;
        
    CALL_STEP_7:
        {
            if(charString == charForStep7){
                count++;
            }
            searchStep = 0;
        }
        
    }];
    
    _cachedFormatCount[_stringValue] = [NSNumber numberWithUnsignedInteger:count];
    return count;
}

- (NSString *)predicateString
{
    ///@:~!
    return [_stringValue substringWithRange:NSMakeRange(2, _stringValue.length-3)];
}

- (BOOL)isKeyPath
{
    return !!strchr([_stringValue UTF8String], '.');
}


- (id)indexerSubarray:(__kindof NSArray*)array
{
    return [self indexerValue:nil array:array flag:0];
}

- (void)indexerSetValue:(id)value forMutableArray:(NSMutableArray*)mArray
{
    [self indexerValue:value array:mArray flag:1];
}

/**
 @param flag setValue:1/getValue:0
 */
- (id)indexerValue:(id)value array:(__kindof NSArray*)array flag:(BOOL)flag
{
    
    NSString* content = [_stringValue substringWithRange:NSMakeRange(2, _stringValue.length - 3)];
    content = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    const char* charString = content.UTF8String;
    NSAssert(strlen(charString) != 0, @"Index accessor missing content!");
    
    for (NSUInteger i = 0; i < strlen(charString); i++) {
        
        if(charString[i] == 'i'
           ||
           charString[i] == '!'
           ||
           charString[i] == ',')
        {
            goto CALL_CONDITION_WORDS;
        }
    }
    
    if(flag){
        
        [array setObject:value atIndexedSubscript:[content integerValue]];
        return nil;
    }
    return array[[content integerValue]];
    
    
CALL_CONDITION_WORDS:;
    
    
    NSEnumerator* componentsEnumerator = [content componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]].objectEnumerator;
    
    NSMutableIndexSet* assertIdxSet      =   [NSMutableIndexSet indexSet];
    NSRange     left    =   NSMakeRange(NSNotFound, 0);///left direction ==>
    NSRange     right   =   NSMakeRange(NSNotFound, 0);//right direction <==
    char        aChar   ,   keyChar = 0;
    BOOL        hasEqChar;
    /**
     Indicates that the assertIdxSet content is true or false
     -1 : false
     1  : true
     0  : none
     */
    NSInteger   boolFlag    =   0;
    /**
     i>= , i!= , i<= , !5 , 5
     Step
     :
     0  :   i or !(+=3)
     1  :   !><
     2  :   =
     3  :   Number
     */
    NSUInteger  step;
    while ((charString = [componentsEnumerator.nextObject UTF8String])) {
        
        keyChar     =   0;
        step        =   0;
        hasEqChar   =   NO;
        for (NSUInteger i = 0; i < strlen(charString); i++)
        {
            aChar = charString[i];
            
            switch (step)
            {
                case 0      :   goto CALL_STEP_0;
                case 1      :   goto CALL_STEP_1;
                case 2      :   goto CALL_STEP_2;
                case 3      :   goto CALL_STEP_3;
            }
            
        CALL_STEP_0:
            {
                
                if(aChar == 'i'){
                    
                    step = 1;
                    continue;
                }else if (aChar == '!'){
                    
                    keyChar = aChar;
                    step = 3;
                    continue;
                }else if (aChar >= '0' && aChar <= '9'){
                    
                    goto CALL_STEP_3;
                }
                NSAssert(NO, @"KeyPathExtension:\n Wrong indexer format!");
            }
        CALL_STEP_1:
            {
                ///!><
                NSAssert(aChar == '<' || aChar == '!' || aChar == '>', @"KeyPathExtension:\n Wrong indexer format!");
                keyChar = aChar;
                step = 2;
                continue;
            }
        CALL_STEP_2:
            {
                if((hasEqChar = (aChar == '='))){
                    step = 3;
                    continue;
                }
            }
        CALL_STEP_3:
            {
                NSAssert(aChar >= '0' && aChar <= '9', @"KeyPathExtension:\n Wrong indexer format ! The character '%c' is forbidden " , aChar);
                
                NSInteger number = [[NSString stringWithUTF8String:charString + i] integerValue];
                switch (keyChar)
                {
                    case '<':
                    {
                        left.location = 0;
                        left.length = number + hasEqChar;
                    }
                        break;
                    case '!':
                    {
                        boolFlag = -1;
                        [assertIdxSet addIndex:number];
                    }
                        break;
                    case '>':
                    {
                        right.location = 1 + number - hasEqChar;
                        right.length = array.count -  right.location;
                    }
                        break;
                    default:
                    {
                        boolFlag = 1;
                        [assertIdxSet addIndex:number];
                    }
                        break;
                }
                ///Finish step 3.
                break;
            }
        }
    }
    
    NSMutableIndexSet* idxSet = [NSMutableIndexSet indexSet];
    
    if(left.location == NSNotFound || right.location == NSNotFound){
        
        [idxSet addIndexesInRange:(right.location == NSNotFound) ? left : right];
    }
    else if(left.location != NSNotFound && right.location != NSNotFound){
        
        if(left.length - 1 < right.location){
            
            [idxSet addIndexesInRange:left];
            [idxSet addIndexesInRange:right];
        }
        else{
            
            [idxSet addIndexesInRange:NSIntersectionRange(left, right)];
        }
    }
    
    if(boolFlag){
        
        if(boolFlag == 1){
            
            [idxSet addIndexes:assertIdxSet];
        }
        else{
            
            [idxSet removeIndexes:assertIdxSet];
        }
    }
    
    if(flag){
        
        [idxSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
            
            [array setObject:value atIndexedSubscript:idx];
        }];
        return nil;
    }
    
    NSAssert(idxSet.count <= array.count, @"KeyPathExtension:\n Array overflow!");
    return [array objectsAtIndexes:idxSet];
}

- (instancetype)copy
{
    KPEPathComponent* _copy = [[self.class alloc] init];
    
    _copy.stringValue   = _stringValue;
    _copy.suffixLength  = _suffixLength;
    _copy.componentType = _componentType;
    
    return _copy;
}

@end
