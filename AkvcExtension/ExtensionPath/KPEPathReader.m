//
//  KPEPathReader.m
//  KeyPathExtensionSample
//
//  Created by NOVO on 2018/10/21.
//  Copyright © 2018 NOVO. All rights reserved.
//  https://github.com/qddnovo/KeyPathExtension
//

#import "KPEPathReadBiList.h"
#import "KPEPathComponent.h"
#import "KPEPathReadNode.h"
#import "KPEPathReader.h"

@interface KPEPathReader ()

@property (nonatomic,strong) NSMutableArray<KPEPathComponent*>* resultList;
@property (nonatomic,strong) KPEPathReadNode* node;
@property (nonatomic,strong) NSMutableString* currentValue;

/** Singleton */
@property (nonatomic,weak) KPEPathReadBiList* defaultList;

@end

@implementation KPEPathReader

+ (instancetype)defaultReder
{
    return [[KPEPathReader alloc] init];
}


- (KPEPathComponent*)readValueFast:(NSString*)value
{
    if(!value) return nil;
    
    ///Recorde string for current turn.
    [self.currentValue appendString:value];
    
    if(self.node == nil){
        
        self.node = self.defaultList.rootNode;
    }
    
    
    if([self.node compareWithValue:value] == YES){
        
        ///Finished,retuen
        if(self.node.matchFeature & KPEPathSearchFinished){
            
            KPEPathComponent* result = [[KPEPathComponent alloc] init];
            result.stringValue      = self.currentValue.copy;
            result.componentType    = self.node.resultType;
            result.suffixLength     = self.node.suffixLenth;
            [self clean];
            return result;
        }
        
        ///Just move to next node and continue
        self.node = self.node.trueNode;
        
        return nil;//continue
    }
    
    
CALL_ENUMERATE_FALSE_NODE:
    {
        
        ///Move to next node untill matching or throw error object;
        ///Error node or no falseNode
        if(self.node.falseNode == nil
           ||
           (self.node.falseNode.matchFeature & KPEPathSearchError)){
            
            KPEPathComponent* result   = [[KPEPathComponent alloc] init];
            result.stringValue          = self.currentValue.copy;
            result.componentType        = KPEPathComponentError;
            [self clean];
            return result;
        }
        
        ///Enumerate enable.
        self.node =  self.node.falseNode;
        if([self.node compareWithValue:value]){
            
            ///Finished,retuen
            if(self.node.matchFeature & KPEPathSearchFinished){
                
                KPEPathComponent* result = [[KPEPathComponent alloc] init];
                result.stringValue      = self.currentValue.copy;
                result.componentType    = self.node.resultType;
                result.suffixLength     = self.node.suffixLenth;
                [self clean];
                return result;
            }
            
            ///find it and continue.
            self.node =  self.node.trueNode;
            return nil;
        }
    }
    goto CALL_ENUMERATE_FALSE_NODE;
}

- (KPEPathComponent *)endRead
{
    KPEPathComponent* result = [[KPEPathComponent alloc] init];
    
    result.stringValue = self.currentValue.copy;
    
    if(!(self.node.matchFeature & KPEPathSearchFinishable)){
        
        result.componentType = KPEPathComponentError;
    }else{
        
        result.componentType = self.node.resultType;
    }
    
    [self clean];
    
    return result;
}

/**
 Clean reader when one result finished if continue.
 */
- (void)clean
{
    self.node           = nil;
    self.currentValue   = nil;
    [self.resultList removeAllObjects];
}

- (KPEPathReadBiList *)defaultList
{
    if(!_defaultList){
        _defaultList = [KPEPathReadBiList defaultList];
    }
    return _defaultList;
}

- (NSMutableString *)currentValue
{
    if(!_currentValue){
        _currentValue = [NSMutableString new];
    }
    return _currentValue;
}

- (NSMutableArray<KPEPathComponent *> *)resultList
{
    if(!_resultList){
        _resultList = [NSMutableArray new];
    }
    return _resultList;
}

@end

