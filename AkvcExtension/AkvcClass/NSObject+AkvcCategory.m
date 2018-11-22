//
//  NSObject+AkvcCategory.m
//  AkvcExtensionSample
//
//  Created by NOVO on 2018/11/22.
//  Copyright © 2018 NOVO. All rights reserved.
//

#import "NSInvocation+AkvcCategory.h"
#import "NSObject+AkvcCategory.h"
#import "AkvcExtensionConst.h"

@implementation NSObject(NSObjectAkvcCategory)

- (id)akvc_performSelector:(SEL)aSelector
{
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:aSelector];
    
    NSAssert(signature != nil, @"AkvcExtension:\n Unknown Method: %s", sel_getName(aSelector));
    
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
    }else if (strcmp(objcType, @encode(Class))){
        
        Class ret;
        [invocation getReturnValue:&ret];
        return ret;
    }else if (strcmp(objcType, @encode(IMP))
              ||
              objcType[0] == '^'){
        
        void* ret = NULL;
        [invocation getReturnValue:&ret];
        return [NSValue valueWithPointer:ret];
    }else if (strcmp(objcType, @encode(SEL))){
        
        SEL ret = NULL;
        [invocation getReturnValue:&ret];
        return NSStringFromSelector(ret);
    }else if (strcmp(objcType, @encode(double))){
        
        double ret = 0.0;
        [invocation getReturnValue:&ret];
        return [NSNumber numberWithDouble:ret];
    }else if (strcmp(objcType, @encode(float))){
        
        float ret = 0.0;
        [invocation getReturnValue:&ret];
        return [NSNumber numberWithFloat:ret];
        
    }else if (strcmp(objcType, @encode(char *)) == 0){
        
        const char * ret;
        [invocation getReturnValue:&ret];
        return [NSString stringWithUTF8String:ret];
    }else if (strcmp(objcType, @encode(unsigned long))){
        
        unsigned long ret = 0.0;
        [invocation getReturnValue:&ret];
        return [NSNumber numberWithUnsignedLong:ret];
    }else if (strcmp(objcType, @encode(unsigned long))){
        
        unsigned long ret = 0.0;
        [invocation getReturnValue:&ret];
        return [NSNumber numberWithUnsignedLong:ret];
    }else if (strcmp(objcType, @encode(unsigned long long))){
        
        unsigned long long ret = 0.0;
        [invocation getReturnValue:&ret];
        return [NSNumber numberWithUnsignedLongLong:ret];
    }else if (strcmp(objcType, @encode(long))){
        
        long ret = 0.0;
        [invocation getReturnValue:&ret];
        return [NSNumber numberWithLong:ret];
    }else if (strcmp(objcType, @encode(long long))){
        
        long long ret = 0.0;
        [invocation getReturnValue:&ret];
        return [NSNumber numberWithLongLong:ret];
    }else if (strcmp(objcType, @encode(int))){
        
        int ret = 0.0;
        [invocation getReturnValue:&ret];
        return [NSNumber numberWithInt:ret];
    }else if (strcmp(objcType, @encode(int))){
        
        int ret = 0.0;
        [invocation getReturnValue:&ret];
        return [NSNumber numberWithInt:ret];
    }else if (strcmp(objcType, @encode(unsigned int))){
        
        unsigned int ret = 0.0;
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
        
        short ret = 0.0;
        [invocation getReturnValue:&ret];
        return [NSNumber numberWithShort:ret];
    }else if (strcmp(objcType, @encode(NSRange))){
        
        NSRange ret;
        [invocation getReturnValue:&ret];
        return [NSValue valueWithRange:ret];
    }else if (strcmp(objcType, @encode(CATransform3D))){
        
        CATransform3D ret;
        [invocation getReturnValue:&ret];
        return [NSValue valueWithCATransform3D:ret];
    }
    
    
    #if TARGET_OS_IPHONE || TARGET_OS_TV
    
    else if (strcmp(objcType, @encode(CGRect))){
        
        CGRect ret;
        [invocation getReturnValue:&ret];
        return [NSValue valueWithCGRect:ret];
    }else if (strcmp(objcType, @encode(CGPoint))){
        
        CGPoint ret;
        [invocation getReturnValue:&ret];
        return [NSValue valueWithCGPoint:ret];
    }else if (strcmp(objcType, @encode(CGSize))){
        
        CGSize ret;
        [invocation getReturnValue:&ret];
        return [NSValue valueWithCGSize:ret];
    }else if (strcmp(objcType, @encode(UIEdgeInsets))){
        
        UIEdgeInsets ret;
        [invocation getReturnValue:&ret];
        return [NSValue valueWithUIEdgeInsets:ret];
    }else if (strcmp(objcType, @encode(UIOffset))){
        
        UIOffset ret;
        [invocation getReturnValue:&ret];
        return [NSValue valueWithUIOffset:ret];
    }else if (strcmp(objcType, @encode(CGAffineTransform))){
        
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
    
    else if (strcmp(objcType, @encode(NSRect))){
        
        NSRect ret;
        [invocation getReturnValue:&ret];
        return [NSValue valueWithRect:ret];
    }else if (strcmp(objcType, @encode(NSPoint))){
        
        NSPoint ret;
        [invocation getReturnValue:&ret];
        return [NSValue valueWithPoint:ret];
    }else if (strcmp(objcType, @encode(NSSize))){
        
        NSSize ret;
        [invocation getReturnValue:&ret];
        return [NSValue valueWithSize:ret];
    }else if (strcmp(objcType, @encode(NSEdgeInsets))){
        
        NSEdgeInsets ret;
        [invocation getReturnValue:&ret];
        return [NSValue valueWithEdgeInsets:ret];
    }
    
    #endif
    
    return nil;
}
@end
