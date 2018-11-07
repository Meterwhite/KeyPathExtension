//
//  NSString+AkvcStringFormat.m
//  AkvcExtensionSample
//
//  Created by NOVO on 2018/11/7.
//  Copyright © 2018 NOVO. All rights reserved.
//

#import "NSString+AkvcStringFormat.h"

@implementation NSString (AkvcStringFormat)

- (NSUInteger)akvc_argsCountForStringFormat
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
    
    if([self rangeOfString:@"%"].length == 0)
        return 0;
    
    __block NSUInteger  count           = 0;
    __block NSUInteger  searchStep      = 0;
    __block unichar     charForStep7    = 0;
    __block unichar     charString      = 0;
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        
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
            ///%3
            ///%-3.3
            if([_formatNumberChars characterIsMember:charString]){
                
                searchStep = (searchStep == 3) ? 4 : 2;
                return;
            }
        }
        
        
    CALL_STEP_3:
        {
            
            if (searchStep < 4 && charString == '.')
            {
                ///%%
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

@end
