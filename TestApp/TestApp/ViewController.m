//
//  ViewController.m
//  TestApp
//
//  Created by shitingquan on 2017/1/18.
//  Copyright © 2017年 CSDQ. All rights reserved.
//

#import "ViewController.h"
#import <CSDataModel/CSDataModel.h>

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
        [self.subModelDict setObject:@"Attribute" forKey:@"attr"];
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
        [self.subModelDict setObject:@"Department" forKey:@"sub"];
        [self.subModelDict setObject:@"Member" forKey:@"members"];
        [self.subModelDict setObject:@"Attribute" forKey:@"attr"];
    }
    return self;
}
@end





@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *departmentInfo = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"example" withExtension:@"json"]] options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"\ndepartmentInfo Dict:\n%@",departmentInfo);
    Department *department = [Department modelFromDict:departmentInfo];
    NSLog(@"\ndepartmentInfo Model:\n%@",department);
    
    NSLog(@"\nModel to Dict : \n%@",[department modelToDict]);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
