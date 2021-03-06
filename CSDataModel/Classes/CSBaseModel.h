//
//  CSDataModel.h
//  CSDataModel
//  将字典、数组类型数据转化为数据模型 如果自动解析，要求就是字典的key需要与model的属性一致
//  Created by stq on 2015/7/20.
//  Copyright © 2015年 mr.s. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 * Property Define Marco
 */
#define CS_PROPERTY_STRING(name) @property (nonatomic , strong) NSString* name;
#define CS_PROPERTY_NUMBER(name) @property (nonatomic , strong) NSNumber* name;
#define CS_PROPERTY_ARRAY(name)  @property (nonatomic , strong) NSArray* name;
#define CS_PROPERTY_ARRAY_WITH_ITEMTYPE(arrayName,itemClass)  @property (nonatomic , strong) NSArray<itemClass *>* arrayName;
#define CS_PROPERTY_DICT(name)  @property (nonatomic , strong) NSDictionary* arrayName;

#define CS_PROPERTY_MUTABLE_STRING(name) @property (nonatomic , strong) NSMutableString* name;
#define CS_PROPERTY_MUTABLE_ARRAY(name) @property (nonatomic , strong) NSMutableArray* name;
#define CS_PROPERTY_MUTABLE_ARRAY_WITH_ITEMTYPE(arrayName,itemClass)  @property (nonatomic , strong) NSMutableArray<itemClass *>* arrayName;
#define CS_PROPERTY_MUTABLE_DICT(name)  @property (nonatomic , strong) NSDictionary* name;

#define CS_PROPERTY_CUSTOM_TYPE(name,class) @property (nonatomic , strong) class* name;
/* 
 * Property Lazy Init Marco
 */
#define CS_PROPERTY_INIT(class,name) - (class *)name{if(_##name == nil){_##name = [class new];}return _##name;}

@interface CSBaseModel : NSObject
/**
 *  注册子模型相对应的类
 *
 *  @param cls 类型
 *
 *  @param property 属性名称
 *
 */
- (void)registerClass:(Class)cls forProperty:(NSString *)property;
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
 *  手动解析 根据字典生成模型（字典的key 对应 模型的属性名）
 *  使用自己的规则解析
 *  @param dict 原数据
 *
 *  @return 模型
 */
+ (instancetype)modelFromDictInCustom:(NSDictionary *)dict;
/**
 *  手动设置解析规则 字典数组转化为模型数组
 *  使用customSetProperty:内定义的对应关系解析
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
- (void)setPropertyWithDict:(NSDictionary *)dict;
/**
 *  模型转换为字典
 */
- (NSDictionary *)modelToDict;
/*
 * 属性设置完毕后自动调用方法
 */
- (void)didSetPropertyValue;

- (NSString *)JSONString;
@end
