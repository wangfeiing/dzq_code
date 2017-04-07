//
//  MusicModel.h
//  dzq
//
//  Created by chentianyu on 16/3/2.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject
@property(nonatomic,assign)NSInteger  m_id;//音乐id
@property(nonatomic,strong)NSString *m_name;//名字
@property(nonatomic,strong)NSString *m_avatar;//头像
@property(nonatomic,strong)NSString *m_intro;//简介
@property(nonatomic,strong)NSString *m_author;//作者
@property(nonatomic,strong)NSString *m_player;//演奏者
@property(nonatomic,strong)NSString *m_uploader;//上传者
@property(nonatomic)NSInteger m_type;//所属类别,，对应“category”
@property(nonatomic,assign)NSInteger m_viewer_count;//浏览量
@property(nonatomic,assign)NSInteger m_good_count;//“赞”的数量
@property(nonatomic,strong)NSString *m_file;
@property(nonatomic,strong)NSString *m_score;//乐谱，存放为图片地址
@property(nonatomic,strong)NSString *create_time;//创建时间
@property(nonatomic,strong)NSString *update_time;//创建时间


- (id)initWithDic:(NSDictionary *)dic;
- (NSMutableArray *)parseWithDic:(NSDictionary *)dic;
@end
