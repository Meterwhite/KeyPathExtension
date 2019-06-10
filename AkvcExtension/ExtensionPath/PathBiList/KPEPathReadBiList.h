//
//  KPEPathReadBiList.h
//  KeyPathExtensionSample
//
//  Created by NOVO on 2018/10/22.
//  Copyright © 2018 NOVO. All rights reserved.
//  https://github.com/qddnovo/KeyPathExtension
//

#import <Foundation/Foundation.h>

@class KPEPathReadNode;


/**
 Binary linked list of match
 用于读取路径小节的二叉链表
 
 A --NO-> B --NO-> C...
 ⇣YES     ⇣YES
 A1       B1
 ⇣YES     ⇣
 A2       ...
 ⇣
 ...
 */
@interface KPEPathReadBiList : NSObject

+ (KPEPathReadBiList* _Nonnull)defaultList;

@property (nonatomic,strong,readonly,nonnull) KPEPathReadNode* rootNode;

@end

