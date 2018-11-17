//
//  AkvcPathReadNode.h
//  AkvcExtensionSample
//
//  Created by NOVO on 2018/10/22.
//  Copyright © 2018 NOVO. All rights reserved.
//  https://github.com/qddnovo/AkvcExtension
//

#import <Foundation/Foundation.h>
#import "AkvcPathComponent.h"

typedef enum AkvcPathSearchMatchFeature{
    AkvcPathSearchForMatchingValue        =  1 << 0,
    AkvcPathSearchForBaseNameCharacterSet =  1 << 1,
    AkvcPathSearchForSelectorCharacterSet =  1 << 2,
    AkvcPathSearchForIndexerCharacterSet  =  1 << 3,
    AkvcPathSearchForAnyCharacterSet      =  1 << 4,
    AkvcPathSearchFinishable              =  1 << 5,
    AkvcPathSearchFinished                =  1 << 6,
    AkvcPathSearchError                   =  1 << 7,
    AkvcPathSearchBanCharacterSet         =  1 << 8,
    
    AkvcPathIsSearchForCharacterSet       =
    AkvcPathSearchForBaseNameCharacterSet   |
    AkvcPathSearchForSelectorCharacterSet   |
    AkvcPathSearchForIndexerCharacterSet    |
    AkvcPathSearchForAnyCharacterSet        ,
    
}AkvcPathSearchMatchFeature;


@interface AkvcPathReadNode : NSObject

/**
 How do i deal with a received string.
 */
@property (nonatomic,assign) AkvcPathSearchMatchFeature matchFeature;

@property (nonatomic,assign) AkvcPathComponentType resultType;

@property (nonatomic,copy) NSString* value;

- (BOOL)compareWithValue:(NSString* _Nonnull)value;

/**
 ... stop and to falseNode,check if is the finish symbol.
 */
@property (nonatomic,strong) NSCharacterSet* banCharacterSet;

@property (nonatomic,strong) AkvcPathReadNode* falseNode;
@property (nonatomic,strong) AkvcPathReadNode* trueNode;

/**
 SuffixLenth indicates the length of the end of the path that needs to be intercepted.
 `.` or `->`
 */
@property (nonatomic,assign) NSUInteger suffixLenth;


- (NSString *)debugDescription;

+ (instancetype)nodeMatchValue:(NSString*)value;
+ (instancetype)nodeMatchAnyChar;
+ (instancetype)nodeMatchBaseName;
+ (instancetype)nodeMatchSelector;
+ (instancetype)nodeMatchIndexer;


- (AkvcPathReadNode*(^)(AkvcPathReadNode* falseNode))thatFalseNode;
- (AkvcPathReadNode*(^)(AkvcPathReadNode* trueNode))thatTrueNode;
- (AkvcPathReadNode*(^)(NSString* banCharacters))thatBanCharacters;
- (AkvcPathReadNode*)thatFinishable;
- (AkvcPathReadNode*)thatFinished;
- (AkvcPathReadNode*)thatFinishedStructPath;
- (AkvcPathReadNode*(^)(AkvcPathComponentType resultType))thatResultType;
- (AkvcPathReadNode*)thatError;

- (AkvcPathReadNode*)thatTrueNodeSelf;

- (AkvcPathReadNode*(^)(AkvcPathReadNode* forNode))asTrueNodeFor;
- (AkvcPathReadNode*(^)(AkvcPathReadNode* forNode))asFalseNodeFor;
@end

