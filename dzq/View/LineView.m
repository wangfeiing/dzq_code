

//
//  LineView.m
//  dzq
//
//  Created by 梁伟 on 16/5/7.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "LineView.h"

@implementation LineView

- (instancetype)initWithLineNumber:(NSInteger)num{
    
    self = [super init];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        _lineNumber = num;
        self.bounds = CGRectMake(0, 0, 40, 15*(_lineNumber+1));
        
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    CGContextSetLineCap(context, kCGLineCapButt);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    
    CGFloat width = self.bounds.size.width;
    
    for (int i=0; i<_lineNumber; i++) {
        
        CGContextMoveToPoint(context, 0, 15*(i+1));
        CGContextAddLineToPoint(context, width, 15*(i+1));
        
    }
    
    CGContextDrawPath(context, kCGPathStroke);
}

- (void)dismiss{
    
    [self removeFromSuperview];
    
}

@end
