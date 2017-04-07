//
//  UserModel.h
//  dzq
//
//  Created by chentianyu on 16/3/2.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property(nonatomic,assign)NSInteger id;//用户id
@property(nonatomic,strong)NSString *name;//名字
@property(nonatomic,strong)NSString *account;//账号
@property(nonatomic,strong)NSString *password;//密码
@property(nonatomic,strong)NSString *token;//用户token
@property(nonatomic,strong)NSString *avatar;//头像
@property(nonatomic,assign)NSInteger age;//年龄
@property(nonatomic,assign)NSInteger sex;//性别
@property(nonatomic,strong)NSString *phone;//电话
@property(nonatomic,strong)NSString *email;//邮箱
@property(nonatomic,assign)NSInteger status;//该用户是否删除
@property(nonatomic,strong)NSString *logo_time;//登录时间


- (void)initWithToken:(NSString *)string;
- (instancetype)initWithDic:(NSDictionary *)dict;
@end
