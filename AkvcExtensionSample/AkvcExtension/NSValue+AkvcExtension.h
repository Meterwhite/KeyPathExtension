//
//  NSValue+KVCExtension.h
//  KVCExtensionProgram
//
//  Created by NOVO on 2018/10/19.
//  Copyright © 2018 NOVO. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSValue(NSValueAkvcExtension)

- (BOOL)valueIsNumberRepresentation;

- (BOOL)valueIsStructRepresentation;

- (__kindof NSValue* _Nullable)structValueForKey:(NSString* _Nonnull)key;
- (NSValue* _Nonnull)setStructValue:(id _Nullable)value forKey:(NSString* _Nonnull)key;

- (__kindof NSValue* _Nullable)structValueForKeyPath:(NSString* _Nonnull)keyPath;
- (NSValue* _Nonnull)setStructValue:(id _Nullable)value forKeyPath:(NSString* _Nonnull)keyPath;
@end


