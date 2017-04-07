
//
//  GreatView.m
//  dzq
//
//  Created by 梁伟 on 16/4/26.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "GreatView.h"

@implementation GreatView

- (instancetype)initWithCenter:(CGPoint)center
{
    self = [super init];
    if (self) {
        
        self.image = [UIImage imageNamed:@"great.png"];
        self.bounds = CGRectZero;
        self.center = center;
        self.alpha = 0;
        
    }
    return self;
}

- (void)showGreat{
    
    [UIView animateWithDuration:0.7 animations:^{
        self.alpha = 1;
        self.bounds = CGRectMake(0, 0, 210, 80);
    } completion:^(BOOL finished) {
        
        self.alpha = 0;
        self.bounds = CGRectZero;
        
    }];
    
}

@end
