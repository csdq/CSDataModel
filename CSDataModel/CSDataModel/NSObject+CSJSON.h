//
//  NSObject+CSJSON.h
//  CSDataModel
//
//  Created by Mr.s on 2018/8/14.
//  Copyright © 2018年 CSDQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CSJSONSerializable <NSObject>
@optional
//返回可序列化的对象
- (id)cs_serializableObj;
@end

@interface NSObject (CSJSON)<CSJSONSerializable>
- (NSString *)cs_JSON;
@end
