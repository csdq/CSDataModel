//
//  Department.m
//  TestApp
//
//  Created by mr.s on 2017/4/18.
//  Copyright © 2017年 CSDQ. All rights reserved.
//

#import "Department.h"
#import "Employee.h"
@implementation Department
- (instancetype)init
{
    self = [super init];
    if (self) {
        //注册子模型类型 模型类与属性字符串对应
        [self registerClass:[Employee class] forProperty:@"members"];
        [self registerClass:[Department class] forProperty:@"subs"];
        [self registerClass:[AttributeInfo class] forProperty:@"attri"];
    }
    return self;
}
@end
