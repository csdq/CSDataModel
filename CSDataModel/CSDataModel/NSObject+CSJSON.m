//
//  NSObject+CSJSON.m
//  CSDataModel
//
//  Created by Mr.s on 2018/8/14.
//  Copyright © 2018年 CSDQ. All rights reserved.
//

#import "NSObject+CSJSON.h"
@implementation NSObject (CSJSON)
- (NSString *)cs_JSON{
    if([self respondsToSelector:@selector(cs_serializableObj)]){
        NSError *err;
        NSData *data = [NSJSONSerialization dataWithJSONObject:[self cs_serializableObj] options:NSJSONWritingPrettyPrinted error:&err];
        if(err){
            
        }
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }else{
        return @"";
    }
}

- (id)cs_serializableObj{
    if([self isKindOfClass:[NSArray class]]){
        NSMutableArray *arry = [NSMutableArray array];
        for (id obj in (NSArray *)self) {
            [arry addObject:[obj cs_serializableObj]];
        }
        return arry;
    }
    
    if([self isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (id key in ((NSDictionary *)self).allKeys) {
            [dict setObject:[((NSDictionary *)self)[key] cs_serializableObj] forKey:key];
        }
        return dict;
    }
    
    if([self isKindOfClass:[NSSet class]]){
        NSMutableArray *arry = [NSMutableArray array];
        for (id obj in ((NSSet *)self).allObjects) {
            [arry addObject:[obj cs_serializableObj]];
        }
        return arry;
    }
    return @"";
}
@end
