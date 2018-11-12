//
//  NSValue+KVCExtension.h
//  KVCExtensionProgram
//
//  Created by NOVO on 2018/10/19.
//  Copyright © 2018 NOVO. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Access struct value by KeyPath.
 All structures accessed by this method must have been registered in AkvcExtension
 
 Example -
 :
 `fram.size.width`
 
 */
@interface NSValue(NSValueAkvcExtension)

/**
 
 Example -
 :
 [anyCGRectValue  akvc_structValueForKey:@"size"];
 */
- (__kindof NSValue* _Nullable)akvc_structValueForKey:(NSString* _Nonnull)key;
/** Refer to : akvc_structValueForKey */
- (NSValue* _Nonnull)setStructValue:(id _Nullable)value forKey:(NSString* _Nonnull)key;

/**
 
 Example -
 :
 [anyCGRectValue  akvc_structValueForKeyPath:@"size.width"];
 */
- (__kindof NSValue* _Nullable)akvc_structValueForKeyPath:(NSString* _Nonnull)keyPath;
/** Refer to : akvc_structValueForKeyPath */
- (NSValue* _Nonnull)setStructValue:(id _Nullable)value forKeyPath:(NSString* _Nonnull)keyPath;



/**
 Indicate that this Object is representation of struct.
 */
- (BOOL)akvc_valueIsNumberRepresentation;

/**
 Indicate that this Object is representation of struct.
 */
- (BOOL)akvc_valueIsStructRepresentation;




/**
 Refer to : AkvcExtension.h
 */
+ (void)akvc_registStruct:(NSString*)encode getterMap:(NSDictionary*)getterMap;
/**
 Refer to : AkvcExtension.h
 */
+ (void)akvc_registStruct:(NSString*)encode setterMap:(NSDictionary*)setterMap;


@end


