//
//  CategoryModel.m
//  dzq
//
//  Created by chentianyu on 16/3/2.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "CategoryModel.h"

@implementation CategoryModel


- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.ca_id = [[dic objectForKey:@"ca_id"] integerValue];
        self.ca_type = [dic objectForKey:@"ca_type"];
        self.ca_count = [[dic objectForKey:@"ca_count"] integerValue];
        self.ca_cover_img = [dic objectForKey:@"ca_cover_img"];
    }
    return self;
}



- (NSMutableArray *)praseWithDictionary:(NSDictionary *)dic
{
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    NSArray *array = [NSArray array];
    array = [dic objectForKey:@"list"];
    for (NSDictionary  *tempDic in array) {
        
        CategoryModel *model = [[CategoryModel alloc] initWithDic:tempDic];
        [returnArray addObject:model];
    }
    
    return returnArray;
}
@end
