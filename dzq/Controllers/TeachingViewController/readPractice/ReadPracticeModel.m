 //
//  ReadPracticeModel.m
//  dzq
//
//  Created by 梁伟 on 16/3/30.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "ReadPracticeModel.h"

@implementation ReadPracticeModel

+ (KeySignatureType)randomKeySignature:(NSMutableArray *)keySignatures{
    
    NSUInteger count = keySignatures.count;
    
    int index = arc4random() % count;
    
    return [keySignatures[index] integerValue];
    
    
}

+ (NSMutableArray *)createReadPracticesWithStaffType:(StaffType)staff keySignatureTypes:(NSMutableArray *)keySignatures polyphoneType:(PolyphoneType)polyphone testCount:(NSInteger)count{
    
    NSMutableArray *practices = [[NSMutableArray alloc] init];

    for(int i=0; i<count; i++) {
        
        [practices addObject:[[self alloc] initWithStaffType:staff keySignatureType:[self randomKeySignature:keySignatures] polyphoneType:polyphone]];
        
    }
    
    return practices;
    
}

- (instancetype)initWithStaffType:(StaffType)staff keySignatureType:(KeySignatureType)keySignature polyphoneType:(PolyphoneType)polyphone
{
    self = [super init];
    if (self) {
        
        _keySignature = keySignature;
        _polyphone = polyphone;
        _staff = staff;
        
        [self makeItems];
        
    }
    return self;
}

- (void)makeItems{
    
    
    NSInteger range1, range2;
    switch (_staff) {
        case StaffTypeBass:
            _range = arc4random()%3;
            range1 = 31;
            range2 = 69;
            break;
            
        case StaffTypeGrand:
            _range = arc4random()%5;
            range1 = 31;
            range2 = 89;
            break;
            
        case StaffTypeTreble:
            _range = arc4random()%3+2;
            range1 = 52;
            range2 = 89;
            break;
    }
    
    NSInteger range3 = _range * 12 + 24;
    NSInteger range4 = ( _range + 2) * 12 + 24;
    
    range3 = range3 > range1 ? range3 : range1;
    range4 = range4 < range2 ? range4 : range2;
    
    _items = [[NSMutableArray alloc] init];
    
    while (self.items.count <= _polyphone) {
        
        NSNumber *num = [self getRandomOfSoundSeriesFrom:range3 to:range4];
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


- (NSMutableArray *)getSoundSeriesWithKeySignature:(KeySignatureType)type{

    NSMutableArray *soundSeries = [[NSMutableArray alloc] init];

    
    int arr[] = {2, 2, 1, 2, 2, 2, 1};
    
    
    for (int i = type; i < 128; ) {
        
        for (int j=0; j<7; j++) {
            
            i += arr[j];
            
            if (i > 20 && i < 128) {
                [soundSeries addObject:[NSNumber numberWithInt:i]];
            }
            
        }
        
    }
    
    return soundSeries;
    
}

- (NSNumber *)getRandomOfSoundSeriesFrom:(NSInteger)range1 to:(NSInteger)range2{
    
    NSNumber *number = [NSNumber numberWithInteger:-1];
    
    NSMutableArray *soundSeries = [self getSoundSeriesWithKeySignature:_keySignature];
    
    while (![soundSeries containsObject:number]) {
        
        NSInteger n = arc4random() % (range2 - range1) + range1;
        number = [NSNumber numberWithInteger:n];
        
    }
    
    return number;
    
    
}

- (RangeType)getRangeType{

    return arc4random()%6;

}

- (NSString *)description{
    NSString *description = @"";
    for (NSNumber *noteNumber in _items) {
        description = [NSString stringWithFormat:@"%@ %@",description,noteNumber];
    }
    return description;
}

@end
