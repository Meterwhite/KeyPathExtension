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
    
    id dictionary  = @{
                       @"Interest1":@"Eat",
                       @"Interest2":@"Spleep",
                       @"Interest3":@"Sexual",
                       @"location":[NSValue valueWithCGRect:CGRectMake(10, 20, 30, 40)],
                       }.mutableCopy;
    id array = @[jack , alice , @"123"];
    
    id value;
//    value = [dictionary akvc_valueForExtensionPath:@"Class(NSDictionary)?"];
//    value = [dictionary akvc_valueForExtensionPath:@"SEL(copy)?"];
//    value = [jack akvc_valueForExtensionPath:@"dogs"];
//    value = [jack akvc_valueForExtensionPath:@"dogs.@[i<2]"];
//    value = [array akvc_valueForExtensionPath:@"@:name == 'jack'!"];
//    value = [array akvc_valueForExtensionPath:@"@:SELF[SIZE] == 3?"];
//    value = [dictionary akvc_valueForExtensionPath:@"location->size"];
//    value = [dictionary akvc_valueForExtensionPath:@"@nslog"];
//    value = [dictionary akvc_valueForExtensionPath:@"<Interest>.@nslog"];
//    value = [dictionary akvc_valueForExtensionPath:@"<$Interest\\d+$>.@nslog"];
//    value = [jack akvc_valueForExtensionPath:@"{dogs,name}.@nslog"];
    
    value = [array akvc_valueForExtensionPath:@"@isAllEqual"];
    value = [array akvc_valueForExtensionPath:@"@isAllDifferent"];
    
    NSLog(@"End");
}


@end
