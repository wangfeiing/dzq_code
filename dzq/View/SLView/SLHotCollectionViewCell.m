//
//  SLHotCollectionViewCell.m
//  dzq
//
//  Created by chentianyu on 16/3/21.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "SLHotCollectionViewCell.h"

@implementation SLHotCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:self.imageView];
        
        
        
         self.titleLabel= [[UILabel alloc] init];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor whiteColor];
        [self.imageView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(0);
            make.right.equalTo(self.mas_right).with.offset(0);
            make.bottom.equalTo(self.mas_bottom).with.offset(0);
//            make.height.mas_equalTo(self.imageView.frame.size.height*0.8);
        }];
        NSLayoutConstraint *heightConstrain = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:0.2 constant:0];
        [heightConstrain setActive:YES];
        
        
        
    }
    return self;
}

@end
