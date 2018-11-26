#ifndef __AkvcExtensionConst__H__
#define __AkvcExtensionConst__H__

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE || TARGET_OS_TV

#import <UIKit/UIKit.h>
#define AKVC_VIEW           UIView
#define AKVC_RESPONDER      UIResponder
#define AKVC_EDGEINSETS     UIEdgeInsets

#elif TARGET_OS_MAC

#import <AppKit/AppKit.h>
#define AKVC_VIEW           NSView
#define AKVC_RESPONDER      NSResponder
#define AKVC_EDGEINSETS     NSEdgeInsets

#endif

//Log
#ifdef DEBUG
#define AkvcLog(...)        NSLog(__VA_ARGS__)
#else
#define AkvcLog(...)
#endif

//Deprecated
#define AkvcDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

/**
 *  Types
 */
FOUNDATION_EXPORT NSString *const AkvcTypeIvar;
FOUNDATION_EXPORT NSString *const AkvcTypeMethod;
FOUNDATION_EXPORT NSString *const AkvcTypeSEL;
FOUNDATION_EXPORT NSString *const AkvcPropertyReadonly;
FOUNDATION_EXPORT NSString *const AkvcPropertyVoid;

NS_INLINE id Akvc_boxValue(const char *type, ...) {
    va_list v;
    va_start(v, type);
    id obj = nil;
    if (strcmp(type, @encode(id)) == 0) {
        id actual = va_arg(v, id);
        obj = actual;
    } else if (strcmp(type, @encode(CGRect)) == 0) {
        CGRect actual = (CGRect)va_arg(v, CGRect);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(CGPoint)) == 0) {
        CGPoint actual = (CGPoint)va_arg(v, CGPoint);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(CGSize)) == 0) {
        CGSize actual = (CGSize)va_arg(v, CGSize);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(NSRange)) == 0) {
        NSRange actual = (NSRange)va_arg(v, NSRange);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(double)) == 0) {
        double actual = (double)va_arg(v, double);
        obj = [NSNumber numberWithDouble:actual];
    } else if (strcmp(type, @encode(float)) == 0) {
        float actual = (float)va_arg(v, double);
        obj = [NSNumber numberWithFloat:actual];
    } else if (strcmp(type, @encode(int)) == 0) {
        int actual = (int)va_arg(v, int);
        obj = [NSNumber numberWithInt:actual];
    } else if (strcmp(type, @encode(long)) == 0) {
        long actual = (long)va_arg(v, long);
        obj = [NSNumber numberWithLong:actual];
    } else if (strcmp(type, @encode(long long)) == 0) {
        long long actual = (long long)va_arg(v, long long);
        obj = [NSNumber numberWithLongLong:actual];
    } else if (strcmp(type, @encode(short)) == 0) {
        short actual = (short)va_arg(v, int);
        obj = [NSNumber numberWithShort:actual];
    } else if (strcmp(type, @encode(char)) == 0) {
        char actual = (char)va_arg(v, int);
        obj = [NSNumber numberWithChar:actual];
    } else if (strcmp(type, @encode(bool)) == 0) {
        bool actual = (bool)va_arg(v, int);
        obj = [NSNumber numberWithBool:actual];
    } else if (strcmp(type, @encode(unsigned char)) == 0) {
        unsigned char actual = (unsigned char)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedChar:actual];
    } else if (strcmp(type, @encode(unsigned int)) == 0) {
        unsigned int actual = (unsigned int)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedInt:actual];
    } else if (strcmp(type, @encode(unsigned long)) == 0) {
        unsigned long actual = (unsigned long)va_arg(v, unsigned long);
        obj = [NSNumber numberWithUnsignedLong:actual];
    } else if (strcmp(type, @encode(unsigned long long)) == 0) {
        unsigned long long actual = (unsigned long long)va_arg(v, unsigned long long);
        obj = [NSNumber numberWithUnsignedLongLong:actual];
    } else if (strcmp(type, @encode(unsigned short)) == 0) {
        unsigned short actual = (unsigned short)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedShort:actual];
    } else if (strcmp(type, @encode(AKVC_EDGEINSETS)) == 0) {
        AKVC_EDGEINSETS actual = (AKVC_EDGEINSETS)va_arg(v, AKVC_EDGEINSETS);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(CATransform3D)) == 0) {
        CATransform3D actual = (CATransform3D)va_arg(v, CATransform3D);
        obj = [NSValue value:&actual withObjCType:type];
    }
#if TARGET_OS_IPHONE || TARGET_OS_TV
    else if (strcmp(type, @encode(UIOffset)) == 0) {
        UIOffset actual = (UIOffset)va_arg(v, UIOffset);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(CGVector)) == 0) {
        CGVector actual = (CGVector)va_arg(v, CGVector);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(CGAffineTransform)) == 0) {
        CGAffineTransform actual = (CGAffineTransform)va_arg(v, CGAffineTransform);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (@available(iOS 11.0, *)) {
        
        if (strcmp(type, @encode(NSDirectionalEdgeInsets)) == 0) {
            NSDirectionalEdgeInsets actual = (NSDirectionalEdgeInsets)va_arg(v, NSDirectionalEdgeInsets);
            obj = [NSValue value:&actual withObjCType:type];
        }
    }
    
#endif
    
    va_end(v);
    return obj;
}



#define akvcValueForExtensionPathWithPredicateFormat(path,args...)\
    \
    akvcValueForExtensionPathWithPredicateFormat(path,##args,nil)

#define akvcSetValueForExtensionPathWithPredicateFormat(value,path,args...)\
    \
    akvcSetValueForExtensionPathWithPredicateFormat(value,path,##args,nil)


#endif




