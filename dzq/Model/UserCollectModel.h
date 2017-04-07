//
//  UserCollectModel.h
//  dzq
//
//  Created by chentianyu on 16/3/2.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCollectModel : NSObject

@property(nonatomic,assign)NSInteger id;
@property(nonatomic,strong)NSString *user_token;//用户token
@property(nonatomic,assign)NSInteger music_id;//音乐id
@end
