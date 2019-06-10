//
//  KeyPathExtensionSampleTests.m
//  KeyPathExtensionSampleTests
//
//  Created by NOVO on 2018/11/7.
//  Copyright © 2018 NOVO. All rights reserved.
//

#import "KPEExtensionPath.h"
#import "KPEPathComponent.h"
#import "KeyPathExtension.h"
#import <XCTest/XCTest.h>
#import "KPEClass.h"
#import "Person.h"
#import "Food.h"
#import "Dog.h"

@interface KeyPathExtensionSampleTests : XCTestCase
@property (nonatomic,strong) Person* jack;
@property (nonatomic,strong) Person* alice;
@property (nonatomic,strong) NSMutableDictionary* dictionary;
@property (nonatomic,strong) NSMutableArray* array;
@end

@implementation KeyPathExtensionSampleTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    Person* jack = [Person new];
    
    Person* alice = [Person new];
    {
        alice.name      = @"alice";
        alice.nickName  = @"PP";
        alice.frame     = CGRectMake(40, 50, 60, 70);
        alice.age       = 2008;
        alice.spouse    = jack;
        alice.friends = [NSMutableArray arrayWithObject:jack];
        {
            Dog* dog0 = [Dog new];
            dog0.nickName = @"Amy";
            dog0.age = 333;
            dog0.number = 222;
            dog0.master = alice;
            
            Dog* dog1 = [Dog new];
            dog1.nickName = @"Good";
            dog1.age = 666;
            dog1.number = 777;
            dog1.master = alice;
            Food* food = [Food new];
            food.foodName = @"Sausage";
            food.amount = 1;
            dog1.food  =  food;
            dog1.food0 = food;
            dog1.food1 = food;
            dog1.food2 = food;
            
            alice.dogs = [NSMutableArray arrayWithObjects:dog0,dog1,nil];
        }
    }
    
    [jack description];
    {
        jack.name       = @"jack";
        jack.nickName   = @"JJ";
        jack.frame      = CGRectMake(50, 50, 50, 50);
        jack.age        = 2018;
        jack.spouse     = alice;
        jack.friends = [NSMutableArray arrayWithObject:alice];
        {
            Dog* dog0 = [Dog new];
            dog0.nickName = @"Tom";
            dog0.age = 123;
            dog0.number = 321;
            dog0.master = jack;

            Dog* dog1 = [Dog new];
            dog1.nickName = @"Lee";
            dog1.age = 456;
            dog1.number = 654;
            dog1.master = jack;

            jack.dogs = [NSMutableArray arrayWithObjects:dog0,dog1,nil];
        }
    }
    
    id dictionary  = @{
                       @"Interest1":@"Eat",
                       @"Interest2":@"Spleep",
                       @"Interest3":@"Sexual",
                       @"location":[NSValue valueWithCGRect:CGRectMake(10, 20, 30, 40)],
                       }.mutableCopy;
    id array = @[jack , alice ];
    
    self.jack = jack;
    self.alice = alice;
    self.dictionary = dictionary;
    self.array = array;
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.

//    [self.alice kpe_valueForExtensionPath:@"dogs"];
    
    [self measureBlock:^{
        
        //no chache
        //0.001421, 0.000446, 0.000279, 0.000307, 0.000260, 0.000246, 0.000224, 0.000224, 0.000193, 0.000229
//        [self.alice kpe_valueForExtensionPath:@"dogs.@:name == 'Amy'!"];
        //cache
        //0.000094, 0.000030, 0.000021, 0.000018, 0.000017, 0.000017, 0.000017, 0.000016, 0.000016, 0.000015
    }];
}

@end
