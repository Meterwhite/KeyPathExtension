//
//  NSObject+KPECategory.m
//  KeyPathExtensionSample
//
//  Created by NOVO on 2018/11/22.
//  Copyright © 2018 NOVO. All rights reserved.
//  https://github.com/qddnovo/KeyPathExtension
//

#import "NSObject+KPECategory.h"
#import "KeyPathExtensionConst.h"
#import <objc/runtime.h>

@implementation NSObject(NSObjectKPECategory)

- (id)kpe_performSelector:(SEL)aSelector
{
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:aSelector];
    
    NSAssert(signature != nil, @"KeyPathExtension:\n Unknown Method: %s", sel_getName(aSelector));
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = aSelector;
    [invocation invoke];
    
    if(signature.methodReturnLength == 0) return nil;
    
    const char* objcType = signature.methodReturnType;
    
    if (objcType[0] == _C_CONST) objcType++;
    
    if(objcType[0] == _C_ID){
        
        ///id or block
        id __unsafe_unretained ret;
        [invocation getReturnValue:&ret];
        return ret;
    }else if (strcmp(objcType, @encode(Class)) == 0){
        
        Class ret;
        [invocation getReturnValue:&ret];
        return ret;
    }else if (strcmp(objcType, @encode(IMP)) == 0
              ||
              objcType[0] == '^'){
        
        void* ret = NULL;
        [invocation getReturnValue:&ret];
        return [NSValue valueWithPointer:ret];
    }else if (strcmp(objcType, @encode(SEL)) == 0){
        
        SEL ret = NULL;
        [invocation getReturnValue:&ret];
        return NSStringFromSelector(ret);
    }else if (strcmp(objcType, @encode(double)) == 0){
        
        double ret;
        [invocation getReturnValue:&ret];
        return [NSNumber numberWithDouble:ret];
    }else if (strcmp(objcType, @encode(float)) == 0){
        
        float ret;
        [invocation getReturnValue:&ret];
        return [NSNumber numberWithFloat:ret];
        
    }else if (strcmp(objcType, @encode(char *)) == 0){
        
        const char * ret;
        [invocation getReturnValue:&ret];
        return [NSString stringWithUTF8String:ret];
    }else if (strcmp(objcType, @encode(unsigned long)) == 0){
        
        unsigned long ret;
        [invocation getReturnValue:&ret];
        return [NSNumber numberWithUnsignedLong:ret];
    }else if (strcmp(objcType, @encode(unsigned long)) == 0){
        
        unsigned long ret;
        [invocation getReturnValue:&ret];
        return [NSNumber numberWithUnsignedLong:ret];
    }else if (strcmp(objcType, @encode(unsigned long long)) == 0){
        
        unsigned long long ret;
        [invocation getReturnValue:&ret];
        return [NSNumber numberWithUnsignedLongLong:ret];
    }else if (strcmp(objcType, @encode(long)) == 0){
        
        long ret;
        [invocation getReturnValue:&ret];
        return [NSNumber numberWithLong:ret];
    }else if (strcmp(objcType, @encode(long long)) == 0){
        
        long long ret;
        [invocation getReturnValue:&ret];
        return [NSNumber numberWithLongLong:ret];
    }else if (strcmp(objcType, @encode(int)) == 0){
        
        int ret;
        [invocation getReturnValue:&ret];
        return [NSNumber numberWithInt:ret];
    }else if (strcmp(objcType, @encode(int)) == 0){
        
        int ret;
        [invocation getReturnValue:&ret];
        return [NSNumber numberWithInt:ret];
    }else if (strcmp(objcType, @encode(unsigned int)) == 0){
        
        unsigned int ret;
        [invocation getReturnValue:&ret];
        return [NSNumber numberWithUnsignedInt:ret];
    }else if ((strcmp(objcType, @encode(BOOL))          == 0
               ||
               strcmp(objcType, @encode(bool))          == 0
               ||
               strcmp(objcType, @encode(char))          == 0
               ||
               strcmp(objcType, @encode(short))         == 0
               ||
               strcmp(objcType, @encode(unsigned char)) == 0
               ||
               strcmp(objcType, @encode(unsigned short))== 0)){
        
        short ret;
        [invocation getReturnValue:&ret];
        return [NSNumber numberWithShort:ret];
    }else if (strcmp(objcType, @encode(NSRange)) == 0){
        
        NSRange ret;
        [invocation getReturnValue:&ret];
        return [NSValue valueWithRange:ret];
    }else if (strcmp(objcType, @encode(CATransform3D)) == 0){
        
        CATransform3D ret;
        [invocation getReturnValue:&ret];
        return [NSValue valueWithCATransform3D:ret];
    }
    
    
    #if TARGET_OS_IPHONE || TARGET_OS_TV
    
    else if (strcmp(objcType, @encode(CGRect)) == 0){
        
        CGRect ret;
        [invocation getReturnValue:&ret];
        return [NSValue valueWithCGRect:ret];
    }else if (strcmp(objcType, @encode(CGPoint)) == 0){
        
        CGPoint ret;
        [invocation getReturnValue:&ret];
        return [NSValue valueWithCGPoint:ret];
    }else if (strcmp(objcType, @encode(CGSize)) == 0){
        
        CGSize ret;
        [invocation getReturnValue:&ret];
        return [NSValue valueWithCGSize:ret];
    }else if (strcmp(objcType, @encode(UIEdgeInsets)) == 0){
        
        UIEdgeInsets ret;
        [invocation getReturnValue:&ret];
        return [NSValue valueWithUIEdgeInsets:ret];
    }else if (strcmp(objcType, @encode(UIOffset)) == 0){
        
        UIOffset ret;
        [invocation getReturnValue:&ret];
        return [NSValue valueWithUIOffset:ret];
    }else if (strcmp(objcType, @encode(CGAffineTransform)) == 0){
        
        CGAffineTransform ret;
        [invocation getReturnValue:&ret];
        return [NSValue valueWithCGAffineTransform:ret];
    }
    if (@available(iOS 11.0, *)){
        
        if(strcmp(objcType, @encode(NSDirectionalEdgeInsets)) == 0){
            
            NSDirectionalEdgeInsets ret;
            [invocation getReturnValue:&ret];
            return [NSValue valueWithDirectionalEdgeInsets:ret];
        }
    }
    
    #elif TARGET_OS_MAC
    
    else if (strcmp(objcType, @encode(NSRect)) == 0){
        
        NSRect ret;
        [invocation getReturnValue:&ret];
        return [NSValue valueWithRect:ret];
    }else if (strcmp(objcType, @encode(NSPoint)) == 0){
        
        NSPoint ret;
        [invocation getReturnValue:&ret];
        return [NSValue valueWithPoint:ret];
    }else if (strcmp(objcType, @encode(NSSize)) == 0){
        
        NSSize ret;
        [invocation getReturnValue:&ret];
        return [NSValue valueWithSize:ret];
    }else if (strcmp(objcType, @encode(NSEdgeInsets)) == 0){
        
        NSEdgeInsets ret;
        [invocation getReturnValue:&ret];
        return [NSValue valueWithEdgeInsets:ret];
    }
    
    #endif
    
    return nil;
}
@end
