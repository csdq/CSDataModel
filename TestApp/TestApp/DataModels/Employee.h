//
//  Employee.h
//  TestApp
//
//  Created by shitingquan on 2017/4/18.
//  Copyright © 2017年 CSDQ. All rights reserved.
//

#import <CSDataModel/CSDataModel.h>

@interface Employee : CSBaseModel
CS_PROPERTY_STRING(name)
CS_PROPERTY_STRING(jobNum)
@end
