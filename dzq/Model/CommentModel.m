//
//  CommentModel.m
//  dzq
//
//  Created by 飞飞 on 16/4/12.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "CommentModel.h"
@implementation CommentModel


+(CommentModel *)getCommentModelWith:(NSDictionary *)cmt{
    CommentModel * cmtModel = [[CommentModel alloc] init];
    
    cmtModel.com_id = [cmt objectForKey:@"com_id"];
    cmtModel.com_music_id = [cmt objectForKey:@"com_music_id"];
    cmtModel.com_user_token = [cmt objectForKey:@"com_user_token"];
    cmtModel.com_user_name  = [cmt objectForKey:@"com_user_name"];
    cmtModel.replyed_user_token = [cmt objectForKey:@"replyed_user_token"];
    cmtModel.replyed_user_name = [cmt objectForKey:@"replyed_user_name"];
    cmtModel.com_root_id = [cmt objectForKey:@"com_root_id"];
    cmtModel.com_parent_id = [cmt objectForKey:@"com_parent_id"];
    cmtModel.com_time = [cmt objectForKey:@"com_time"];
    cmtModel.com_content = [cmt objectForKey:@"com_content"];

    if ([cmtModel.com_root_id  isEqual: @"0"]) {
        cmtModel.com_root_id = cmtModel.com_id;
    }
    if ([cmtModel.com_user_name isEqual:[NSNull null]]) {
        cmtModel.com_user_name = @"unknown";
    }

    return cmtModel;
}
+(NSMutableDictionary * )getCommentModelsWithDic:(NSDictionary *)dic{
    NSMutableDictionary * cmtDic = [[NSMutableDictionary alloc] init];
    if ([dic objectForKey:@"detail"]) {
        NSInteger  index = 0;
        NSArray * array = (NSArray *)[dic objectForKey:@"detail"];
        for (NSArray * arr in array) {
            NSMutableArray * array = [[NSMutableArray alloc] init];
            for (NSDictionary * d in arr) {
                [array addObject:[self getCommentModelWith:d]];
            }
            [cmtDic setObject:array forKey:[NSNumber numberWithInteger:index++]];
        }
    }else{
    }
    return cmtDic;
}


@end
