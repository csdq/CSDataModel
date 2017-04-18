//
//  ViewController.m
//  TestApp
//
//  Created by stq on 2017/1/18.
//  Copyright © 2017年 CSDQ. All rights reserved.
//

#import "ViewController.h"
#import <CSDataModel/CSDataModel.h>

//MARK: example1
/**********/
@interface Attribute : CSBaseModel
@property (nonatomic , strong) NSString *tel;
@property (nonatomic , strong) NSString *address;
@end
@implementation Attribute

@end
/**********/
@interface Member : CSBaseModel
@property (nonatomic , strong) NSString *name;
@property (nonatomic , strong) Attribute *attr;
@end
@implementation Member
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self registerClass:[Attribute class] forProperty:@"attr"];
    }
    return self;
}

@end
/**********/
@interface Department : CSBaseModel
@property (nonatomic , strong) NSString *name;
@property (nonatomic , strong) NSNumber* number;
@property (nonatomic , strong) NSArray<Department*> *sub;
@property (nonatomic , strong) Attribute *attr;
@property (nonatomic , strong) NSArray<Member*> *members;
@end

@implementation Department
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self registerClass:[Department class] forProperty:@"sub"];
        [self registerClass:[Member class] forProperty:@"members"];
        [self registerClass:[Attribute class] forProperty:@"attr"];
    }
    return self;
}
@end


//MARK: example2
/****************/
@interface ExampleObj : NSObject
@property (nonatomic , strong) NSString *name;
@property (nonatomic , strong) NSNumber *number;
@property (nonatomic , strong) NSDictionary *dict;
@end

@implementation ExampleObj


@end
/****************/
@interface ViewController ()
{
    Department *department;
    ExampleObj *obj;
}
@property (nonatomic , strong) NSArray *array;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *departmentInfo = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"example" withExtension:@"json"]] options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"\ndepartmentInfo Dict:\n%@",departmentInfo);
    department = [Department modelFromDict:departmentInfo];
    NSLog(@"\ndepartmentInfo Model:\n%@",department);
    NSLog(@"\nModel to Dict : \n%@",[department modelToDict]);
    //example 2
    NSDictionary *dict = @{@"name":@"12🐶",@"number":@(12),@"dict":@{@"key":@"value"}};
    obj = [[ExampleObj alloc] init];
    [obj setObjProperty:dict];

    if([[[department modelToDict] description] containsString:[departmentInfo description]]){
        NSLog(@"YES has same part");
    }

    NSLog(@"%@ %@ \n JSON:\n%@",obj, [obj valueForKey:@"name"],[department JSONString]);
    NSMutableArray *array = [NSMutableArray array];
    int i = 0;
    while (i < 99) {
        NSDictionary *departmentInfo = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"example" withExtension:@"json"]] options:NSJSONReadingAllowFragments error:nil];
        Department *d = [Department modelFromDict:departmentInfo];
        [array addObject:d];
        i = i + 1;
    }
    self.array = array;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
