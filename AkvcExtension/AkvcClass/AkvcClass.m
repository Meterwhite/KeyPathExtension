//
//  AKVCAppleClass.m
//  AkvcExtensionSample
//
//  Created by NOVO on 2018/10/21.
//  Copyright © 2018 NOVO. All rights reserved.
//  https://github.com/qddnovo/AkvcExtension
//

#import "AkvcExtensionConst.h"
#import <CoreData/CoreData.h>
#import <objc/runtime.h>
#import "AkvcClass.h"

@implementation  NSObject(AkvcClass)

+ (void)akvc_classEnumerateUsingBlock:(void (^)(__unsafe_unretained Class, BOOL *))block
                   includeBaseClass:(BOOL)includeBaseClass
{
    if(block == nil)
        return;
    
    BOOL    stop    =   NO;
    Class   clazz   =   self;
    
    while (clazz != nil && stop == NO) {
        
        block(clazz , &stop);
        clazz = class_getSuperclass(clazz);
        if(includeBaseClass == NO && [clazz akvc_isBaseClass] == YES)
            break;
    }
}


+ (BOOL)akvc_isBaseClass
{
    
    static NSSet *_baseDataClasses;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _baseDataClasses =
        [NSSet setWithObjects:NSClassFromString(@"NSBlock")
         , [NSNull class],[NSProxy class]
         , [NSString class],[NSValue class]
         , [NSArray class],[NSDictionary class]
         , [NSSet class],[NSOrderedSet class]
         , [NSMapTable class],[NSHashTable class]
         , [NSPointerArray class],[NSPointerFunctions class]
         , [NSIndexSet class],[NSCharacterSet class]
         , [NSURL class],[NSIndexPath class]
         , [NSAttributedString class],[NSParagraphStyle class]
         , [NSData class],[NSCoder class]
         , [NSFormatter class]
         , nil];
    });
    
    ///Root
    if(self == [NSObject class] || self == [NSManagedObject class]) return YES;
    
    id object = nil;
    NSEnumerator* enumertor = [_baseDataClasses objectEnumerator];
    while ((object = enumertor.nextObject)) {
        
        if([self isSubclassOfClass:object])
            return YES;
    }
    
    object = NSStringFromClass(self);
    if([object length] > 1){
        
        object = [object substringToIndex:2];
        
        if([self superclass] == [NSObject class]       ||
           [self superclass] == [AKVC_RESPONDER class] ||
           [self superclass] == [AKVC_VIEW class]      ||
           [self superclass] == [CALayer class]
           #if TARGET_OS_IPHONE || TARGET_OS_TV
                                                       ||
           [self superclass] == [CAAnimation class]
           #endif
           ){
            
            if(([object isEqualToString:@"NS"])     ||
               ([object isEqualToString:@"UI"])     ||
               ([object isEqualToString:@"CA"])
               ) return YES;
        }
    }
    
    return NO;
}

@end
