//
//  BaseRequest.m
//  dzq
//
//  Created by chentianyu on 16/3/2.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "BaseRequest.h"

@implementation BaseRequest


- (void)HTTPRequestWithURLString:(NSString *)URLString params:(NSDictionary *)params HTTPMethod:(HTTPMethod)method success:(successBlock)success failure:(failureBlock)failureBlock
{
    NSString *absolute_URLString = [APIDOMAIN stringByAppendingString:URLString];
    DDLogInfo(@"URL:%@",absolute_URLString);
    DDLogInfo(@"params:%@",params);
    //发起请求:
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    session.requestSerializer = [AFJSONRequestSerializer serializer];   //请求和响应数据都设置成JSON形式的
    session.responseSerializer = [AFJSONResponseSerializer serializer];
//    session.requestSerializer.ACCESS
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", @"text/javascript", nil];
    if (method==GET) {  //请求方式是“GET”
        [session GET:absolute_URLString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                [self getBaseInfo:responseObject];
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failureBlock(error.description);
        }];
    }else{  //请求方式是“POST”
        [session POST:absolute_URLString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                [self getBaseInfo:responseObject];
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failureBlock(error.description);
        }];
    }

}


//确定msgCode和msg
- (void)getBaseInfo:(NSDictionary *)dic
{
    self.msgCode = [[dic objectForKey:@"code"] integerValue];
    self.msg = [dic objectForKey:@"msg"];
}

@end
