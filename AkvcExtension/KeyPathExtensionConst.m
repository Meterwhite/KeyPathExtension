#ifndef __KeyPathExtensionConst__H__
#define __KeyPathExtensionConst__H__

#import <Foundation/Foundation.h>

/**
 *  成员变量类型（属性类型）
 */
NSString *const KPETypeIvar        = @"^{objc_ivar=}";
NSString *const KPETypeMethod      = @"^{objc_method=}";
NSString *const KPETypeSEL         = @":";

NSString *const KPEPropertyReadonly= @"R";
NSString *const KPEPropertyVoid    = @"V";
#endif
