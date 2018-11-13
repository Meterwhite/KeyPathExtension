//
//  AkvcPathComponent.h
//  AkvcExtensionSample
//
//  Created by NOVO on 2018/10/21.
//  Copyright © 2018 NOVO. All rights reserved.
//  https://github.com/qddnovo/AkvcExtension
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
    
    /**  one key  */
    AkvcPathComponentIsKey              =
    AkvcPathComponentNSKey              |
    AkvcPathComponentSubkey             |
    AkvcPathComponentRegkey             ,
    
    
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
    
    AkvcPathComponentIsPredicate        =
    AkvcPathComponentPredicateEvaluate  |
    AkvcPathComponentPredicateFilter    ,
    
    /** @PathFunction */
    AkvcPathComponentPathFunction       =   1   <<  8,
    
    /** \@Function */
    AkvcPathComponentIsFunction         =
    AkvcPathComponentNSKeyValueOperator |
    AkvcPathComponentPathFunction     ,
    
    /** @SEL(~)? */
    AkvcPathComponentSELInspector       =   1   <<  9,
    /** \@Class(~)? */
    AkvcPathComponentClassInspector     =   1   <<  10,
    /** @[Number] */
    AkvcPathComponentIndexer            =   1   <<  11,
    /** {Key,KeyPath,Indexer} */
    AkvcPathComponentKeysAccessor       =   1   <<  12,
    
    /** unrecognized content */
    AkvcPathComponentError              =   1   <<  13,
    
}AkvcPathComponentType;


@interface AkvcPathComponent : NSObject

@property (nonatomic,assign)    AkvcPathComponentType   componentType;

@property (nonatomic,copy)      NSString*               stringValue;

/**
 SuffixLenth indicates the length of the end of the path that needs to be intercepted.
 `.` or `->`
 */
@property (nonatomic,assign)    NSUInteger              suffixLength;

- (instancetype)copy;


#pragma mark - Predicate component
@property (nonatomic,copy,readonly)      NSString*   predicateString;
@property (nonatomic,assign,readonly)    NSUInteger  predicateArgumentCount;



#pragma mark - keypath component
@property (nonatomic,assign,readonly)    BOOL        isKeyPath;


#pragma mark - Indexser component
- (id _Nonnull)indexerSubarray:(__kindof NSArray* _Nonnull)array;
- (void)indexerSetValue:(id _Nonnull)value forMutableArray:(NSMutableArray* _Nonnull)mArray;

#pragma mark - Subkey component
@property (nonatomic,copy,readonly)      NSString*   subkey;

#pragma mark - Regkey component
@property (nonatomic,copy,readonly)      NSString*   regkey;


#pragma mark - Path function component
- (id _Nullable)callFunctionByTarget:(id _Nullable)target;


#pragma mark - Keys component
- (id _Nullable)callKeysAccessorByTarget:(id _Nullable)target;
@end


