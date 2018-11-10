//
//  NSValue+KVCExtension.h
//  KVCExtensionProgram
//
//  Created by NOVO on 2018/10/19.
//  Copyright © 2018 NOVO. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSValue(NSValueAkvcExtension)

- (BOOL)akvc_valueIsNumberRepresentation;

- (BOOL)akvc_valueIsStructRepresentation;

- (__kindof NSValue* _Nullable)akvc_structValueForKey:(NSString* _Nonnull)key;
- (NSValue* _Nonnull)setStructValue:(id _Nullable)value forKey:(NSString* _Nonnull)key;

- (__kindof NSValue* _Nullable)akvc_structValueForKeyPath:(NSString* _Nonnull)keyPath;
- (NSValue* _Nonnull)setStructValue:(id _Nullable)value forKeyPath:(NSString* _Nonnull)keyPath;

#warning regist
+ (void)akvc_registStruct:(NSString*)encode getterMap:(NSDictionary*)getterMap;

+ (void)akvc_registStruct:(NSString*)encode setterMap:(NSDictionary*)setterMap;


@end


