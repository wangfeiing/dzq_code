//
//  TeachingDataModel.m
//  dzq
//
//  Created by chentianyu on 16/1/27.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "TeachingDataModel.h"

@implementation TeachingDataModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {

        self.title = [dict objectForKey:@"title"];
        self.content = [dict objectForKey:@"content"];
        self.id = [[dict objectForKey:@"id"] integerValue];
    }
    return self;
}


+ (instancetype)modelWithDict:(NSDictionary * )dict
{
    return [[self alloc] initWithDict:dict];
}


@end
