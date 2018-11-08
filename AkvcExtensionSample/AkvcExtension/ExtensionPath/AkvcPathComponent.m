//
//  AKVCPathReadResult.m
//  AkvcExtensionSample
//
//  Created by NOVO on 2018/10/21.
//  Copyright © 2018 NOVO. All rights reserved.
//

#import "AkvcPathComponent.h"
#import "AkvcExtension.h"

@implementation AkvcPathComponent
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

- (id)callKeysByTarget:(id)target
{
    ///Empty keys : `{}`
    NSAssert(_stringValue.length > 2, @"AkvcExtension:\n  Keys component must contain at least one key.");
    ///Get content.
    _stringValue = [_stringValue substringWithRange:NSMakeRange(1, _stringValue.length - 2)];
    ///Check if illegal character sets are included.
    NSAssert([_stringValue rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@":<$"]].length == 0,
             @"AkvcExtension:\n  Predicate, subkey, regkey are disable in keys component.");
    
    
    NSEnumerator*   enumerator  = [[_stringValue componentsSeparatedByString:@","] objectEnumerator];
    id              path , ret;
    NSMutableArray* results     = [NSMutableArray array];
    while ((path = enumerator.nextObject)) {
        
        ret = [target valueForExtensionPath:path];
        [results addObject:ret?:NSNull.null];
    }
    
    return results;
}

 - (id)callFunctionByTarget:(id)target
{
    if(!target)
        return nil;
    
    return [AkvcExtension customFunctionNamed:self.functionName](target);
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
    });
    
    /**
     
     %-n.nlX
     %K
     %zx
    x = {dDuUxXoOfeEgGcCsSpsAFpK}
     
     */
    
    if([_stringValue rangeOfString:@"%"].length == 0)
        return 0;
    
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
    

    return count;
}

- (NSString *)predicateString
{
    ///@:~!
    return [_stringValue substringWithRange:NSMakeRange(2, _stringValue.length-3)];
}

- (BOOL)isKeyPath
{
    return [_stringValue containsString:@"."];
}

- (NSInteger)indexForindexer
{
    NSInteger   ret;
    NSScanner*  scanner  = [NSScanner scannerWithString:_stringValue];
    scanner.scanLocation = 2;
    
    if([scanner scanInteger:&ret])
        return ret;
    
    return NSNotFound;
}

- (id)indexerSubarray:(NSArray*)array
{
    
    NSString* content = [_stringValue substringWithRange:NSMakeRange(2, _stringValue.length - 3)];
    content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if([content containsString:@"%"] == NO)
    {
        ///@[Number]
        return array[[content integerValue]];
    }
    
    
    NSEnumerator* componentsEnumerator = [content componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]].objectEnumerator;
    
    NSString*   component;
    NSRange     left    =   NSMakeRange(0, 0);
    NSRange     right   =   NSMakeRange(0, 0);
    unichar     aChar   ,   keyChar = 0;
    BOOL        hasEqChar;
    /**
     %>= , %!= , %<=
     Step
     :
     0  :   %
     1  :   !><
     2  :   =
     3  :   Number
     */
    NSUInteger  step;
    while ((component = componentsEnumerator.nextObject)) {
        
        step        =   0;
        left        =   NSMakeRange(0, component.length);
        right       =   left;
        hasEqChar   =   NO;
        for (NSUInteger i = 0; i < component.length; i++)
        {
            aChar = [component characterAtIndex:i];
            
            switch (step)
            {
                case 0      :   goto CALL_STEP_0;
                case 1      :   goto CALL_STEP_1;
                case 2      :   goto CALL_STEP_2;
                case 3      :   goto CALL_STEP_3;
            }
            
        CALL_STEP_0:
            {
                NSAssert(aChar == '%', @"AkvcExtension:\n Wrong indexer format!");
                step = 1;
                continue;
            }
        CALL_STEP_1:
            {
                ///!><
                NSAssert(aChar == '<' || aChar == '!' || aChar == '>', @"AkvcExtension:\n Wrong indexer format!");
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
                NSAssert(aChar >= '0' && aChar <= '9', @"AkvcExtension:\n Wrong indexer format!");
                NSInteger number = [[component substringFromIndex:i] integerValue];
                switch (keyChar)
                {
                    case '<':
                    {
                        left.length = number + hasEqChar;
                    }
                        break;
                    case '!':
                    {
#warning ???
                        left.length = number + hasEqChar;
                        right.location = 1 + number - hasEqChar;
                        right.length -= right.location;
                    }
                        break;
                    case '>':
                    {
                        right.location = 1 + number - hasEqChar;
                        right.length -= right.location;
                    }
                        break;
                }
                ///Finish step 3.
                break;
            }
        }
    }
    
    left = NSIntersectionRange(left, right);
    
    
    return [array subarrayWithRange:left];
}

- (instancetype)copy
{
    AkvcPathComponent* _copy = [[self.class alloc] init];
    
    _copy.stringValue   = _stringValue;
    _copy.suffixLength  = _suffixLength;
    _copy.componentType = _componentType;
    
    return _copy;
}

@end
