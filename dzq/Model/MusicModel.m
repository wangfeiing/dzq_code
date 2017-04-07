//
//  MusicModel.m
//  dzq
//
//  Created by chentianyu on 16/3/2.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel


- (id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.m_id = [[dic objectForKey:@"m_id"] integerValue];
        self.m_name = [dic objectForKey:@"m_name"];
        self.m_avatar = [dic objectForKey:@"m_avatar"];
        self.m_intro = [dic objectForKey:@"m_intro"];
        self.m_author = [dic objectForKey:@"m_author"];
        self.m_uploader = [dic objectForKey:@"m_uploader"];
        self.m_player = [dic objectForKey:@"m_player"];
        self.m_type = [[dic objectForKey:@"m_type"] integerValue];
        self.m_viewer_count = [[dic objectForKey:@"m_viewer_count"] integerValue];
        self.m_good_count = [[dic objectForKey:@"m_good_count"] integerValue];
        self.m_file = [dic objectForKey:@"m_file"];
        self.m_score = [dic objectForKey:@"m_score"];
        self.create_time = [dic objectForKey:@"create_time"];
        self.update_time = [dic objectForKey:@"update_time"];
    }
    return self;
}

- (NSMutableArray *)parseWithDic:(NSDictionary *)dic
{
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *tempDic in (NSArray *)[dic objectForKey:@"list"]) {
        MusicModel *model = [[MusicModel alloc] initWithDic:tempDic];
        [mutableArray addObject:model];
    }
    return mutableArray;
}
@end
