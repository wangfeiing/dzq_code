//
//  ManagerModel.h
//  dzq
//
//  Created by chentianyu on 16/3/2.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ManagerModel : NSObject

@property(nonatomic)NSInteger id;//管理员id
@property(nonatomic,strong)NSString *username;//用户名
@property(nonatomic,strong)NSString *account;//账户
@property(nonatomic,strong)NSString *password;//密码
@property(nonatomic,strong)NSString *token;//用户token
@property(nonatomic,strong)NSString *phone;//手机号
@property(nonatomic,strong)NSString *email;//邮箱
@property(nonatomic)NSInteger status;//用户是否删除

@end
