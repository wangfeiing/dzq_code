//
//  UIPregressStar.h
//  Scroll
//
//  Created by wangfei on 16/3/5.
//  Copyright © 2016年 wangfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPregressStar : UIView

@property(nonatomic ,strong ) NSMutableArray * allQuestions;
@property(nonatomic ,assign ,readonly) NSInteger rightNum;  //正确的数目
@property(nonatomic ,assign ,readonly) NSInteger wrongNum;  //错误的数目


-(instancetype)initWithOriginPoint:(CGPoint)origin; // 以起点初始化
-(void)addRightStarWith:(NSInteger )currentIndex;   // 增添一个正确的
-(void)addWrongStarWith:(NSInteger )currentIndex;   // 增加一个错误的
-(void)reset;                                       // 重置控件

@end
