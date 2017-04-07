//
//  DataCollectionViewCell.m
//  dzq
//
//  Created by chentianyu on 16/4/10.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "DataCollectionViewCell.h"

@implementation DataCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.cornerRadius = 5.0f;
        self.backgroundColor = [UIColor whiteColor];
        
        __weak typeof(self) weakSelf = self;
        self.imageView = [[UIImageView alloc] init];
//        self.imageView.layer.borderColor = [[UIColor blackColor] CGColor];
//        self.imageView.layer.borderWidth = 1.0f;
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.mas_left).with.offset(10);
            make.centerY.mas_equalTo(weakSelf.mas_centerY).with.offset(0);
            make.width.mas_equalTo(self.frame.size.height-20);
            make.height.mas_equalTo(self.frame.size.height-20);
            
        }];
        self.imageView.layer.cornerRadius = (self.frame.size.height-20)/2;
        self.imageView.clipsToBounds = YES;
        
        //
        self.discloureView= [[UIImageView alloc] init];
        self.discloureView.image = [UIImage imageNamed:@"disclosure"];
        [self addSubview:self.discloureView];
        [self.discloureView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.mas_centerY).with.offset(0);
            make.right.equalTo(weakSelf.mas_right).with.offset(-10);
            make.height.mas_equalTo(@12);
            make.width.mas_equalTo(@12);
        }];
        
        self.titleLabel = [[UILabel alloc] init];
        [self addSubview:self.titleLabel];
        self.titleLabel.numberOfLines = 1;
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.imageView.mas_right).with.offset(10);
            make.centerY.mas_equalTo(self.imageView.mas_centerY).with.offset(-10);
            make.right.mas_equalTo(weakSelf.discloureView.mas_left).with.offset(0);
            
        }];
        
        self.subTitleLabel = [[UILabel alloc] init];
        self.subTitleLabel.numberOfLines = 2;
        self.subTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        self.subTitleLabel.font = [UIFont systemFontOfSize:14.0f];
        self.subTitleLabel.textColor = [UIColor grayColor];
//        CGSize subTitleLabelSize = [@"学习" sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14.0f] forKey:NSFontAttributeName]];
        [self addSubview:self.subTitleLabel];
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.titleLabel.mas_left).with.offset(0);
            make.right.mas_equalTo(weakSelf.discloureView.mas_left).with.offset(0);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).with.offset(0);
            make.height.mas_equalTo(40);
        }];
        
    }
    return self;
}

@end
