//
//  CSDataModel.h
//  CSDataModel
//
//  Created by stq on 2015/7/20.
//  Copyright © 2015年 CSDQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSBaseModel : NSObject
/**
 *  自动解析时：
 *  对于模型内含有子模型或者含有子模型数组等情况，将属性名称和模型类名以键值对形式存储
 *  该属性填充时间必须在数据格式转化之前，最好在子模型的init时处理
 *  例如：@{"key":"ModelClassName"}
 */
@property (nonatomic , strong ,readonly) NSMutableDictionary *subModelDict;

/**
 *  自动处理字典数据与模型之间的关系 生成数据模型实体对象
 *
 *  @param dict 字典
 *
 *  @return 模型数组
 */
+ (instancetype)modelFromDict:(NSDictionary *)dict;
/**
 *  自动解析 生成数据模型数组
 *
 *  @param array 字典数组
 *
 *  @return 模型数组
 */
+ (NSMutableArray *)modelsFromArray:(NSArray *)array;
/**
 *  自动解析 根据字典生成模型（字典的key 对应 模型的属性名）
 *
 *  @param dict 原数据
 *
 *  @return 模型
 */
+ (instancetype)modelFromDictInCustom:(NSDictionary *)dict;
/**
 *  手动设置解析规则 字典数组转化为模型数组
 *
 *  @param array 字典数组
 *
 *  @return 模型数组
 */
+ (NSMutableArray *)modelsFromArrayInCustom:(NSArray *)array;

/**
 *  手动解析 实现处理字典中数据与模型属性之间的关系
 *
 *  @param dict 数据字典
 */
- (void)customSetProperty:(NSDictionary *)dict;


/**
 *  自动解析 根据字典生成模型（字典的key与数据模型属性对应）
 *
 *  @param dict 原数据
 */
- (void)setModelDataFromDictUseDictKey:(NSDictionary *)dict;
/**
 *  模型转换为字典
 *
 */
- (NSDictionary *)modelToDict;
/**
 *  所有属性值的拼接 原本设想是用于判断多个模型内容是否相等
 *
 *  @return 拼接后的字符串
 */
- (NSString *)propertyDescription;
/*
 * 属性设置完毕后自动调用方法
 *
 *
 */
- (void)didSetProperty;
@end