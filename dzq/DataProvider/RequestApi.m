//
//  RequestApi.m
//  dzq
//
//  Created by chentianyu on 16/3/2.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "RequestApi.h"

@implementation RequestApi


+ (instancetype)shareInstance
{
    static RequestApi * requestApi = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        requestApi = [[RequestApi alloc] init];
    });
    return requestApi;
}
//用户登录
- (void)userLoginWithApi:(NSString *)url method:(HTTPMethod)method parameters:(NSDictionary *)parameters successBlock:(successBlock)success failureBlock:(failureBlock)failure
{
    
    [self HTTPRequestWithURLString:url params:parameters HTTPMethod:method success:success failure:failure];
}

//注册
- (void)user_registWithApi:(NSString *)url method:(HTTPMethod)method parameters:(NSDictionary *)parameters successBlock:(successBlock)success failureBlock:(failureBlock)failure
{
    [self HTTPRequestWithURLString:url params:parameters HTTPMethod:method success:success failure:failure];
}
//产品介绍
- (void)public_introduceWithApi:(NSString *)url method:(HTTPMethod)method parameters:(NSDictionary *)parameters successBlock:(successBlock)success failureBlock:(failureBlock)failure
{
    [self HTTPRequestWithURLString:url params:parameters HTTPMethod:method success:success failure:failure];
}

- (void)user_infoWithURLString:(NSString *)URLString method:(HTTPMethod)method parameters:(NSDictionary *)parameters successBlock:(successBlock)success failureBlock:(failureBlock)failure
{
    [self HTTPRequestWithURLString:URLString params:parameters HTTPMethod:method success:success failure:failure];
}

//找回密码
- (void)user_getPasswdWithApi:(NSString *)url method:(HTTPMethod)method parameters:(NSDictionary *)parameters successBlock:(successBlock)success failureBlock:(failureBlock)failure
{
    [self HTTPRequestWithURLString:url params:parameters HTTPMethod:method success:success failure:failure];
}
//用户收藏
- (void)user_collectWithURLString:(NSString *)URLString method:(HTTPMethod)method parameters:(NSDictionary *)parameters successBlock:(successBlock)success failureBlock:(failureBlock)failure
{
    [self HTTPRequestWithURLString:URLString params:parameters HTTPMethod:method success:success failure:failure];
}
//得到用户收藏列表
- (void)user_collectListWithURLString:(NSString *)URLString method:(HTTPMethod)method parameters:(NSDictionary *)parameters successBlock:(successBlock)success failureBlock:(failureBlock)failure
{
    [self HTTPRequestWithURLString:URLString params:parameters HTTPMethod:method success:success failure:failure];
}
//用户练习记录
- (void)user_practiceWithURLString:(NSString *)URLString method:(HTTPMethod)method parameters:(NSDictionary *)parameters successBlock:(successBlock)success failureBlock:(failureBlock)failure{
    [self HTTPRequestWithURLString:URLString params:parameters HTTPMethod:method success:success failure:failure];
}

//头像
- (void)user_avatarWithURLString:(NSString *)URLString method:(HTTPMethod)method parameters:(NSDictionary *)parameters successBlock:(successBlock)success failureBlock:(failureBlock)failure
{
    [self HTTPRequestWithURLString:URLString params:parameters HTTPMethod:method success:success failure:failure];
}
//编辑用户信息
- (void)user_changeInfoWithURLString:(NSString *)URLString method:(HTTPMethod)method parameters:(NSDictionary *)parameters successBlock:(successBlock)success failureBlock:(failureBlock)failure
{
    [self HTTPRequestWithURLString:URLString params:parameters HTTPMethod:method success:success failure:failure];
}

//用户反馈信息
- (void)user_feedbackInfoWithURLString:(NSString *)URLString method:(HTTPMethod)method parameters:(NSDictionary *)parameters successBlock:(successBlock)success failureBlock:(failureBlock)failure
{
    [self HTTPRequestWithURLString:URLString params:parameters HTTPMethod:method success:success failure:failure];
}


//====================
//教学
- (void)teach_getDataWithURLString:(NSString*)URLString method:(HTTPMethod)method success:(successBlock)successBlock failure:(failureBlock)failureBlock;
{
    [self HTTPRequestWithURLString:URLString params:nil HTTPMethod:method success:successBlock failure:failureBlock];
}



//==================
//谱库

//热门推荐
- (void)sl_hotRecommandWithURLString:(NSString *)url method:(HTTPMethod)method parameters:(NSDictionary *)parameters successBlock:(successBlock)success failurlBlock:(failureBlock)failure\
{
    [self HTTPRequestWithURLString:url params:parameters HTTPMethod:method success:success failure:failure];
}
//分类
- (void)sl_categoryWithURLString:(NSString *)url method:(HTTPMethod)method parameters:(NSDictionary *)parameters successBlock:(successBlock)success failurlBlock:(failureBlock)failure{
    [self HTTPRequestWithURLString:url params:parameters HTTPMethod:method success:success failure:failure];
}
//获得某类的具体的
- (void)sl_listWithURLString:(NSString *)url method:(HTTPMethod)method parameters:(NSDictionary *)parameters successBlock:(successBlock)success failurlBlock:(failureBlock)failure
{
    [self HTTPRequestWithURLString:url params:parameters HTTPMethod:method success:success failure:failure];
}

//用户收藏曲子
- (void)sl_collectWithURLString:(NSString *)url method:(HTTPMethod)method parameters:(NSDictionary *)parameters successBlock:(successBlock)success failurlBlock:(failureBlock)failure
{
    [self HTTPRequestWithURLString:url params:parameters HTTPMethod:method success:success failure:failure];
}
//用户

@end
