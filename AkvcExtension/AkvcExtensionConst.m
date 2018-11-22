#ifndef __AkvcExtensionConst__H__
#define __AkvcExtensionConst__H__

#import <Foundation/Foundation.h>

/**
 *  成员变量类型（属性类型）
 */
NSString *const AkvcTypeIvar        = @"^{objc_ivar=}";
NSString *const AkvcTypeMethod      = @"^{objc_method=}";
NSString *const AkvcTypeSEL         = @":";

NSString *const AkvcPropertyReadonly= @"R";
NSString *const AkvcPropertyVoid    = @"V";
#endif
