//
//  UIPregressStar.m
//  Scroll
//
//  Created by wangfei on 16/3/5.
//  Copyright © 2016年 wangfei. All rights reserved.
//

#import "UIPregressStar.h"


@implementation UIPregressStar

- (instancetype)initWithOriginPoint:(CGPoint)origin
{
    CGRect frame;
    frame.origin = origin;
    
    frame.size = CGSizeMake(309, 52);
    self = [super initWithFrame:frame];
    if (self) {        
        UIImageView * rightLabel = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 21, 21)];
        [rightLabel setImage:[UIImage imageNamed:@"star_green.png"]];
        
        UIImageView * wrongLabel = [[UIImageView alloc] initWithFrame:CGRectMake(121, 0, 21, 21)];
        [wrongLabel setImage:[UIImage imageNamed:@"star_red.png"]];

        UIImageView * unfinishLabel   = [[UIImageView alloc] initWithFrame:CGRectMake(227, 0, 21, 21)];
        [unfinishLabel setImage:[UIImage imageNamed:@"star_gray.png"]];
        
        UILabel * right = [[UILabel alloc] initWithFrame:CGRectMake( 23, 4, 42, 20)];
        right.text = @"：正确";
        right.font = [UIFont systemFontOfSize:14.0f];
        right.textColor = [UIColor grayColor];
        
        UILabel * wrong = [[UILabel alloc] initWithFrame:CGRectMake( 140, 4, 42, 20)];
        wrong.text = @"：错误";
        wrong.font = [UIFont systemFontOfSize:14.0f];
        wrong.textColor = [UIColor grayColor];
        
        UILabel * unfinish = [[UILabel alloc] initWithFrame:CGRectMake( 248, 4, 60, 20)];
        unfinish.text = @"：未完成";
        unfinish.font = [UIFont systemFontOfSize:14.0f];
        unfinish.textColor = [UIColor grayColor];
        
        [self addQuestions:self.allQuestions];
        [self addSubview:rightLabel];
        [self addSubview:wrongLabel];
        [self addSubview:unfinishLabel];
        [self addSubview:right];
        [self addSubview:wrong];
        [self addSubview:unfinish];
    }
    return self;
}
-(NSMutableArray *)allQuestions{
    if (!_allQuestions) {
        _allQuestions = [[NSMutableArray alloc] init];
        for (int index = 0; index  < 10; index++) {
            UIImageView * label = [[UIImageView alloc] initWithFrame:CGRectMake(index *32, 31, 21, 21)];
            [label setImage:[UIImage imageNamed:@"star_gray.png"]];
            [_allQuestions insertObject:label atIndex:index];
            
        }
    }
    return _allQuestions;
}
-(void)addQuestions:(NSMutableArray *)allQuestions{
    UIImageView * view = [[UIImageView alloc] init];
    if ([allQuestions count]) {
        for (int index = 0; index < 10; index++) {
            if (_allQuestions[index]&&[(NSString *)[_allQuestions[index] class]  isEqual: (NSString *)[view class]]) {
                [self addSubview:_allQuestions[index]];
            }
            
        }
    }
}

-(void)addRightStarWith:(NSInteger )currentIndex{
    if ([_allQuestions count] && currentIndex < 10) {
        _rightNum++;
        [self changeToRight:_allQuestions[currentIndex]];
    }
}
-(void)addWrongStarWith:(NSInteger )currentIndex{
    if ([_allQuestions count] && currentIndex < 10) {
        _wrongNum++;
        [self changeToWrong:_allQuestions[currentIndex]];
    }
}
-(void)reset{
    _wrongNum = 0;
    _rightNum = 0;
    if ([_allQuestions count]) {
        for (UIImageView * label in _allQuestions) {
            [self changeToUnfinish:label];
        }
    }
}
-(void)changeToWrong:(UIImageView *)label{
   
    [label setImage:[UIImage imageNamed:@"star_red.png"]];
}
-(void)changeToRight:(UIImageView *)label{
    
    [label setImage:[UIImage imageNamed:@"star_green.png"]];
}
-(void)changeToUnfinish:(UIImageView *)label{

    [label setImage:[UIImage imageNamed:@"star_gray.png"]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
