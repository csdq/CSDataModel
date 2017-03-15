//
//  NSObject+CSPropertyValueSetter.h
//  CSDataModel
//
//  Created by mr.s on 2017/1/18.
//  Copyright © 2017年 CSDQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CSPropertyValueSetter)
/*
 * 扩展NSObject 简单地将dict内的数据根据key-value，填充到本对象的属性内。(字典的key与数据模型属性对应）
 * 对于模型嵌套未做处理
 *
 *  @param dict 原数据
 */
- (void)setObjProperty:(NSDictionary *)dict;
/*
 *  根据属性的字符串获取该属性的值
 */
- (id)valueForProperty:(NSString *)property;
@end
