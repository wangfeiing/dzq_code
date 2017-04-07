//
//  PersonalMasterTableViewCell.m
//  dzq
//
//  Created by chentianyu on 16/4/12.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "PersonalMasterTableViewCell.h"

@implementation PersonalMasterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 40, 40)];
//    label.text = @"aaasss";
//    [self.contentView addSubview:label];
    
    

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)addCustomSubview
{
    __weak typeof(self) weakSelf = self;
    self.titleIconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.titleIconImageView];
    [self.titleIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView.mas_centerY).with.offset(0);
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(40);
        make.width.mas_equalTo(@20);
        make.height.mas_equalTo(@20);
    }];
    
    self.titleTextLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.titleTextLabel];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView.mas_centerY).with.offset(0);
        make.left.equalTo(self.titleIconImageView.mas_right).with.offset(5);
        make.right.equalTo(weakSelf.contentView.mas_right).with.offset(0);
    }];
}
//

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
         [self addCustomSubview];
    }
    return self;
}
@end
