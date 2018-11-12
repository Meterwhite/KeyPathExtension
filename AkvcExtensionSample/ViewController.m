//
//  ViewController.m
//  AkvcExtensionSample
//
//  Created by NOVO on 2018/10/21.
//  Copyright © 2018 NOVO. All rights reserved.
//

#import "AkvcExtensionPath.h"
#import "AkvcPathComponent.h"
#import "ViewController.h"
#import "AkvcExtension.h"
#import "AkvcClass.h"
#import "Person.h"
#import "Food.h"
#import "Dog.h"

@interface ViewController ()
@property (nonatomic,strong) id warning;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    Person* jack = [Person new];
    
    Person* alice = [Person new];
    {
        alice.name      = @"alice";
        alice.nickName  = @"PP";
        alice.frame     = CGRectMake(40, 50, 60, 70);
        alice.age       = 2008;
        alice.spouse    = jack;
        alice.firends = [NSMutableArray arrayWithObject:jack];
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
        jack.firends = [NSMutableArray arrayWithObject:alice];
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
    
    
//    id test0 = [jack akvc_valueForExtensionPath:@"dogs.@[0].{age,number}.@:SELF[SIZE]==2?"];
//
//    id test1 = [jack akvc_valueForExtensionPathWithFormat:@"dogs.@[%d].frame->size->width",0];
//
//    id test2 = [alice akvc_valueForExtensionPath:@"dogs.@:food != nil!"];
//
//    id test3 = [jack akvc_valueForExtensionPath:AkvcPath(@"dogs.@[%d].frame->size->width", 0)];
//
//    id test4 = [jack akvc_valueForExtensionPath:@"dogs.<name>"];
    
//    id test5 = [alice akvc_valueForExtensionPath:@"dogs.@[1].<$food\\d+$>"];
    
//    [alice akvc_setValue:@(1000) forExtensionPathWithPredicateFormat:@"dogs.@[0].frame->size->width",nil];
    
    id testDictionaryObject  = @{
                                 @"Interest1":@"Eat",
                                 @"Interest2":@"Spleep",
                                 @"Interest3":@"Sexual",
                                 @"location":[NSValue valueWithCGRect:CGRectMake(10, 20, 30, 40)],
                                 }.mutableCopy;
    
//    id xx = [testDictionaryObject akvc_valueForFullPath:@"location->size->width"];
    
//    [testDictionaryObject akvc_setValue:@(1024) forFullPath:@"location->size->width"];
//    [testDictionaryObject akvc_setValue:nil forExtensionPath:@"<$Interest\\d+$>"];
    
//    [test0 copy];
//    [test1 copy];
//    [test2 copy];
//    [test3 copy];
//    [test4 copy];
//    [test5 copy];
    
//    id arr = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"].mutableCopy;
//
//    AkvcPathComponent* cmp = [AkvcPathComponent new];
//    // % >= 2 , % <= 5 , !3
//    cmp.stringValue = @"@[10]";
//    id rte = [cmp indexerSubarray:arr];
//
//    [cmp indexerSetValue:@"X" forMutableArray:arr];
//    NSLog(@"%@",jack);
//
//    NSPredicate* pred;
//    int index = 0;
//    id anyObject;
//    [self akvc_valueForExtensionPathWithPredicateFormat:AkvcPath(@"...@[%d]...@:SELF != %@", index), anyObject, nil];
    
//    id xxx = AkvcPath(@"...@[%d]...@:SELF != %@",50);
    
    NSLog(@"End");
}


@end
