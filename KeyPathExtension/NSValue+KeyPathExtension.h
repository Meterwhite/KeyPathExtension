//
//  NSValue+KVCExtension.h
//  KVCExtensionProgram
//
//  Created by NOVO on 2018/10/19.
//  Copyright © 2018 NOVO. All rights reserved.
//  https://github.com/qddnovo/KeyPathExtension
//

#import <Foundation/Foundation.h>

/**
 Access struct value by KeyPath.
 All structures accessed by this method must have been registered in KeyPathExtension
 
 Example -
 :
 `fram.size.width`
 
 */
@interface NSValue(NSValueKeyPathExtension)

/**
 
 Example -
 :
 [anyCGRectValue  kpe_structValueForKey:@"size"];
 */
- (__kindof NSValue* _Nullable)kpe_structValueForKey:(NSString* _Nonnull)key;
/** Refer to : kpe_structValueForKey */
- (NSValue* _Nonnull)setStructValue:(id _Nullable)value forKey:(NSString* _Nonnull)key;

/**
 
 Example -
 :
 [anyCGRectValue  kpe_structValueForKeyPath:@"size.width"];
 */
- (__kindof NSValue* _Nullable)kpe_structValueForKeyPath:(NSString* _Nonnull)keyPath;
/** Refer to : kpe_structValueForKeyPath */
- (NSValue* _Nonnull)setStructValue:(id _Nullable)value forKeyPath:(NSString* _Nonnull)keyPath;



/**
 Indicate that this Object is representation of struct.
 */
- (BOOL)kpe_valueIsNumberRepresentation;

/**
 Indicate that this Object is representation of struct.
 */
- (BOOL)kpe_valueIsStructRepresentation;




/**
 Refer to : KeyPathExtension.h
 */
+ (void)kpe_registStruct:(NSString*_Nonnull)encode getterMap:(NSDictionary*_Nonnull)getterMap;
/**
 Refer to : KeyPathExtension.h
 */
+ (void)kpe_registStruct:(NSString*_Nonnull)encode setterMap:(NSDictionary*_Nonnull)setterMap;


@end


