//
//  SLCTCollectionViewCell.m
//  dzq
//
//  Created by chentianyu on 16/4/11.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "SLCTCollectionViewCell.h"

@implementation SLCTCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        __weak typeof(self) weakSelf = self;
        UIView *subView = [[UIView alloc] init];
        subView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:subView];
        
        [subView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf).with.insets(UIEdgeInsetsZero);
        }];
        
        //
        self.avatarImageView = [[UIImageView alloc] init];
        [subView addSubview:self.avatarImageView];
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(subView.mas_top).with.offset(0);
            make.left.equalTo(subView.mas_left).with.offset(0);
            make.right.equalTo(subView.mas_right).with.offset(0);

        }];
        NSLayoutConstraint *imageViewConstraint = [NSLayoutConstraint constraintWithItem:self.avatarImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:subView attribute:NSLayoutAttributeHeight multiplier:0.8 constant:0];
        imageViewConstraint.active = YES;
        
        //
        UIView *bottomSubView = [[UIView alloc] init];
        [subView addSubview:bottomSubView];
        [bottomSubView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarImageView.mas_bottom).with.offset(0);
            make.left.equalTo(subView.mas_left).with.offset(0);
            make.right.equalTo(subView.mas_right).with.offset(0);
            make.bottom.equalTo(subView.mas_bottom).with.offset(0);
        }];
        
        //点赞
        self.goodButton = [[SLCTCollectionButton alloc] init];
        [bottomSubView addSubview:self.goodButton];
        [self.goodButton setImage:[UIImage imageNamed:@"goodButton_unselect"] forState:UIControlStateNormal];
//        self.goodButton.imageView.image = [UIImage imageNamed:@"goodButton_unselect"];
        self.goodButton.selected = NO;
        [self.goodButton setImage:[UIImage imageNamed:@"goodButton_selected"] forState:UIControlStateSelected];
        [self.goodButton addTarget:self action:@selector(clickGoodButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.goodButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bottomSubView.mas_centerY).with.offset(0);
            make.right.equalTo(bottomSubView.mas_right).with.offset(-10);
            make.height.mas_equalTo(@25);
            make.width.mas_equalTo(@25);
        }];
        
        //标题
        self.title = [[UILabel alloc] init];
        self.title.numberOfLines = 1;
        self.title.lineBreakMode = NSLineBreakByTruncatingTail;
        [bottomSubView addSubview:self.title];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bottomSubView.mas_centerY).with.offset(0);
            make.right.equalTo(self.goodButton.mas_left).with.offset(0);
            make.left.equalTo(bottomSubView.mas_left).with.offset(15);
        }];
        
        
    }
    return self;
}


- (void)clickGoodButton:(SLCTCollectionButton *)button
{
    [self.collectDelegate clickToCollect:button];
}
@end
