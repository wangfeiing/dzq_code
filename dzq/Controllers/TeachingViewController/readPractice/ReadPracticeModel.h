//
//  ReadPracticeModel.h
//  dzq
//
//  Created by 梁伟 on 16/3/30.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StaffView.h"
#import "StaffType.h"

@interface ReadPracticeModel : NSObject


@property (nonatomic, assign) KeySignatureType keySignature;
@property (nonatomic, assign) PolyphoneType polyphone;
@property (nonatomic, assign) RangeType range;
@property (nonatomic, assign) StaffType staff;
@property (nonatomic, strong) NSMutableArray *items;

+ (NSMutableArray *)createReadPracticesWithStaffType:(StaffType)staff keySignatureTypes:(NSMutableArray *)keySignatures polyphoneType:(PolyphoneType)polyphone testCount:(NSInteger)count;


@end
