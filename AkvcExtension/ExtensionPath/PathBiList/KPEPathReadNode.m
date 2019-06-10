//
//  KPEPathReadNode.m
//  KeyPathExtensionSample
//
//  Created by NOVO on 2018/10/22.
//  Copyright © 2018 NOVO. All rights reserved.
//  https://github.com/qddnovo/KeyPathExtension
//

#import "KPEPathReadNode.h"

@implementation KPEPathReadNode
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
        _matchFeature = KPEPathSearchForMatchingValue;
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
    KPEPathReadNode* _self = [[self alloc] init];
    _self->_matchFeature = KPEPathSearchForAnyCharacterSet;
    return _self;
}
+ (instancetype)nodeMatchSelector
{
    KPEPathReadNode* _self = [[self alloc] init];
    _self->_matchFeature = KPEPathSearchForSelectorCharacterSet;
    return _self;
}
+ (instancetype)nodeMatchIndexer
{
    KPEPathReadNode* _self = [[self alloc] init];
    _self->_matchFeature = KPEPathSearchForIndexerCharacterSet;
    return _self;
}
+ (instancetype)nodeMatchBaseName
{
    KPEPathReadNode* _self = [[self alloc] init];
    _self->_matchFeature = KPEPathSearchForBaseNameCharacterSet;
    return _self;
}

- (KPEPathReadNode*)thatFinished
{
    _matchFeature |= (KPEPathSearchFinished|KPEPathSearchFinishable);
    _suffixLenth = 1;
    return self;
}
- (KPEPathReadNode *)thatFinishedStructPath
{
    _matchFeature |= (KPEPathSearchFinished|KPEPathSearchFinishable);
    _suffixLenth = 2;
    return self;
}
- (KPEPathReadNode *)thatTrueNodeSelf
{
    _trueNode = self;
    return self;
}
- (KPEPathReadNode *)thatFinishable
{
    _matchFeature |= KPEPathSearchFinishable;
    _suffixLenth = 0;
    return self;
}
- (KPEPathReadNode*)thatError
{
    _matchFeature |= (KPEPathSearchFinished|KPEPathSearchError);
    return self;
}
- (KPEPathReadNode *(^)(KPEPathReadNode *))thatFalseNode
{
    return ^(KPEPathReadNode * node){
        self.falseNode = node;
        return self;
    };
}
- (KPEPathReadNode *(^)(KPEPathReadNode *))thatTrueNode
{
    return ^(KPEPathReadNode * node){
        self.trueNode = node;
        return self;
    };
}
- (KPEPathReadNode *(^)(NSString *))thatBanCharacters
{
    return ^(NSString *banCharacters){
        
        self.banCharacterSet = [NSCharacterSet characterSetWithCharactersInString:banCharacters];
        self.matchFeature |= KPEPathSearchBanCharacterSet;
        return self;
    };
}

- (KPEPathReadNode *(^)(KPEPathReadNode *))asTrueNodeFor
{
    return ^(KPEPathReadNode * node){
        node.trueNode = self;
        return self;
    };
}
- (KPEPathReadNode *(^)(KPEPathReadNode *))asFalseNodeFor
{
    return ^(KPEPathReadNode * node){
        node.falseNode = self;
        return self;
    };
}

- (KPEPathReadNode *(^)(KPEPathComponentType))thatResultType
{
    return ^(KPEPathComponentType resultType){
        self.resultType = resultType;
        return self;
    };
}

//- (KPEPathReadNode*)nodeForIndexPath:(NSIndexPath*)indexPath
//{
//    KPEPathReadNode* currentNode = self;
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
    if(_matchFeature & KPEPathSearchForMatchingValue)
        return [value isEqualToString:_value];
    
    
    if(!(_matchFeature & KPEPathIsSearchForCharacterSet))
        return NO;
    
    
    ///character set node
    unichar asUnchar = [value characterAtIndex:0];
    
    if((_matchFeature & KPEPathSearchBanCharacterSet)
       &&
       [_banCharacterSet characterIsMember:asUnchar]){
        
        ///Is ban char
        return NO;
    }
    
    if(_matchFeature & KPEPathSearchForIndexerCharacterSet){
        
        if(asUnchar != '<'
           &&
           asUnchar != '>'
           &&
           asUnchar != '='
           &&
           asUnchar != '!'
           &&
           asUnchar != 'i'
           &&
           (asUnchar < '0' && asUnchar > '9')){
            
            return NO;
        }
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
