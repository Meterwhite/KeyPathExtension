//
//  AkvcExtensionPath.h
//  AkvcExtensionSample
//
//  Created by NOVO on 2018/10/27.
//  Copyright © 2018 NOVO. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AkvcPathComponent;


/**
 A full extension key path.
 */
@interface AkvcExtensionPath : NSObject

@property (nonatomic,copy,readonly) NSString* stringValue;

+ (instancetype)pathFast:(NSString* _Nonnull)path;

- (NSEnumerator<AkvcPathComponent*>* _Nonnull)componentEnumerator;

@end

