//
//  RegularJudge.h
//  dzq
//
//  Created by chentianyu on 16/3/28.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegularJudge : NSObject



+(id)shareInstance;


//匹配手机号
-(BOOL)matchMobilephoneNumber:(NSString *)number;

//匹配6~18位字母和数字组合
- (BOOL)matchPassword:(NSString *)password;

//判断内容是否为空
- (BOOL)contentIsNil:(NSString *)str;
@end
