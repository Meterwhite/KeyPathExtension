//
//  KPEPathComponent.h
//  KeyPathExtensionSample
//
//  Created by NOVO on 2018/10/21.
//  Copyright © 2018 NOVO. All rights reserved.
//  https://github.com/qddnovo/KeyPathExtension
//

#import <Foundation/Foundation.h>
#import "KPEPathComponent.h"

typedef enum KPEPathComponentType{
    /**  Empty component or key  */
    KPEPathComponentNon                =   0   <<  0,
    
    /**  normal key  */
    KPEPathComponentNSKey              =   1   <<  0,
    /**  <subKey>  */
    KPEPathComponentSubkey             =   1   <<  1,
    /**  <$regkey$>  */
    KPEPathComponentRegkey             =   1   <<  2,
    
    /**  one key  */
    KPEPathComponentIsKey              =
    KPEPathComponentNSKey              |
    KPEPathComponentSubkey             |
    KPEPathComponentRegkey             ,
    
    
    /** @avg,@count */
    KPEPathComponentNSKeyValueOperator =   1   <<  3,
    
    
    /** normal keyPath */
    KPEPathComponentNSKeyPath          =   1   <<  4,
    
    
    /** struct->value */
    KPEPathComponentStructKeyPath      =   1   <<  5,
    
    
    
    /** @:Predicate? */
    KPEPathComponentPredicateEvaluate  =   1   <<  6,
    /** @:Predicate! */
    KPEPathComponentPredicateFilter    =   1   <<  7,
    
    KPEPathComponentIsPredicate        =
    KPEPathComponentPredicateEvaluate  |
    KPEPathComponentPredicateFilter    ,
    
    /** @PathFunction */
    KPEPathComponentPathFunction       =   1   <<  8,
    
    /** \@Function */
    KPEPathComponentIsFunction         =
    KPEPathComponentNSKeyValueOperator |
    KPEPathComponentPathFunction     ,
    
    /** @SEL(~)? */
    KPEPathComponentSELInspector       =   1   <<  9,
    /** \@Class(~)? */
    KPEPathComponentClassInspector     =   1   <<  10,
    /** @[Number] */
    KPEPathComponentIndexer            =   1   <<  11,
    /** {Key,KeyPath,Indexer} */
    KPEPathComponentKeysAccessor       =   1   <<  12,
    
    /** unrecognized content */
    KPEPathComponentError              =   1   <<  13,
    
}KPEPathComponentType;


@interface KPEPathComponent : NSObject

@property (nonatomic,assign)    KPEPathComponentType   componentType;

@property (nonatomic,copy,nonnull)NSString*             stringValue;

/**
 SuffixLenth indicates the length of the end of the path that needs to be intercepted.
 `.` or `->`
 */
@property (nonatomic,assign)    NSUInteger              suffixLength;

- (nullable instancetype)copy;


#pragma mark - Predicate component
@property (nonatomic,copy,readonly,nullable)      NSString*   predicateString;
@property (nonatomic,assign,readonly)    NSUInteger  predicateArgumentCount;



#pragma mark - keypath component
@property (nonatomic,assign,readonly)    BOOL        isKeyPath;


#pragma mark - Indexser component
- (id _Nonnull)indexerSubarray:(__kindof NSArray* _Nonnull)array;
- (void)indexerSetValue:(id _Nonnull)value forMutableArray:(NSMutableArray* _Nonnull)mArray;

#pragma mark - Subkey component
@property (nonatomic,copy,readonly,nullable)      NSString*   subkey;

#pragma mark - Regkey component
@property (nonatomic,copy,readonly,nullable)      NSString*   regkey;


#pragma mark - Path function component
- (id _Nullable)callPathFunctionByTarget:(id _Nullable)target;


#pragma mark - Keys component
- (id _Nullable)callKeysAccessorByTarget:(id _Nullable)target;

#pragma mark - ClassInspector
- (BOOL)callClassInspectorByTarget:(id _Nullable)target;

#pragma mark - SELInspector
- (BOOL)callSELInspectorByTarget:(id _Nullable)target;
@end


