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
@property (nonatomic,weak) id dog;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    Person* alice = [Person new];
    Dog* dog = [Dog new];
    self.dog = dog;
    dog.name = @"SB";
    alice.dogs = [NSMutableArray arrayWithObjects:dog,nil];
    
    
    __weak id xx = [alice akvc_valueForExtensionPath:@"dogs.@retainCount"];
    
    NSLog(@"retainCount = %@", [xx valueForKey:@"retainCount"]);
    NSLog(@"END");
}


@end
