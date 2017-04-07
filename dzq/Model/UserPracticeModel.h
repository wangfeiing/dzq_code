//
//  UserPracticeModel.h
//  dzq
//
//  Created by chentianyu on 16/3/2.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserPracticeModel : NSObject

@property(nonatomic,assign)NSInteger id;
@property(nonatomic,strong)NSString *user_token;//用户token
@property(nonatomic,assign)NSInteger music_id;//练习曲子id
@property(nonatomic,strong)NSString *last_time;//上次练习时间

@end
