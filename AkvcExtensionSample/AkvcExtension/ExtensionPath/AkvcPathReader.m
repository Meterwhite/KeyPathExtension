//
//  AkvcPathReader.m
//  AKVCExtensionSample
//
//  Created by NOVO on 2018/10/21.
//  Copyright © 2018 NOVO. All rights reserved.
//

#import "AkvcPathReader.h"
#import "AkvcPathReadBiList.h"
#import "AkvcPathReadNode.h"
#import "AkvcPathComponent.h"

@interface AkvcPathReader ()

@property (nonatomic,strong) NSMutableArray<AkvcPathComponent*>* resultList;
@property (nonatomic,strong) AkvcPathReadNode* node;
@property (nonatomic,strong) NSMutableString* currentValue;

/** singleton */
@property (nonatomic,weak) AkvcPathReadBiList* defaultList;

@end

@implementation AkvcPathReader

+ (instancetype)defaultReder
{
    return [[AkvcPathReader alloc] init];
}


- (AkvcPathComponent*)readValueFast:(NSString*)value
{
    if(!value) return nil;
    
    ///Recorde string for current turn.
    [self.currentValue appendString:value];
    
    if(self.node == nil){
        
        self.node = self.defaultList.rootNode;
    }
    
    
    if([self.node compareWithValue:value] == YES){
        
        ///Finished,retuen
        if(self.node.matchFeature & AkvcPathSearchFinished){
            
            AkvcPathComponent* result = [[AkvcPathComponent alloc] init];
            result.stringValue = self.currentValue.copy;
            result.componentType = self.node.resultType;
            result.suffixLength = self.node.suffixLenth;
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
           (self.node.falseNode.matchFeature & AkvcPathSearchError)){
            
            AkvcPathComponent* result = [[AkvcPathComponent alloc] init];
            result.stringValue = self.currentValue.copy;
            result.componentType = AkvcPathComponentError;
            [self clean];
            return result;
        }
        
        ///Enumerate enable.
        self.node =  self.node.falseNode;
        if([self.node compareWithValue:value]){
            
            ///Finished,retuen
            if(self.node.matchFeature & AkvcPathSearchFinished){
                
                AkvcPathComponent* result = [[AkvcPathComponent alloc] init];
                result.stringValue = self.currentValue.copy;
                result.componentType = self.node.resultType;
                result.suffixLength = self.node.suffixLenth;
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

- (AkvcPathComponent *)endRead
{
    AkvcPathComponent* result = [[AkvcPathComponent alloc] init];
    
    result.stringValue = self.currentValue.copy;
    
    if(!(self.node.matchFeature & AkvcPathSearchFinishable)){
        
        result.componentType = AkvcPathComponentError;
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
    self.node = nil;
    self.currentValue = nil;
    [self.resultList removeAllObjects];
}

- (AkvcPathReadBiList *)defaultList
{
    if(!_defaultList){
        _defaultList = [AkvcPathReadBiList defaultList];
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

- (NSMutableArray<AkvcPathComponent *> *)resultList
{
    if(!_resultList){
        _resultList = [NSMutableArray new];
    }
    return _resultList;
}

@end

