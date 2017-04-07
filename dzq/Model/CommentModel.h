//
//  CommentModel.h
//  dzq
//
//  Created by 飞飞 on 16/4/12.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

@property (nonatomic ,retain) NSString * com_id;      //评论id
@property (nonatomic ,retain) NSString * com_music_id;  //评论的音乐id
@property (nonatomic ,retain) NSString * com_user_token;
@property (nonatomic ,retain) NSString * replyed_user_token;
@property (nonatomic ,retain) NSString * com_root_id; //评论的1级id
@property (nonatomic ,retain) NSString * com_parent_id;//父级id
@property (nonatomic ,retain) NSString * com_content; //评论的内容
@property (nonatomic ,retain) NSString * com_user_name; //当前的用户的名字
@property (nonatomic ,retain) NSString * replyed_user_name; //被回复的人的名字
@property (nonatomic ,retain) NSString * com_time;  //评论的发布时间
@property (nonatomic ,assign,readonly) BOOL isNULL;

//-(CommentModel *)getCommentModelWith:(NSDictionary *)cmt;
+(NSMutableDictionary * )getCommentModelsWithDic:(NSDictionary *)dic;

@end
