//
//  KPEExtensionPath.h
//  KeyPathExtensionSample
//
//  Created by NOVO on 2018/10/27.
//  Copyright © 2018 NOVO. All rights reserved.
//  https://github.com/qddnovo/KeyPathExtension
//

#import <Foundation/Foundation.h>

@class KPEPathComponent;


/**
 A full extension key path.
 */
@interface KPEExtensionPath : NSObject

@property (nonatomic,copy,readonly,nonnull) NSString* stringValue;

+ (nonnull instancetype)pathFast:(nonnull NSString*)path;

- (nonnull NSEnumerator<KPEPathComponent*>*)componentEnumerator;

@end

