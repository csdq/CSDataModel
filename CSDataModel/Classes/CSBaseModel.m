//
//  CSDataModel.h
//  CSDataModel
//
//  Created by stq on 2015/7/20.
//  Copyright © 2015年 mr.s. All rights reserved.
//
#import "CSBaseModel.h"
#import <objc/runtime.h>
#import "NSObject+CSJSON.h"
@interface CSBaseModel()<NSCopying>
@property (nonatomic , strong) NSMutableDictionary *subModelDict;
@end

@implementation CSBaseModel
//MARK:属性
CS_PROPERTY_INIT(NSMutableDictionary, subModelDict)

- (void)dealloc{
    [self.subModelDict removeAllObjects];
}
//MARK:主方法
+ (instancetype)modelFromDict:(NSDictionary *)dict{
    CSBaseModel* obj = [self new];
    [obj setPropertyWithDict:dict];
    [obj didSetPropertyValue];
    return obj;
}

+ (NSMutableArray *)modelsFromArray:(NSArray *)array{
    NSMutableArray *arrayTmp = [NSMutableArray arrayWithCapacity:array.count];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrayTmp addObject:[self modelFromDict:obj]];
    }];
    return arrayTmp;
}
//使用customSetProperty方法哪的对应关系解析
+ (instancetype)modelFromDictInCustom:(NSDictionary *)dict{
    id obj = [self new];
    [obj customSetProperty:dict];
    [obj didSetPropertyValue];
    return obj;
}

+ (NSMutableArray *)modelsFromArrayInCustom:(NSArray *)array{
    NSMutableArray *arrayTmp = [NSMutableArray arrayWithCapacity:array.count];
    [array enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrayTmp addObject:[self modelFromDictInCustom:obj]];
    }];
    return arrayTmp;
}

- (void)registerClass:(Class)cls forProperty:(NSString *)property{
    [self.subModelDict setObject:cls forKey:property];
}

//MARK:子类重载方法
- (void)didSetPropertyValue{
    //自定义的属性设置 子类继承实现
}

- (void)customSetProperty:(NSDictionary *)dict{
    //自定义的属性设置 子类继承实现
}

//MARK:字典数据填充到模型
- (void)setPropertyWithDict:(NSDictionary *)dict{
    if(nil == dict || ![dict isKindOfClass:[NSDictionary class]]){
        return;
    }
    unsigned int count = 0;
    Ivar *list = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithCString:ivar_getName(list[i])
                                           encoding:NSUTF8StringEncoding];
        if([key hasPrefix:@"_"]){
            key = [key substringFromIndex:1];
        }
        id objForKey = dict[key];
        if(objForKey == nil
           || [objForKey isKindOfClass:[NSNull class]]){
            continue;
        }
        Class cls = self.subModelDict[key];
        if(nil != cls){
#if DEBUG
            NSAssert([cls isSubclassOfClass:[CSBaseModel class]], @"Not Kind Of CSBaseModel");
#endif
            if(![cls isSubclassOfClass:[CSBaseModel class]]){
                object_setIvar(self, list[i], objForKey);
            }else{
                //            数组
                if([objForKey isKindOfClass:[NSArray class]]){
                    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[objForKey count]];
                    for (int j = 0; j < [objForKey count]; j++) {
                        [array addObject:[cls modelFromDict:objForKey[j]]];
                    }
                    if([objForKey isKindOfClass:[NSMutableArray class]]){
                        object_setIvar(self, list[i], array);
                    }else{
                        object_setIvar(self, list[i], [array copy]);
                    }
                }else if([objForKey isKindOfClass:[NSDictionary class]]){
                    object_setIvar(self, list[i], [cls modelFromDict:objForKey]);
                }
            }
            //            字典
            continue;
        }

        NSString *type = [NSString stringWithCString:ivar_getTypeEncoding(list[i])
                                            encoding:NSUTF8StringEncoding];
        //FIXME:20170313 实际 值和 属性类型不一致 主要针对 负数 如"-1.2" 解析成string的问题
        if([type hasPrefix:@"@"]){
            if([type containsString:@"NSNumber"] && [objForKey isKindOfClass:[NSString class]]){
                NSNumber *value1 = [NSNumber numberWithFloat:[objForKey floatValue]];
                object_setIvar(self, list[i], value1);
            }else  if([type containsString:@"String"] && [objForKey isKindOfClass:[NSNumber class]]){
                NSString *value1 = [objForKey stringValue];
                object_setIvar(self, list[i], value1);
            }else{
                object_setIvar(self, list[i], objForKey);
            }
        }else{
            //FIXME:!!!没有考虑非对象的成员变量
        }
    }
    free(list);
}
//MARK:Protocol实现
- (id)copyWithZone:(nullable NSZone *)zone{
    __typeof(self) obj = [[self class] new];
    unsigned int count = 0;
    Ivar *list = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++) {
        //FIXME:!!!没有考虑非对象的成员变量
        NSString *type = [NSString stringWithCString:ivar_getTypeEncoding(list[i])
                                            encoding:NSUTF8StringEncoding];
        if([type hasPrefix:@"@"]){
            object_setIvar(obj, list[i], object_getIvar(self, list[i]));
        }
    }
    free(list);
    return obj;
}
//MARK: 模型转化为字典类型
- (NSDictionary *)modelToDict{
    //filte weak property
    NSMutableSet *weakProSet = [NSMutableSet set];
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    for (int propertyIndex = 0; propertyIndex < propertyCount; propertyIndex++) {
        objc_property_t property = properties[propertyIndex];
        const char *rawName = property_getName(property);
        NSString *propertyName = [NSString stringWithCString:rawName encoding:[NSString defaultCStringEncoding]];
        char const *attributes = property_getAttributes(property);
        NSString *attributesString = [NSString stringWithCString:attributes encoding:[NSString defaultCStringEncoding]];
        NSArray *attributesArray = [attributesString componentsSeparatedByString:@","];
        if([attributesArray containsObject:@"W"]){
            [weakProSet setValue:@(YES) forKey:propertyName];
        }
    }

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    unsigned int count = 0;
    Ivar *list = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++) {
        NSString *proName = [NSString stringWithCString:ivar_getName(list[i])
                                               encoding:NSUTF8StringEncoding];
        if([proName hasPrefix:@"_"]){
            proName = [proName substringFromIndex:1];
        }
        NSString *type = [NSString stringWithCString:ivar_getTypeEncoding(list[i])
                                            encoding:NSUTF8StringEncoding];
        if(![weakProSet containsObject:proName] && [type hasPrefix:@"@"]){
            id value = object_getIvar(self, list[i]);
            if([value isKindOfClass:[NSArray class]]){
                NSArray *array = value;
                NSMutableArray *arr = [NSMutableArray arrayWithCapacity:[array count]];
                for (int i = 0; i < array.count; i++) {
                    Class cls = [array[i] class];
                    if([cls isSubclassOfClass:[CSBaseModel class]]){
                        [arr addObject:[(CSBaseModel *)array[i] modelToDict]];
                    }else{
                        [arr addObject:array[i]];
                    }
                }
                [dict setObject:arr forKey:proName];
            }else if([value isKindOfClass:[CSBaseModel class]]){
                [dict setObject:[(CSBaseModel *)value modelToDict]
                         forKey:proName];
            }else{
                if(value != nil){
                    [dict setObject:value forKey:proName];
                }
            }
        }
    }
    free(properties);
    free(list);
    return dict;
}

- (NSString *)JSONString{
    return [self cs_JSON];
}

- (NSString *)description{
    return [self getModelPropertyData];
}

- (NSString *)debugDescription{
    return [self getModelPropertyData];
}

- (NSString *)getModelPropertyData{
    return [NSString stringWithFormat:@"\n%@\n%@",[super description],[self modelToDict]];
}

- (id)cs_serializableObj{
    return [self modelToDict];
}

@end
