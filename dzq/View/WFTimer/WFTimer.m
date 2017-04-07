//
//  WFTimer.m
//  Scroll
//
//  Created by wangfei on 16/3/5.
//  Copyright © 2016年 wangfei. All rights reserved.

#import "WFTimer.h"

#define STROKE_COLOR [UIColor colorWithRed:0.33 green:0.81 blue:0.6 alpha:1]

static const CGFloat lineNumber = 120;
static const NSInteger timeInterVal = 12;
static const CGFloat lineWidth = 1;

@implementation WFTimer
{
    CGRect frame;
    CGPoint center;
    NSInteger index;
}
- (instancetype)initWithCenterPosition:(CGPoint)position
                          radius:(float)radius
                  internalRadius:(float)internalRadius
{
    frame = CGRectMake(position.x - radius, position.y - radius, (radius+2)*2, (radius+2)*2);
    center.x = radius + 2;
    center.y = radius + 2;
    self = [super initWithFrame:frame];
    if (self) {
        
        self.radius = radius;
        self.interalRadius = internalRadius;
        self.backgroundColor = [UIColor clearColor];
        NSLog(@"%@",NSStringFromCGRect(self.frame));
        [self addSubview:self.numberLabel];
    }
    return self;
}
//用来显示中间的数字
-(UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
        _numberLabel.center = center;
        _numberLabel.font = [UIFont systemFontOfSize:28.0f];
        _numberLabel.textColor = [UIColor grayColor];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.text = @"12";
    }
    return _numberLabel;
}

- (void)drawRect:(CGRect)rect {
   
    for (int a = 0; a < lineNumber; a++) {
        UIBezierPath * line = [[UIBezierPath alloc] init];
        
        double angle = ((M_PI*2)/lineNumber) * a ;
        [line moveToPoint:[self getRotatedPointWithAngle:angle centerPoint:center radius:self.radius]];
        line.lineWidth = lineWidth;
        if (_running) {
            if (a < index) {
               [[UIColor redColor] setStroke];
            }else{
                [STROKE_COLOR setStroke];
            }
        }else{
            [STROKE_COLOR setStroke];
        }

        [line addLineToPoint:[self getRotatedPointWithAngle:angle centerPoint:center radius:self.interalRadius]];
        [line stroke];
    }
}
// 得到旋转后的点
-(CGPoint)getRotatedPointWithAngle:(double)angle centerPoint:(CGPoint)circleCenter radius:(CGFloat)radius{
    CGPoint finalPoint;

    finalPoint.x = (double)circleCenter.x + radius * sin(angle);
    finalPoint.y = (double)circleCenter.y - radius * cos(angle);
    return finalPoint;
}

//更新时间
-(void)updateTimeCircle:(id)sender{
    if (index < lineNumber) {
        ++index;
        if ((index+1)%(NSInteger)(lineNumber/timeInterVal) == 0) {
            if ((timeInterVal-index/(NSInteger)(lineNumber/timeInterVal)) <= 4) {
                _numberLabel.font = [UIFont systemFontOfSize:36.0f];
                _numberLabel.textColor = [UIColor redColor];
            }
            _numberLabel.text = [NSString stringWithFormat:@"%ld",timeInterVal-((index+1)/(NSInteger)(lineNumber/timeInterVal))];
            if (self.delegate && [self.delegate respondsToSelector:@selector(timeIsRunningWithCurrentTime:)] ) {
                [_delegate timeIsRunningWithCurrentTime:[self getCurrentTime]];
            }
        }
        [self setNeedsDisplay];
        
    }else{
        if ([self.delegate respondsToSelector:@selector(timeIsOut)] && self.delegate) {
            [_delegate timeIsOut];
        }
        
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - interface
//开始计时
-(void)start{
    if (!_timer) {
        _running = YES;
        _timer = [NSTimer scheduledTimerWithTimeInterval:timeInterVal/lineNumber target:self selector:@selector(updateTimeCircle:) userInfo:nil repeats:YES];
    }
}
//得到当前的时间
-(NSInteger)getCurrentTime{

    return [_numberLabel.text integerValue];
}

//暂停
-(void)parse{

    [_timer setFireDate:[NSDate distantFuture]];
}

//继续计时
-(void)continueTime{
    [_timer setFireDate:[NSDate distantPast]];
 
}

//重置计时器
-(void)reset{
    _running = NO;
    _numberLabel.text = @"12";
    _numberLabel.textColor = [UIColor grayColor];
    _numberLabel.font = [UIFont systemFontOfSize:28.0f];
    [_timer invalidate];
    _timer = nil;
    index = 0;
    [self setNeedsDisplay];
}


@end
