//
//  CustomTableViewCell.m
//  dzq
//
//  Created by 陈天宇 on 16/5/23.
//  Copyright © 2016年 chentianyu. All rights reserved.

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 0, self.frame.size.height);
    CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height);

    CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
    CGContextStrokePath(context);
}
@end
