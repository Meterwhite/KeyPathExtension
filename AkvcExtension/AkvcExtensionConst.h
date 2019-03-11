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


/**
 * from : https://github.com/ReactiveCocoa/ReactiveObjC
 * \@aKPath allows compile-time verification of key paths. Given a real object
 * receiver and key path:
 *
 * @code
 
 NSString *UTF8StringPath = @aKPath(str.lowercaseString.UTF8String);
 // => @"lowercaseString.UTF8String"
 
 NSString *versionPath = @aKPath(NSObject, version);
 // => @"version"
 
 NSString *lowercaseStringPath = @aKPath(NSString.new, lowercaseString);
 // => @"lowercaseString"
 
 * @endcode
 *
 * ... the macro returns an \c NSString containing all but the first path
 * component or argument (e.g., @"lowercaseString.UTF8String", @"version").
 *
 * In addition to simply creating a key path, this macro ensures that the key
 * path is valid at compile-time (causing a syntax error if not), and supports
 * refactoring, such that changing the name of the property will also update any
 * uses of \@aKPath.
 */
#define akvcGetPath(...) \
akvcmacro_if_eq(1, akvcmacro_argcount(__VA_ARGS__))(aKpath1(__VA_ARGS__))(aKpath2(__VA_ARGS__))

#define akvcPathAppendCode(...) \
    akvcPathAppend(akvcmacro_make_str_(__VA_ARGS__))

#define akvcmacro_make_str_(code) \
    @""#code""

#define akvcmacro_concat_(A, B) A ## B

#define akvcmacro_concat(A, B) \
    akvcmacro_concat_(A, B)

#define akvcmacro_at(N, ...) \
    akvcmacro_concat(akvcmacro_at, N)(__VA_ARGS__)

#define akvcmacro_argcount(...) \
    akvcmacro_at(20, __VA_ARGS__, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)

#define akvcmacro_if_eq(A, B) \
    akvcmacro_concat(akvcmacro_if_eq, A)(B)

#define aKpath1(PATH) \
    (((void)(NO && ((void)PATH, NO)), strchr(# PATH, '.') + 1))

#define aKpath2(OBJ, PATH) \
    (((void)(NO && ((void)OBJ.PATH, NO)), # PATH))


#define akvcmacro_head_(FIRST, ...) FIRST

#define akvcmacro_head(...) \
    akvcmacro_head_(__VA_ARGS__, 0)

// akvcmacro_at expansions
#define akvcmacro_at0(...) akvcmacro_head(__VA_ARGS__)
#define akvcmacro_at1(_0, ...) akvcmacro_head(__VA_ARGS__)
#define akvcmacro_at2(_0, _1, ...) akvcmacro_head(__VA_ARGS__)
#define akvcmacro_at3(_0, _1, _2, ...) akvcmacro_head(__VA_ARGS__)
#define akvcmacro_at4(_0, _1, _2, _3, ...) akvcmacro_head(__VA_ARGS__)
#define akvcmacro_at5(_0, _1, _2, _3, _4, ...) akvcmacro_head(__VA_ARGS__)
#define akvcmacro_at6(_0, _1, _2, _3, _4, _5, ...) akvcmacro_head(__VA_ARGS__)
#define akvcmacro_at7(_0, _1, _2, _3, _4, _5, _6, ...) akvcmacro_head(__VA_ARGS__)
#define akvcmacro_at8(_0, _1, _2, _3, _4, _5, _6, _7, ...) akvcmacro_head(__VA_ARGS__)
#define akvcmacro_at9(_0, _1, _2, _3, _4, _5, _6, _7, _8, ...) akvcmacro_head(__VA_ARGS__)
#define akvcmacro_at10(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, ...) akvcmacro_head(__VA_ARGS__)
#define akvcmacro_at11(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, ...) akvcmacro_head(__VA_ARGS__)
#define akvcmacro_at12(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, ...) akvcmacro_head(__VA_ARGS__)
#define akvcmacro_at13(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, ...) akvcmacro_head(__VA_ARGS__)
#define akvcmacro_at14(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, ...) akvcmacro_head(__VA_ARGS__)
#define akvcmacro_at15(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, ...) akvcmacro_head(__VA_ARGS__)
#define akvcmacro_at16(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, ...) akvcmacro_head(__VA_ARGS__)
#define akvcmacro_at17(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, ...) akvcmacro_head(__VA_ARGS__)
#define akvcmacro_at18(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, ...) akvcmacro_head(__VA_ARGS__)
#define akvcmacro_at19(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, ...) akvcmacro_head(__VA_ARGS__)
#define akvcmacro_at20(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, ...) akvcmacro_head(__VA_ARGS__)


#define akvcmacro_consume_(...)

#define akvcmacro_expand_(...) __VA_ARGS__

#define akvcmacro_dec(VAL) \
    akvcmacro_at(VAL, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19)

// ak_if_eq expansions
#define akvcmacro_if_eq0(VALUE) \
    akvcmacro_concat(akvcmacro_if_eq0_, VALUE)

#define akvcmacro_if_eq0_0(...) __VA_ARGS__ akvcmacro_consume_
#define akvcmacro_if_eq0_1(...) akvcmacro_expand_
#define akvcmacro_if_eq0_2(...) akvcmacro_expand_
#define akvcmacro_if_eq0_3(...) akvcmacro_expand_
#define akvcmacro_if_eq0_4(...) akvcmacro_expand_
#define akvcmacro_if_eq0_5(...) akvcmacro_expand_
#define akvcmacro_if_eq0_6(...) akvcmacro_expand_
#define akvcmacro_if_eq0_7(...) akvcmacro_expand_
#define akvcmacro_if_eq0_8(...) akvcmacro_expand_
#define akvcmacro_if_eq0_9(...) akvcmacro_expand_
#define akvcmacro_if_eq0_10(...) akvcmacro_expand_
#define akvcmacro_if_eq0_11(...) akvcmacro_expand_
#define akvcmacro_if_eq0_12(...) akvcmacro_expand_
#define akvcmacro_if_eq0_13(...) akvcmacro_expand_
#define akvcmacro_if_eq0_14(...) akvcmacro_expand_
#define akvcmacro_if_eq0_15(...) akvcmacro_expand_
#define akvcmacro_if_eq0_16(...) akvcmacro_expand_
#define akvcmacro_if_eq0_17(...) akvcmacro_expand_
#define akvcmacro_if_eq0_18(...) akvcmacro_expand_
#define akvcmacro_if_eq0_19(...) akvcmacro_expand_
#define akvcmacro_if_eq0_20(...) akvcmacro_expand_

#define akvcmacro_if_eq1(VALUE) akvcmacro_if_eq0(akvcmacro_dec(VALUE))
#define akvcmacro_if_eq2(VALUE) akvcmacro_if_eq1(akvcmacro_dec(VALUE))
#define akvcmacro_if_eq3(VALUE) akvcmacro_if_eq2(akvcmacro_dec(VALUE))
#define akvcmacro_if_eq4(VALUE) akvcmacro_if_eq3(akvcmacro_dec(VALUE))
#define akvcmacro_if_eq5(VALUE) akvcmacro_if_eq4(akvcmacro_dec(VALUE))
#define akvcmacro_if_eq6(VALUE) akvcmacro_if_eq5(akvcmacro_dec(VALUE))
#define akvcmacro_if_eq7(VALUE) akvcmacro_if_eq6(akvcmacro_dec(VALUE))
#define akvcmacro_if_eq8(VALUE) akvcmacro_if_eq7(akvcmacro_dec(VALUE))
#define akvcmacro_if_eq9(VALUE) akvcmacro_if_eq8(akvcmacro_dec(VALUE))
#define akvcmacro_if_eq10(VALUE) akvcmacro_if_eq9(akvcmacro_dec(VALUE))
#define akvcmacro_if_eq11(VALUE) akvcmacro_if_eq10(akvcmacro_dec(VALUE))
#define akvcmacro_if_eq12(VALUE) akvcmacro_if_eq11(akvcmacro_dec(VALUE))
#define akvcmacro_if_eq13(VALUE) akvcmacro_if_eq12(akvcmacro_dec(VALUE))
#define akvcmacro_if_eq14(VALUE) akvcmacro_if_eq13(akvcmacro_dec(VALUE))
#define akvcmacro_if_eq15(VALUE) akvcmacro_if_eq14(akvcmacro_dec(VALUE))
#define akvcmacro_if_eq16(VALUE) akvcmacro_if_eq15(akvcmacro_dec(VALUE))
#define akvcmacro_if_eq17(VALUE) akvcmacro_if_eq16(akvcmacro_dec(VALUE))
#define akvcmacro_if_eq18(VALUE) akvcmacro_if_eq17(akvcmacro_dec(VALUE))
#define akvcmacro_if_eq19(VALUE) akvcmacro_if_eq18(akvcmacro_dec(VALUE))
#define akvcmacro_if_eq20(VALUE) akvcmacro_if_eq19(akvcmacro_dec(VALUE))
