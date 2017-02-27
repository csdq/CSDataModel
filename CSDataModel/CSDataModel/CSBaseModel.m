//
//  CSDataModel.h
//  CSDataModel
//
//  Created by stq on 2015/7/20.
//  Copyright © 2015年 CSDQ. All rights reserved.
//
#import "CSBaseModel.h"
#import <objc/runtime.h>
@interface CSBaseModel()<NSCopying>

@end

@implementation CSBaseModel
@synthesize subModelDict = _subModelDict;
//MARK:属性
PROPERTY_INIT(NSMutableDictionary, subModelDict)
//MARK:主方法
+ (instancetype)modelFromDict:(NSDictionary *)dict{
    CSBaseModel* obj = [self new];
    [obj setModelDataFromDictUseDictKey:dict];
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
//MARK:子类重载方法
- (void)didSetPropertyValue{
    //自定义的属性设置 子类继承实现
}
- (void)customSetProperty:(NSDictionary *)dict{
    //自定义的属性设置 子类继承实现
}
//MARK:字典数据填充到模型
- (void)setModelDataFromDictUseDictKey:(NSDictionary *)dict{
    if(dict == nil){
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
        //        NSString *uppercaseKey = [key uppercaseString];
        //        NSString *lowercaseKey = [key lowercaseString];
        //        if(objForKey == nil){
        //            objForKey = dict[uppercaseKey]==nil?dict[lowercaseKey]:dict[uppercaseKey];
        //        }
        if(objForKey == nil
           || [objForKey isKindOfClass:[NSNull class]]){
            continue;
        }
        NSString *customType = self.subModelDict[key];
        //        if(customType == nil){
        //            customType = self.subModelDict[uppercaseKey]==nil?self.subModelDict[lowercaseKey]:self.subModelDict[uppercaseKey];
        //        }
        if(nil != customType){
            Class cls = NSClassFromString(customType);
            NSAssert([cls isSubclassOfClass:[CSBaseModel class]], @"Not Kind Of CSBaseModel");
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
            //            字典
            continue;
        }
        
        NSString *type = [NSString stringWithCString:ivar_getTypeEncoding(list[i])
                                            encoding:NSUTF8StringEncoding];
        
        if([type hasPrefix:@"@"]){
            object_setIvar(self, list[i], objForKey);
        }else{
            //FIXME:!!!没有考虑非对象的成员变量
        }
    }
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
    return obj;
}
//MARK:
- (NSDictionary *)modelToDict{
    //filte weak property
    NSMutableArray *weakProArray = [NSMutableArray array];
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    for (int propertyIndex = 0; propertyIndex < propertyCount; propertyIndex++) {
        objc_property_t property = properties[propertyIndex];
        const char *rawName = property_getName(property);
        NSString *propertyName = [NSString stringWithCString:rawName encoding:[NSString defaultCStringEncoding]];
        char const *attributes = property_getAttributes(property);
        NSString *attributesString = [NSString stringWithCString:attributes encoding:[NSString defaultCStringEncoding]];
        NSArray *attributesArray = [attributesString componentsSeparatedByString:@","];
        BOOL weak = [attributesArray containsObject:@"W"];
        if(weak){
            [weakProArray addObject:propertyName];
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
        if(![weakProArray containsObject:proName] && [type hasPrefix:@"@"]){
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
                //                    else{
                //                    if([type containsString:@"NSArray"]||[type containsString:@"NSMutableArray"]){
                //                        [dict setObject:@[] forKey:proName];
                //                    }else if([type containsString:@"NSDictionary"]||[type containsString:@"NSMutableDictionary"]){
                //                        [dict setObject:@{} forKey:proName];
                //                    }else if([type containsString:@"NSNumber"]){
                //                        [dict setObject:@(0) forKey:proName];
                //                    }else if([type containsString:@"NSString"]||[type containsString:@"NSMutableString"]){
                //                        [dict setObject:@"" forKey:proName];
                //                    }
                //                }
            }
        }
    }
    return dict;
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

@end
