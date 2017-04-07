//
//  SLSeparactorLabel.m
//  dzq
//
//  Created by chentianyu on 16/2/18.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "SLSeparactorLabel.h"

@implementation SLSeparactorLabel

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
        self.backgroundColor = SL_SeparatorLine_Color;
        
    }
    return self;
}

@end
