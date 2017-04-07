//
//  PersonalPracticeTableViewCell.m
//  dzq
//
//  Created by chentianyu on 16/4/16.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "PersonalPracticeTableViewCell.h"

@implementation PersonalPracticeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.rightRateLabel = [[UILabel alloc] init];
        [self addSubview:self.rightRateLabel];
        [self.rightRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY).with.offset(0);
            make.right.equalTo(self.mas_right).with.offset(-20);
            make.width.mas_equalTo(@100);
            
        }];
        self.rightRateLabel.textAlignment = NSTextAlignmentCenter;
        
        self.practiceTimeLabel = [[UILabel alloc] init];
        [self addSubview:self.practiceTimeLabel];
        [self.practiceTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(20);
            make.centerY.equalTo(self.mas_centerY).with.offset(0);
            make.right.equalTo(self.rightRateLabel.mas_left).with.offset(0);
        }];
        
        
    }
    return self;
}


@end
