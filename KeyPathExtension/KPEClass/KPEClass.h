//
//  KPEAppleClass.h
//  KeyPathExtensionSample
//
//  Created by NOVO on 2018/10/21.
//  Copyright © 2018 NOVO. All rights reserved.
//  https://github.com/qddnovo/KeyPathExtension
//

#import <Foundation/Foundation.h>


@interface NSObject(KPEClass)

/**
 Determines whether the type is Common Foundation Class.
 (Not fully overwrite all base types.)
 判断基础类型(并不能完全覆盖)
 */
+ (BOOL)kpe_isBaseClass;


/**
 Enumerate class.
 遍历类型
 */
+ (void)kpe_classEnumerateUsingBlock:(void (^)(__unsafe_unretained Class, BOOL *))block includeBaseClass:(BOOL)includeBaseClass;

@end
