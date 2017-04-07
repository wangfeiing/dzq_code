//
//  TeachDataCell.m
//  dzq
//
//  Created by chentianyu on 16/1/27.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "TeachDataCell.h"

@implementation TeachDataCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 10, self.frame.size.height);
    CGContextAddLineToPoint(context, self.frame.size.width-20, self.frame.size.height);
    CGContextSetLineWidth(context, 1.0f);
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:247/255 green:247/255 blue:248/255 alpha:1.0] CGColor]);
    CGContextStrokePath(context);
}

@end
