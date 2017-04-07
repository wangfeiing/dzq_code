//
//  CollectModel.h
//  dzq
//
//  Created by chentianyu on 16/4/27.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "BaseModel.h"

@interface CollectModel : BaseModel

@property(nonatomic,assign)NSInteger id;
@property(nonatomic,assign)NSInteger music_id;
@property(nonatomic,assign)NSInteger music_type;
@property(nonatomic,assign)NSInteger status;
@property(nonatomic,strong)NSString *ca_type;
@property(nonatomic,strong)NSString *m_name;
@property(nonatomic,strong)NSString *m_avatar;


- (instancetype)initWithDic:(NSDictionary *)dic;
- (NSMutableArray *)parseArray:(NSDictionary *)dic;
@end
