//
//  KPEPathReadNode.h
//  KeyPathExtensionSample
//
//  Created by NOVO on 2018/10/22.
//  Copyright © 2018 NOVO. All rights reserved.
//  https://github.com/qddnovo/KeyPathExtension
//

#import <Foundation/Foundation.h>
#import "KPEPathComponent.h"

typedef enum KPEPathSearchMatchFeature{
    KPEPathSearchForMatchingValue        =  1 << 0,
    KPEPathSearchForBaseNameCharacterSet =  1 << 1,
    KPEPathSearchForSelectorCharacterSet =  1 << 2,
    KPEPathSearchForIndexerCharacterSet  =  1 << 3,
    KPEPathSearchForAnyCharacterSet      =  1 << 4,
    KPEPathSearchFinishable              =  1 << 5,
    KPEPathSearchFinished                =  1 << 6,
    KPEPathSearchError                   =  1 << 7,
    KPEPathSearchBanCharacterSet         =  1 << 8,
    
    KPEPathIsSearchForCharacterSet       =
    KPEPathSearchForBaseNameCharacterSet   |
    KPEPathSearchForSelectorCharacterSet   |
    KPEPathSearchForIndexerCharacterSet    |
    KPEPathSearchForAnyCharacterSet        ,
    
}KPEPathSearchMatchFeature;


@interface KPEPathReadNode : NSObject

/**
 How do i deal with a received string.
 */
@property (nonatomic,assign) KPEPathSearchMatchFeature matchFeature;

@property (nonatomic,assign) KPEPathComponentType resultType;

@property (nonatomic,copy,nonnull) NSString* value;

- (BOOL)compareWithValue:(NSString* _Nonnull)value;

/**
 ... stop and to falseNode,check if is the finish symbol.
 */
@property (nonatomic,strong,nonnull) NSCharacterSet* banCharacterSet;

@property (nonatomic,strong,nonnull) KPEPathReadNode* falseNode;
@property (nonatomic,strong,nonnull) KPEPathReadNode* trueNode;

/**
 SuffixLenth indicates the length of the end of the path that needs to be intercepted.
 `.` or `->`
 */
@property (nonatomic,assign) NSUInteger suffixLenth;


- (nonnull NSString *)debugDescription;

+ (nonnull instancetype)nodeMatchValue:(nonnull NSString*)value;
+ (nonnull instancetype)nodeMatchAnyChar;
+ (nonnull instancetype)nodeMatchBaseName;
+ (nonnull instancetype)nodeMatchSelector;
+ (nonnull instancetype)nodeMatchIndexer;


- (KPEPathReadNode*_Nonnull(^_Nonnull)(KPEPathReadNode*_Nonnull falseNode))thatFalseNode;
- (KPEPathReadNode*_Nonnull(^_Nonnull)(KPEPathReadNode*_Nonnull trueNode))thatTrueNode;
- (KPEPathReadNode*_Nonnull(^_Nonnull)(NSString*_Nonnull banCharacters))thatBanCharacters;
- (KPEPathReadNode*_Nonnull)thatFinishable;
- (KPEPathReadNode*_Nonnull)thatFinished;
- (KPEPathReadNode*_Nonnull)thatFinishedStructPath;
- (KPEPathReadNode*_Nonnull(^_Nonnull)(KPEPathComponentType resultType))thatResultType;
- (KPEPathReadNode*_Nonnull)thatError;

- (KPEPathReadNode*_Nonnull)thatTrueNodeSelf;

- (KPEPathReadNode*_Nonnull(^_Nonnull)(KPEPathReadNode*_Nonnull forNode))asTrueNodeFor;
- (KPEPathReadNode*_Nonnull(^_Nonnull)(KPEPathReadNode*_Nonnull forNode))asFalseNodeFor;
@end

