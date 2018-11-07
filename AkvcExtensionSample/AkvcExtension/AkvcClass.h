//
//  AKVCAppleClass.h
//  AkvcExtensionSample
//
//  Created by NOVO on 2018/10/21.
//  Copyright © 2018 NOVO. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject(AkvcClass)

/**
 Determines whether the type is Common Foundation Class.
 */
+ (BOOL)akvc_isBaseClass;


+ (void)akvc_classEnumerateUsingBlock:(void (^)(__unsafe_unretained Class, BOOL *))block includeBaseClass:(BOOL)includeBaseClass;

@end
