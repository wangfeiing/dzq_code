//
//  SettingView.m
//  dzq
//
//  Created by chentianyu on 16/1/24.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "SettingView.h"

@implementation SettingView

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
        self.frame = CGRectMake(0, DOCK_HEIGHT-2*DOCK_ITEM_HEIGHT, DOCK_ITEM_WIDTH, DOCK_ITEM_HEIGHT);
        [self setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}
@end
