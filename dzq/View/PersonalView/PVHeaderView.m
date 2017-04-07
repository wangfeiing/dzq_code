//
//  PVHeaderView.m
//  dzq
//
//  Created by chentianyu on 16/3/24.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "PVHeaderView.h"

@implementation PVHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)clickLoginButton:(UIButton *)button{
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        hintLabel.text = @"登录后可以实现曲谱收藏列表的异地同步,";
        hintLabel.font = [UIFont systemFontOfSize:14.0];
        hintLabel.numberOfLines = 1;//
        CGSize size = [hintLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0],NSFontAttributeName, nil]];
        hintLabel.frame = CGRectMake(10, self.frame.size.height-size.height-4, size.width, size.height);
        [self addSubview:hintLabel];
        
        //
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
        [loginButton setTitleColor:ThemeColor forState:UIControlStateNormal];
        loginButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        loginButton.frame = CGRectMake(hintLabel.frame.origin.x+hintLabel.frame.size.width, hintLabel.frame.origin.y, 100, hintLabel.frame.size.height);
        [loginButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:loginButton];
        
        //
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.frame.size.height-1, self.frame.size.width-20, 1)];
        lineLabel.backgroundColor = SL_SeparatorLine_Color;
        [self addSubview:lineLabel];

        
    }
    return self;
}

- (void)login:(UIButton *)button
{
    [self.delegate clickLoginButton:button];
}

@end
