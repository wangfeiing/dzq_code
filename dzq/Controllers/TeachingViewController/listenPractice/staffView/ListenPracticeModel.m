//
//  ListenPracticeModel.m
//  dzq
//
//  Created by 梁伟 on 16/4/14.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "ListenPracticeModel.h"

@implementation ListenPracticeModel

+ (NSMutableArray *)createListenPracticesWithRangeTypes:(RangeType)range ployphoneType:(PolyphoneType)polyphone practiceNumber:(NSInteger)num{
    
    NSMutableArray *practices = [[NSMutableArray alloc] init];
    
    for (int i=0; i<num; i++) {
        
        ListenPracticeModel *practice = [[self alloc] initWithRangeType:range polyphoneType:polyphone];
        
        [practices addObject:practice];
        
    }
    
    
    return practices;
    
    
}


- (instancetype)initWithRangeType:(RangeType)range polyphoneType:(PolyphoneType)polyphone{
    
    self = [super init];
    
    if (self) {
        
        _range = range;
        _polyphone = polyphone;
        
        NSInteger range1 = _range * 12 + 24;
        NSInteger range2 = (_range + 2) * 12 + 24;
        
        _items = [[NSMutableArray alloc] init];
        
        while (_items.count <= _polyphone) {
            NSNumber *num = [self getListenNoteFrom:range1 to:range2];
            if (self.items.count == 0) {
                [self.items addObject:num];
            }else{
                for (int i=0; i<self.items.count; i++) {
                    
                    if ([self.items[i] isEqualToNumber:num]) {
                        break;
                    }
                    
                    if (i == self.items.count - 1) {
                        [self.items addObject:num];
                    }
                }
            }

        }
        
        
    }
    
    return self;
    
}


- (NSNumber *)getListenNoteFrom:(RangeType)range1 to:(RangeType)range2{
    
    NSInteger n = arc4random() % (range2 - range1) + range1;
    
    return [NSNumber numberWithInteger:n];

}


@end
