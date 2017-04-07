//
//  CategoryModel.h
//  dzq
//
//  Created by chentianyu on 16/3/2.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryModel : NSObject

@property(nonatomic)NSInteger ca_id;//自增id
@property(nonatomic,strong)NSString *ca_type;//类别名字
@property(nonatomic)NSInteger ca_count;//类别数量
@property(nonatomic,strong)NSString *ca_cover_img;//类别封面


- (instancetype)initWithDic:(NSDictionary *)dic;
- (NSMutableArray *)praseWithDictionary:(NSDictionary *)dic;

@end
