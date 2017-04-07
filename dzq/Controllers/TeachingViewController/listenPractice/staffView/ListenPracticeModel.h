//
//  ListenPracticeModel.h
//  dzq
//
//  Created by 梁伟 on 16/4/14.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StaffType.h"

@interface ListenPracticeModel : NSObject
@property (nonatomic, assign)RangeType range;
@property (nonatomic, assign)PolyphoneType polyphone;
@property (nonatomic, strong)NSMutableArray *items;

+ (NSMutableArray *)createListenPracticesWithRangeTypes:(RangeType)range ployphoneType:(PolyphoneType)polyphone practiceNumber:(NSInteger)num;

- (instancetype)initWithRangeType:(RangeType)range polyphoneType:(PolyphoneType)polyphone;

@end
