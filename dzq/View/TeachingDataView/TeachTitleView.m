//
//  TeachTitleView.m
//  dzq
//
//  Created by chentianyu on 16/1/27.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "TeachTitleView.h"

@implementation TeachTitleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self addControl];
        
    }
    return self;
}

- (void)addControl
{
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 216/2, 40/2)];
    [self addSubview:self.title];
    
    self.titleNumber = [[UILabel alloc] initWithFrame:CGRectMake(10+216/2+10, 0, 98/2, 98/2)];
    self.titleNumber.layer.cornerRadius = 5;
    self.titleNumber.clipsToBounds = YES;
    self.titleNumber.backgroundColor = TOTAL_COLOR;
    self.titleText.textColor = [UIColor whiteColor];
    [self addSubview:self.titleNumber];
    
    
    self.titleText = [[UILabel alloc] initWithFrame:CGRectMake(10+216/2+10+98/4, 0, 599/2, 67/2)];
    self.titleText.backgroundColor = DOCK_BACKGROUNDCOLOR;
    self.titleText.textColor = [UIColor whiteColor];
    [self addSubview:self.titleText];
    
    
}
@end
