//
//  CollectModel.m
//  dzq
//
//  Created by chentianyu on 16/4/27.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "CollectModel.h"

@implementation CollectModel


- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.id = [[dic objectForKey:@"id"] integerValue];
        self.music_id = [[dic objectForKey:@"music_id"] integerValue];
        self.music_type = [[dic objectForKey:@"music_type"] integerValue];
        self.status = [[dic objectForKey:@"status"] integerValue];
        self.ca_type = [dic objectForKey:@"ca_type"];
        self.m_name = [dic objectForKey:@"m_name"];
        self.m_avatar = [dic objectForKey:@"m_avatar"];
    
    }
    return self;
}
- (NSMutableArray *)parseArray:(NSDictionary *)dic
{
    NSArray *array = [dic objectForKey:@"detail"];
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dic in array) {
        CollectModel *model = [[CollectModel alloc] initWithDic:dic];
        [mutableArray addObject:model];
    }
    return mutableArray;
}
@end
