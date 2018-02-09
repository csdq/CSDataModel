//
//  Department.h
//  TestApp
//
//  Created by shitingquan on 2017/4/18.
//  Copyright © 2017年 CSDQ. All rights reserved.
//

#import <CSDataModel/CSDataModel.h>
#import "AttributeInfo.h"
@class Employee;
@interface Department : CSBaseModel
CS_PROPERTY_STRING(name)
CS_PROPERTY_NUMBER(count)
CS_PROPERTY_ARRAY_WITH_ITEMTYPE(subs, Department)
CS_PROPERTY_ARRAY_WITH_ITEMTYPE(members, Employee)
CS_PROPERTY_CUSTOM_TYPE(attri, AttributeInfo)
CS_PROPERTY_STRING(desc)
@end
