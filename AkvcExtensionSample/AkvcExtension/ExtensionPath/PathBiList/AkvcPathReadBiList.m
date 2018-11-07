//
//  AkvcPathReadBiList.m
//  AkvcExtensionSample
//
//  Created by NOVO on 2018/10/22.
//  Copyright © 2018 NOVO. All rights reserved.
//

#import "AkvcPathReadBiList.h"
#import "AkvcPathReadNode.h"

@interface AkvcPathReadBiList()

@end

@implementation AkvcPathReadBiList


+ (AkvcPathReadBiList *)defaultList
{
    static AkvcPathReadBiList *_defaultList;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultList = [[AkvcPathReadBiList alloc] init];
    });
    //Create semaphore
    static dispatch_semaphore_t signalSemaphore;
    static dispatch_once_t onceTokenSemaphore;
    dispatch_once(&onceTokenSemaphore, ^{
        signalSemaphore = dispatch_semaphore_create(1);
    });
    //Wait semaphore
    dispatch_semaphore_wait(signalSemaphore, DISPATCH_TIME_FOREVER);
    //
    [_defaultList initWithDefaultList];
    //Signal semaphore
    dispatch_semaphore_signal(signalSemaphore);
    
    return _defaultList;
}

#define ANode AkvcPathReadNode

- (void)initWithDefaultList
{
    ///Error
    ANode* error = [[ANode alloc] init].thatError;
    
    /////////////////
    ///SEL-BEGGING///
    ANode* sel = [ANode nodeMatchValue:@"S"];
    _rootNode = sel;
    
    ANode* sel0 = [ANode nodeMatchValue:@"E"].asTrueNodeFor(sel);
    ANode* sel1 = [ANode nodeMatchValue:@"L"].asTrueNodeFor(sel0);
    ANode* sel2 = [ANode nodeMatchValue:@"("].asTrueNodeFor(sel1);
    ANode* selContent = [ANode nodeMatchSelector].asTrueNodeFor(sel2)
    .thatBanCharacters(@")")
    .thatTrueNodeSelf;
    ANode* sel3 = [ANode nodeMatchValue:@")"].asFalseNodeFor(selContent).thatFalseNode(error);
    ANode* sel4 = [ANode nodeMatchValue:@"?"].asTrueNodeFor(sel3).thatFalseNode(error)
    .thatFinishable.thatResultType(AkvcPathComponentSELInspector);
    [ANode nodeMatchValue:@"."].asTrueNodeFor(sel4).thatFalseNode(error)
    .thatFinished.thatResultType(AkvcPathComponentSELInspector);//Node at end
    /// SEL-END ///
    ///////////////
    
    ///////////////////
    ///Class-BEGGING///
    ANode* class = [ANode nodeMatchValue:@"C"]
    .asFalseNodeFor(sel).asFalseNodeFor(sel0).asFalseNodeFor(sel1).asFalseNodeFor(sel2);
    ANode* class0 = [ANode nodeMatchValue:@"l"].asTrueNodeFor(class);
    ANode* class1 = [ANode nodeMatchValue:@"a"].asTrueNodeFor(class0);
    ANode* class2 = [ANode nodeMatchValue:@"s"].asTrueNodeFor(class1);
    ANode* class3 = [ANode nodeMatchValue:@"s"].asTrueNodeFor(class2);
    ANode* class4 = [ANode nodeMatchValue:@"("].asTrueNodeFor(class3);
    ANode* classContent = [ANode nodeMatchBaseName].asTrueNodeFor(class4).thatBanCharacters(@")").thatTrueNodeSelf;
    ANode* class5 = [ANode nodeMatchValue:@")"].asFalseNodeFor(classContent).thatFalseNode(error);
    ANode* class6 = [ANode nodeMatchValue:@"?"].asTrueNodeFor(class5).thatFalseNode(error)
    .thatFinishable.thatResultType(AkvcPathComponentClassInspector);
    [ANode nodeMatchValue:@"."].asTrueNodeFor(class6).thatFalseNode(error)
    .thatFinished.thatResultType(AkvcPathComponentClassInspector);//Node at end
    ///Class-END///
    ///////////////
    
    //////////////////////
    ///FullPath-BEGGING///
    ANode* fullPath = [ANode nodeMatchBaseName].thatBanCharacters(@"@<{")
    .asFalseNodeFor(class).asFalseNodeFor(class0).asFalseNodeFor(class1)
    .asFalseNodeFor(class2).asFalseNodeFor(class3).asFalseNodeFor(class4);
    {
        ANode* fullPathContent = [ANode nodeMatchBaseName].asTrueNodeFor(fullPath).thatTrueNodeSelf
        .thatBanCharacters(@".-")
        .thatFinishable.thatResultType(AkvcPathComponentNSKey);
        ///Key path : keyPath.
        ANode* keyPathEnd = [ANode nodeMatchValue:@"."].asFalseNodeFor(fullPathContent)
        .thatFinished.thatResultType(AkvcPathComponentNSKey);
        ///Struct path : (NSKey->)(StructPath->)(StructPath->)...NSKey
        ANode* structPath0 = [ANode nodeMatchValue:@"-"].thatFalseNode(error).asFalseNodeFor(keyPathEnd);
        [ANode nodeMatchValue:@">"].thatFalseNode(error).asTrueNodeFor(structPath0)
        .thatFinishedStructPath.thatResultType(AkvcPathComponentStructKeyPath);
//        [ANode nodeMatchBaseName].asTrueNodeFor(structPathEnd).thatFalseNode(structPath0)
//        .thatTrueNodeSelf.thatBanCharacters(@"-")
//        .thatFinishable.thatResultType(AkvcPathComponentStructKeyPath);//Node at end
    }
    ///FullPath-END///
    //////////////////
    
    /////////
    /// @ ///
    ANode* at = [ANode nodeMatchValue:@"@"].asFalseNodeFor(fullPath);
    {
        ///Function
        ANode* function = [ANode nodeMatchBaseName].asTrueNodeFor(at)
        .thatBanCharacters(@"[:")
        .thatFinishable.thatResultType(AkvcPathComponentIsFunction);
        ANode* functionContent = [ANode nodeMatchBaseName].thatTrueNodeSelf.asTrueNodeFor(function)
        .thatBanCharacters(@".")
        .thatFinishable.thatResultType(AkvcPathComponentIsFunction);
        [ANode nodeMatchValue:@"."].asFalseNodeFor(functionContent)
        .thatFinished.thatResultType(AkvcPathComponentIsFunction);//Node at end
        
        ///Indexer
        ANode* indexer0 = [ANode nodeMatchValue:@"["].asFalseNodeFor(function);
        ANode* indexerContent = [ANode nodeMatchNumber].thatTrueNodeSelf.asTrueNodeFor(indexer0)
        .thatBanCharacters(@"]");
        ANode* indexer1 = [ANode nodeMatchValue:@"]"].asFalseNodeFor(indexerContent).thatFalseNode(error)
        .thatFinishable.thatResultType(AkvcPathComponentIndexer);
        [ANode nodeMatchValue:@"."].asTrueNodeFor(indexer1)
        .thatFinished.thatResultType(AkvcPathComponentIndexer);//Node at end
        
        ///Predicate
        ANode* predicate0 = [ANode nodeMatchValue:@":"].thatFalseNode(error).asFalseNodeFor(indexer0);
        ANode* predicateContent = [ANode nodeMatchAnyChar]
        .thatBanCharacters(@"!?")
        .asTrueNodeFor(predicate0).thatTrueNodeSelf;
        
        ANode* predicateFilter = [ANode nodeMatchValue:@"!"].asFalseNodeFor(predicateContent)
        .thatFinishable.thatResultType(AkvcPathComponentPredicateFilter);
        [ANode nodeMatchValue:@"."].asTrueNodeFor(predicateFilter)
        .thatFalseNode(predicateContent)
        .thatFinished.thatResultType(AkvcPathComponentPredicateFilter);//Node at end
        
        ANode* predicateEvaluate = [ANode nodeMatchValue:@"?"].asFalseNodeFor(predicateFilter)
        .thatFinishable.thatResultType(AkvcPathComponentPredicateEvaluate);;
        [ANode nodeMatchValue:@"."].asTrueNodeFor(predicateEvaluate)
        .thatFalseNode(predicateContent)
        .thatFinished.thatResultType(AkvcPathComponentPredicateEvaluate);//Node at end
    }
    /// @ //
    ////////
    
    /////////
    /// < ///
    ANode* matchKey = [ANode nodeMatchValue:@"<"].asFalseNodeFor(at);
    {
        
        ANode* regkey = [ANode nodeMatchValue:@"$"].asTrueNodeFor(matchKey);
        ANode* regkeyContent = [ANode nodeMatchAnyChar].asTrueNodeFor(regkey)
        .thatBanCharacters(@"$").thatTrueNodeSelf;
        ANode* regkey2 = [ANode nodeMatchValue:@"$"].asFalseNodeFor(regkeyContent);
        ANode* regkey3 = [ANode nodeMatchValue:@">"].asTrueNodeFor(regkey2).thatFalseNode(regkeyContent)
        .thatFinishable.thatResultType(AkvcPathComponentRegkey);
        [ANode nodeMatchValue:@"."].asTrueNodeFor(regkey3).thatFalseNode(regkeyContent)
        .thatFinished.thatResultType(AkvcPathComponentRegkey);//Node at end
        
        
        ANode* subKeyContent = [ANode nodeMatchBaseName].thatBanCharacters(@">")
        .asFalseNodeFor(regkey).thatTrueNodeSelf;
        ANode* subKeyEndable = [ANode nodeMatchValue:@">"].asFalseNodeFor(subKeyContent).thatFalseNode(error)
        .thatFinishable.thatResultType(AkvcPathComponentSubkey);
        [ANode nodeMatchValue:@"."].asTrueNodeFor(subKeyEndable).thatFalseNode(error)
        .thatFinished.thatResultType(AkvcPathComponentSubkey);//Node at end
    }
    /// < ///
    /////////
    
    
    /////////
    /// { ///
    ANode* keys = [ANode nodeMatchValue:@"{"].asFalseNodeFor(matchKey).thatFalseNode(error);
    {
        ANode* keysContent = [ANode nodeMatchAnyChar].asTrueNodeFor(keys)
        .thatBanCharacters(@"}").thatTrueNodeSelf;
        
        ANode* keys2 = [ANode nodeMatchValue:@"}"].asFalseNodeFor(keysContent)
        .thatFinishable.thatResultType(AkvcPathComponentKeys);
        
        [ANode nodeMatchValue:@"."].asTrueNodeFor(keys2).thatFalseNode(keysContent)
        .thatFinished.thatResultType(AkvcPathComponentKeys);
    }
    /// { ///
    /////////
}
@end
