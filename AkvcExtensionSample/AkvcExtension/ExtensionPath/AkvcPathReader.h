//
//  AKVCPathElementReader.h
//  AkvcExtensionSample
//
//  Created by NOVO on 2018/10/21.
//  Copyright © 2018 NOVO. All rights reserved.
//  https://github.com/qddnovo/AkvcExtension
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
 Fast means some path is combined.Checking most characters is not comprehensive.

 @param vale a string component.
 @return nil means continue.
 */
- (AkvcPathComponent*)readValueFast:(NSString*)vale;

/**
 Notice reader read finished.
 */
- (AkvcPathComponent*)endRead;


@end


