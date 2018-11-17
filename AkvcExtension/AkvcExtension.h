//
//  KVCExtension.h
//  KVCExtensionProgram
//
//  Created by NOVO on 2018/10/21.
//  Copyright © 2018 NOVO. All rights reserved.
//  https://github.com/qddnovo/AkvcExtension
//

#import <CoreGraphics/CoreGraphics.h>
#import "NSObject+AkvcExtension.h"
#import "NSValue+AkvcExtension.h"


/**
 Given a scalar or struct value, wraps it in NSValue
 Base on : https://github.com/SnapKit/Masonry
 */
#define AkvcBoxValue(value)    \
    \
Akvc_boxValue(@encode(__typeof__((value))), (value))

@interface AkvcExtension : NSProxy

/**
 Regist a path function for user in AkvcExtension.
 注册自定义的PathFunction
 Example -
 :
 [self registFunction:@"firstObject" withBlock:^id(id target) {
    return [target firstObject];
 }];
 
 Default path function
 ----------------------
 @nslog             :   NSLog this object
 @firstObject
 @lastObject
 @isNSNull
 @isTure
 @isFalse
 @isAllEqual        :   Determines whether each subitem of the collection is equal.
 @isAllDifferent    :   Determines whether each subitem of the collection is not equal.
 ----------------------
 @param name Function name
 @param block Target is the object that calls this block.
 */
+ (void)registFunction:(NSString* _Nonnull)name withBlock:(id(^)(id _Nullable target))block;


/**
 Regist a structure in AkvcExtension(Getter).
 
 GetBlockType -
 :
 __kindof NSValue*(^GetBlockType)(NSValue* value);
 
 Example -
 :
 [AkvcExtension registStruct:@(\@encode(CGSize))
                   getterMap:@{
                                @"size"   : ^(NSValue* value){ Get value and return ... }
                                          ,
                                @"origin" : ^(NSValue* value){ ... }
 }];
 
 */
+ (void)registStruct:(NSString*)encode getterMap:(NSDictionary*)getterMap;


/**
 Regist a structure in AkvcExtension(Setter).
 
 SetBlockType -
 :
 __kindof NSValue*(^SetBlockType)(NSValue* value , id newValue);
 
 Example -
 :
 [AkvcExtension registStruct:@(\@encode(CGSize))
                   setterMap:@{
                                @"size"   : ^(NSValue* value, id newValue){ ...Set value and return... }
                                          ,
                                @"origin" : ^(NSValue* value, id newValue){ ... }
 }];
 
 */
+ (void)registStruct:(NSString*)encode setterMap:(NSDictionary*)setterMap;


/**
 Clean all cached path component.清除缓存路径组件
 */
+ (void)cleanCache;


/**
 Get path function from AkvcExtension
 */
+ (id(^)(id target))pathFunctionNamed:(NSString* _Nonnull)name;
@end


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
    }
    va_end(v);
    return obj;
}
