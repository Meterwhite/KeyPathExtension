//
//  AkvcPathReadNode.m
//  AkvcExtensionSample
//
//  Created by NOVO on 2018/10/22.
//  Copyright © 2018 NOVO. All rights reserved.
//

#import "AkvcPathReadNode.h"

@implementation AkvcPathReadNode
- (instancetype)init
{
    self = [super init];
    if (self) {
        _matchFeature = 0;
    }
    return self;
}
- (instancetype)initWithValue:(NSString*)value
{
    self = [super init];
    if (self) {
        _matchFeature = AkvcPathSearchForMatchingValue;
        _value = value;
    }
    return self;
}
+ (instancetype)nodeMatchValue:(NSString*)value
{
    return [[self alloc] initWithValue:value];
}
+ (instancetype)nodeMatchAnyChar
{
    AkvcPathReadNode* _self = [[self alloc] init];
    _self->_matchFeature = AkvcPathSearchForAnyCharacterSet;
    return _self;
}
+ (instancetype)nodeMatchSelector
{
    AkvcPathReadNode* _self = [[self alloc] init];
    _self->_matchFeature = AkvcPathSearchForSelectorCharacterSet;
    return _self;
}
+ (instancetype)nodeMatchNumber
{
    AkvcPathReadNode* _self = [[self alloc] init];
    _self->_matchFeature = AkvcPathSearchForNumberCharacterSet;
    return _self;
}
+ (instancetype)nodeMatchBaseName
{
    AkvcPathReadNode* _self = [[self alloc] init];
    _self->_matchFeature = AkvcPathSearchForBaseNameCharacterSet;
    return _self;
}

- (AkvcPathReadNode*)thatFinished
{
    _matchFeature |= (AkvcPathSearchFinished|AkvcPathSearchFinishable);
    _suffixLenth = 1;
    return self;
}
- (AkvcPathReadNode *)thatFinishedStructPath
{
    _matchFeature |= (AkvcPathSearchFinished|AkvcPathSearchFinishable);
    _suffixLenth = 2;
    return self;
}
- (AkvcPathReadNode *)thatTrueNodeSelf
{
    _trueNode = self;
    return self;
}
- (AkvcPathReadNode *)thatFinishable
{
    _matchFeature |= AkvcPathSearchFinishable;
    _suffixLenth = 0;
    return self;
}
- (AkvcPathReadNode*)thatError
{
    _matchFeature |= (AkvcPathSearchFinished|AkvcPathSearchError);
    return self;
}
- (AkvcPathReadNode *(^)(AkvcPathReadNode *))thatFalseNode
{
    return ^(AkvcPathReadNode * node){
        self.falseNode = node;
        return self;
    };
}
- (AkvcPathReadNode *(^)(AkvcPathReadNode *))thatTrueNode
{
    return ^(AkvcPathReadNode * node){
        self.trueNode = node;
        return self;
    };
}
- (AkvcPathReadNode *(^)(NSString *))thatBanCharacters
{
    return ^(NSString *banCharacters){
        
        self.banCharacterSet = [NSCharacterSet characterSetWithCharactersInString:banCharacters];
        self.matchFeature |= AkvcPathSearchBanCharacterSet;
        return self;
    };
}

- (AkvcPathReadNode *(^)(AkvcPathReadNode *))asTrueNodeFor
{
    return ^(AkvcPathReadNode * node){
        node.trueNode = self;
        return self;
    };
}
- (AkvcPathReadNode *(^)(AkvcPathReadNode *))asFalseNodeFor
{
    return ^(AkvcPathReadNode * node){
        node.falseNode = self;
        return self;
    };
}

- (AkvcPathReadNode *(^)(AkvcPathComponentType))thatResultType
{
    return ^(AkvcPathComponentType resultType){
        self.resultType = resultType;
        return self;
    };
}

//- (AkvcPathReadNode*)nodeForIndexPath:(NSIndexPath*)indexPath
//{
//    AkvcPathReadNode* currentNode = self;
//    NSUInteger col = 0;
//    for (NSUInteger row=0; row<indexPath.length && currentNode; row++) {
//        
//        col = [indexPath indexAtPosition:row];
//
//        while (col-- && (currentNode = currentNode.falseNode))
//            ;
//
//        currentNode = currentNode.trueNode;//auto next row
//    }
//    return currentNode;
//}

- (BOOL)compareWithValue:(NSString * _Nonnull)value
{
    ///Single node
    if(_matchFeature & AkvcPathSearchForMatchingValue)
        return [value isEqualToString:_value];
    
    
    if(!(_matchFeature & AkvcPathIsSearchForCharacterSet))
        return NO;
    
    
    ///character set node
    unichar asUnchar = [value characterAtIndex:0];
    
    if((_matchFeature & AkvcPathSearchBanCharacterSet)
       &&
       [_banCharacterSet characterIsMember:asUnchar]){
        
        ///Is ban char
        return NO;
    }
    
    if((_matchFeature & AkvcPathSearchForNumberCharacterSet)
       &&
       (asUnchar < '0' || asUnchar > '9') ){
        return NO;
    }
    
    return YES;
}

- (NSString *)debugDescription
{
    ///'['(0x672252)={true:'null'(0x243532),false:'@'(0x243432)}
    return [NSString stringWithFormat:@"'%@'(%p)={true:'%@'(%p)+false:'%@'(%p)}"
            ,_value,self,
            self.trueNode.value,self.trueNode,
            self.falseNode.value,self.falseNode];
}
@end
