//
//  NSObject+CSPropertyValueSetter.h
//  CSDataModel
//
//  Created by shitingquan on 2017/1/18.
//  Copyright © 2017年 CSDQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CSPropertyValueSetter)
/*
 * 扩展NSObject 将dict内的数据根据key-value，填充到本对象的属性内。
 *
 */
- (void)setObjProperty:(NSDictionary *)dict;
@end
