//
//  NSObject+AkvcCategory.h
//  AkvcExtensionSample
//
//  Created by NOVO on 2018/11/22.
//  Copyright © 2018 NOVO. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject(NSObjectAkvcCategory)
- (id)akvc_performSelector:(SEL)aSelector;
@end
