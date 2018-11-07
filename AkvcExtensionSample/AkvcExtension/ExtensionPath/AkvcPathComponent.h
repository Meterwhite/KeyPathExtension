//
//  AkvcPathComponent.h
//  AkvcExtensionSample
//
//  Created by NOVO on 2018/10/21.
//  Copyright © 2018 NOVO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AkvcPathComponent.h"

typedef enum AkvcPathComponentType{
    /**  Empty component or key  */
    AkvcPathComponentNon                =   0   <<  0,
    
    /**  normal key  */
    AkvcPathComponentNSKey              =   1   <<  0,
    /**  <subKey>  */
    AkvcPathComponentSubkey             =   1   <<  1,
    /**  <$regkey$>  */
    AkvcPathComponentRegkey             =   1   <<  2,
    /**  any key  */
    AkvcPathComponentIsKey              =   AkvcPathComponentNSKey
                                            |AkvcPathComponentSubkey
                                            |AkvcPathComponentRegkey,
    
    
    /** @avg,@count */
    AkvcPathComponentNSKeyValueOperator =   1   <<  3,
    
    
    /** normal keyPath */
    AkvcPathComponentNSKeyPath          =   1   <<  4,
    
    
    /** struct->value */
    AkvcPathComponentStructKeyPath      =   1   <<  5,
    
    
    
    /** @:Predicate? */
    AkvcPathComponentPredicateEvaluate  =   1   <<  6,
    /** @:Predicate! */
    AkvcPathComponentPredicateFilter    =   1   <<  7,
    AkvcPathComponentIsPredicate        =   AkvcPathComponentPredicateEvaluate
                                            |AkvcPathComponentPredicateFilter,
    
    /** @CustomFunc */
    AkvcPathComponentCustomFunction     =   1   <<  8,
    
    /** \@Function */
    AkvcPathComponentIsFunction         =   AkvcPathComponentNSKeyValueOperator
                                            |AkvcPathComponentCustomFunction,
    
    /** @SEL(~)? */
    AkvcPathComponentSELInspector       =   1   <<  9,
    /** \@Class(~)? */
    AkvcPathComponentClassInspector     =   1   <<  10,
    /** @[Number] */
    AkvcPathComponentIndexer            =   1   <<  11,
    /** {Key,KeyPath,Indexer} */
    AkvcPathComponentKeys               =   1   <<  12,
    
    /** unrecognized content */
    AkvcPathComponentError              =   1   <<  13,
    
}AkvcPathComponentType;


@interface AkvcPathComponent : NSObject
#pragma mark - Component properties
@property (nonatomic,assign)    AkvcPathComponentType   componentType;
@property (nonatomic,copy)      NSString*               stringValue;
@property (nonatomic,assign)    NSUInteger              suffixLength;

- (instancetype)copy;







#pragma mark - Predicate component
@property (nonatomic,copy)      NSString*   predicateString;
@property (nonatomic,assign)    NSUInteger  predicateArgumentCount;



#pragma mark - keypath component
@property (nonatomic,assign)    BOOL        isKeyPath;


#pragma mark - Indexser component
/**
 NSNotFound means not contains index.
 */
@property (nonatomic,assign)    NSInteger   indexForindexer;


#pragma mark - Custom function component
- (id _Nullable)callFunctionByTarget:(id _Nullable)target;


#pragma mark - Keys component
- (id _Nullable)callKeysByTarget:(id _Nullable)target;
@end


