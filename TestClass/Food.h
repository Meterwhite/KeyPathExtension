//
//  Food.h
//  KeyPathExtensionSample
//
//  Created by NOVO on 2018/11/7.
//  Copyright © 2018 NOVO. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Food : NSObject

@property (nonatomic,copy) NSString* foodName;
@property (nonatomic,assign) NSInteger amount;

@end

NS_ASSUME_NONNULL_END
