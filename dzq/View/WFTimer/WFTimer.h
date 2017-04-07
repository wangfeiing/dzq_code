//
//  WFTimer.h
//  Scroll
//
//  Created by wangfei on 16/3/5.
//  Copyright © 2016年 wangfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WFTimerDelegate <NSObject>

@optional

-(void)timeIsOut;
-(void)timeIsRunningWithCurrentTime:(NSInteger)currentTime;

@end

@interface WFTimer : UIView


@property float radius; //外部圆的半径
@property BOOL running; //控件是否正在工作
@property float interalRadius; //内部圆的半径

@property (nonatomic, strong) UIColor *circleStrokeColor;       //静态时的颜色
@property (nonatomic, strong) UIColor *activeCircleStrokeColor; //运行的时候的颜色
@property (nonatomic, strong ,readonly) NSTimer *timer;
@property (nonatomic, strong) UILabel *numberLabel;             //时间的显示
@property (nonatomic, assign,readonly) NSInteger currentTime;   //当前的时间
@property(nonatomic ,assign)  id<WFTimerDelegate> delegate;     

/**
*  position     空间中心位置
*  radius       外部圆的半径
*  internalRadius  内部圆的半径
*/

- (instancetype)initWithCenterPosition:(CGPoint)position
                                radius:(float)radius
                        internalRadius:(float)internalRadius;


//开始计时
-(void)start;
//暂停
-(void)parse;
//继续进行
-(void)continueTime;
//重置
-(void)reset;

@end
