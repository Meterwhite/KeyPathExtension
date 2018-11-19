#ifndef __AkvcExtensionConst__H__
#define __AkvcExtensionConst__H__

#import <Foundation/Foundation.h>

/**
 *  成员变量类型（属性类型）
 */
NSString *const AkvcTypeInt         = @"i";
NSString *const AkvcTypeShort       = @"s";
NSString *const AkvcTypeFloat       = @"f";
NSString *const AkvcTypeDouble      = @"d";
NSString *const AkvcTypeLong        = @"l";
NSString *const AkvcTypeLongLong    = @"q";
NSString *const AkvcTypeChar        = @"c";
NSString *const AkvcTypeBOOL1       = @"c";
NSString *const AkvcTypeBOOL2       = @"b";
NSString *const AkvcTypePointer     = @"*";

NSString *const AkvcTypeIvar        = @"^{objc_ivar=}";
NSString *const AkvcTypeMethod      = @"^{objc_method=}";
NSString *const AkvcTypeBlock       = @"@?";
NSString *const AkvcTypeClass       = @"#";
NSString *const AkvcTypeSEL         = @":";
NSString *const AkvcTypeId          = @"@";

NSString *const AkvcPropertyReadonly= @"R";
NSString *const AkvcPropertyVoid    = @"V";
#endif
