//
//  TeachingDataModel.h
//  dzq
//
//  Created by chentianyu on 16/1/27.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeachingDataModel : NSObject

@property(nonatomic,strong)NSString *title;
@property(nonatomic,assign)NSInteger id;
@property(nonatomic,strong)NSString *content;

+ (instancetype)modelWithDict:(NSDictionary * )dict;

@end
