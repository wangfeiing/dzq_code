//
//  SLCTCell.m
//  dzq
//
//  Created by chentianyu on 16/2/20.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "SLCTCell.h"

@implementation SLCTCell

- (void)awakeFromNib {
    // Initialization code
    
    
    self.introlLabel.textColor = SL_Category_List_Text_Color;
    self.uploaderLabel.textColor = SL_Category_List_Text_Color;
    self.playerLabel.textColor = SL_Category_List_Text_Color;
    self.goodLabel.textColor = SL_Category_List_Text_Color;
    self.viewerLabel.textColor = SL_Category_List_Text_Color;
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
    CGContextSetStrokeColorWithColor(context, SL_Category_List_Separator_Color.CGColor);
    CGContextStrokePath(context);
}

@end
