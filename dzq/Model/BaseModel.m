//
//  BaseModel.m
//  dzq
//
//  Created by 陈天宇 on 16/4/26.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>
@implementation BaseModel


-(NSString *)description
{

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    uint count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i <count ; i++) {
        objc_property_t property = properties[i];
        const char *c_name = property_getName(property);
        NSString *name = [NSString stringWithCString:c_name encoding:NSUTF8StringEncoding];
        id value = [self valueForKey:name];
        [dictionary setObject:value forKey:name];
        
    }
    return [NSString stringWithFormat:@"%@类的model数据字典%@",[self class],dictionary];
}
@end
