//
//  AKVCPathElementReader.h
//  AKVCExtensionSample
//
//  Created by NOVO on 2018/10/21.
//  Copyright © 2018 NOVO. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AkvcPathComponent;


/**
 Object that make a response to each component string read.
 Call -[endRead] while read finished.
 逐字阅读逐小节解释
 */
@interface AkvcPathReader : NSObject

+ (instancetype)defaultReder;


/**
 Fast means some path is combined.Unsupport to check out unmatch char.

 @param vale a string component.
 @return nil means continue.
 */
- (AkvcPathComponent*)readValueFast:(NSString*)vale;

/**
 Notice reader read finished.
 */
- (AkvcPathComponent*)endRead;


@end


