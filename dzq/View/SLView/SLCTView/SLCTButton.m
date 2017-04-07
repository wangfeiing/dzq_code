//
//  SLCTButton.m
//  dzq
//
//  Created by chentianyu on 16/2/20.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "SLCTButton.h"

@implementation SLCTButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return self;
}



@end
