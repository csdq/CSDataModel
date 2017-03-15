//
//  NSObject+CSPropertyValueSetter.m
//  CSDataModel
//
//  Created by mr.s on 2017/1/18.
//  Copyright © 2017年 CSDQ. All rights reserved.
//

#import "NSObject+CSPropertyValueSetter.h"
#import <objc/runtime.h>

@implementation NSObject (CSPropertyValueSetter)
- (void)setObjProperty:(NSDictionary *)dict{
    if(nil == dict || ![dict isKindOfClass:[NSDictionary class]]){
        return;
    }
    unsigned int count = 0;
    Ivar *list = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithCString:ivar_getName(list[i]) encoding:NSUTF8StringEncoding];
        if([key hasPrefix:@"_"]){
            key = [key substringFromIndex:1];
        }
        id objForKey = dict[key];
        if(objForKey == nil || [objForKey isKindOfClass:[NSNull class]]){
            continue;
        }
        NSString *type = [NSString stringWithCString:ivar_getTypeEncoding(list[i]) encoding:NSUTF8StringEncoding];
        if([type hasPrefix:@"@"]){
            if([type containsString:@"NSNumber"] && [objForKey isKindOfClass:[NSString class]]){
                NSNumber *value1 = [NSNumber numberWithFloat:[objForKey floatValue]];
                object_setIvar(self, list[i], value1);
            }else{
                object_setIvar(self, list[i], objForKey);
            }
        }else{
            //FIXME:!!!没有考虑非对象的成员变量
        }
    }
}

- (id)valueForProperty:(NSString *)property{
    if(nil == property || [property length] == 0){
        return nil;
    }
    const char* name = [[@"_" stringByAppendingString:property] cStringUsingEncoding:NSUTF8StringEncoding];
    Ivar ivar = class_getInstanceVariable([self class], name);
    return object_getIvar(self, ivar);
}

@end
