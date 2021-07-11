//
//  NSObject+KPECategory.h
//  KeyPathExtensionSample
//
//  Created by NOVO on 2018/11/22.
//  Copyright © 2018 NOVO. All rights reserved.
//  https://github.com/qddnovo/KeyPathExtension
//

#import <Foundation/Foundation.h>


@interface NSObject(NSObjectKPECategory)
- (id)kpe_performSelector:(SEL)aSelector;
@end
