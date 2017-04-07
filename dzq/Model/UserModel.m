//
//  UserModel.m
//  dzq
//
//  Created by chentianyu on 16/3/2.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel


//
- (instancetype)initWithDic:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        dict = [dict objectForKey:@"detail"];
        if ([NSNull null] != [dict objectForKey:@"id"]) {
            self.id = [[dict objectForKey:@"id"] integerValue];
        }else{
            self.id = 0;
        }
        self.id = [[dict objectForKey:@"id"] integerValue];
        self.account = [dict objectForKey:@"account"];
        self.token = [dict objectForKey:@"token"];
        self.avatar = [dict objectForKey:@"avatar"];
        if ([NSNull null] != [dict objectForKey:@"age"]) {
            self.age = [[dict objectForKey:@"age"] integerValue];
        }else{
            self.age = 0;
        }
        if ([NSNull null] != [dict objectForKey:@"age"]) {
            self.sex = [[dict objectForKey:@"sex"] integerValue];
        }else{
            self.sex = 1;
        }

        self.phone = [dict objectForKey:@"phone"];
        self.email = [dict objectForKey:@"eamil"];
        if ([NSNull null] != [dict objectForKey:@"status"]){
            self.status = [[dict objectForKey:@"status"] integerValue];
        }else{
            self.status = 0;
        }

        self.logo_time = [dict objectForKey:@"logo_time"];
    }
    return self;
}

- (void)initWithToken:(NSString *)string
{
    self.token = string;
}
@end
