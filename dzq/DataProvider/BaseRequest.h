//
//  BaseRequest.h
//  dzq
//
//  Created by chentianyu on 16/3/2.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSInteger,HTTPMethod){
    POST,
    GET
};


typedef void (^successBlock) (id result);
typedef void (^failureBlock) (NSString *message);
@interface BaseRequest : NSObject


- (void)HTTPRequestWithURLString:(NSString *)URLString params:(NSDictionary *)params HTTPMethod:(HTTPMethod)method success:(successBlock)success failure:(failureBlock)failureBlock;

@property(nonatomic,assign)NSInteger msgCode;
@property(nonatomic,strong)NSString *msg;

@end
