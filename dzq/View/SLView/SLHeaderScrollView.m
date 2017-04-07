//
//  SLHeaderScrollView.m
//  dzq
//
//  Created by chentianyu on 16/2/18.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "SLHeaderScrollView.h"


#define KItemWidth   180         //每个图片的大小
#define KItemInterval 0        //相邻图片的间隔


#define KHeight  135


//最初位置时候的偏移量
//#define KContentOffset 0 //
#define KContentOffset 2.5*KItemWidth+KItemInterval-(SCREEN_WIDTH-DOCK_WIDTH-40)/2

@implementation SLHeaderScrollView
{
    //定义3个图像视图：左、中、右
    UIImageView *leftView;
    UIImageView *centerView;
    UIImageView *rightView;
    
    
    //左、中、右3个图像视图中的数组坐标
    NSInteger leftIndex;
    NSInteger centerIndex;
    NSInteger rightIndex;
    
    
    //底部的滚动视图
    UIScrollView *baseScrollView;
    
//    NSArray *dataArray;
    
    
}

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
        [self initHeaderView];
    }
    return self;
}

-(void)setCenterIndex:(ScrollViewBlock)block
{
    scrollBlock = block;
}


- (void)initHeaderView
{
    leftIndex = 0;
    centerIndex = 1;
    rightIndex = 2;
    
    
    
    self.dataArray = @[
                       [UIImage imageNamed:@"a1"],
                       [UIImage imageNamed:@"a2"],
                       [UIImage imageNamed:@"a3"],
                       [UIImage imageNamed:@"a4"],
                       [UIImage imageNamed:@"a5"],
                       ];

    [self createHeaderView];
}

- (void)createHeaderView
{
    //初始化baseScrollView
    baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-DOCK_WIDTH-40, 135)];
    baseScrollView.layer.borderColor = [[UIColor redColor] CGColor];
    baseScrollView.layer.borderWidth = 1.0f;
    baseScrollView.contentSize = CGSizeMake(7*KItemWidth+2*KItemInterval, 0);
    [baseScrollView setContentOffset:CGPointMake(0, 0)];
    baseScrollView.userInteractionEnabled = YES;
    baseScrollView.showsHorizontalScrollIndicator = NO;
    baseScrollView.showsVerticalScrollIndicator = NO;
    baseScrollView.clipsToBounds = NO;//不设置裁剪
    baseScrollView.delegate = self;
    [self addSubview:baseScrollView];
    
    //设置baseScrollView初始的偏移量,使得中间视图在屏幕的中央
    [baseScrollView setContentOffset:CGPointMake(KContentOffset, 0)];
    
    
    //初始化左、中、右3个视图
    leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KItemWidth, KHeight)];
    leftView.image = [self.dataArray objectAtIndex:leftIndex];
    [baseScrollView addSubview:leftView];
    
    centerView = [[UIImageView alloc] initWithFrame:CGRectMake(2*KItemWidth + KItemInterval, 0, KItemWidth, KHeight)];
    centerView.image = [self.dataArray objectAtIndex:centerIndex];
    //中间视图放大
    centerView.transform = CGAffineTransformMakeScale(3, 1);
    [baseScrollView addSubview:centerView];
    
    rightView = [[UIImageView alloc] initWithFrame:CGRectMake(4*KItemWidth + 2*KItemInterval, 0, KItemWidth, KHeight)];
    rightView.image = [self.dataArray objectAtIndex:rightIndex];
    [baseScrollView addSubview:rightView];
    
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat xOffset = scrollView.contentOffset.x;
    CGFloat x = KContentOffset;
    
    if ((int)(xOffset-x)%KItemWidth == 0 && (int)(xOffset - x )/KItemWidth != 0) {
        //切换单元格
        [self switchImageView];
        [baseScrollView setContentOffset:CGPointMake(0, 0) animated:YES];//切换玩数据，baseScrollView回复初始化时候的滚动偏移量
        
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    //大于：向右拖曳，偏移量增加一个单元格的宽度
    //小于：向左拖曳，偏移量减少一个单元格的宽度
    if (targetContentOffset->x>KContentOffset) {
        targetContentOffset->x = KItemWidth + KContentOffset;
        
    }else if(targetContentOffset->x < KContentOffset){
        targetContentOffset->x = -KItemWidth + KContentOffset;
    }
}


- (void)switchImageView
{
    //将此时scrllView的偏移量和初始偏移量相比较
    //大于    切换到下一个数据；   小于  切换到上一个数据
    if (baseScrollView.contentOffset.x > KContentOffset) {
        leftIndex = (leftIndex + 1)%self.dataArray.count;
        centerIndex = (centerIndex + 1)%self.dataArray.count;
        rightIndex = (rightIndex + 1)%self.dataArray.count;
        
    }else if(baseScrollView.contentOffset.x < KContentOffset){
        leftIndex = (leftIndex - 1 + self.dataArray.count)%self.dataArray.count;
        centerIndex = (centerIndex - 1 + self.dataArray.count)%self.dataArray.count;
        rightIndex = (rightIndex - 1 + self.dataArray.count)%self.dataArray.count;
    }
    
    leftView.image = [self.dataArray objectAtIndex:leftIndex];
    centerView.image = [self.dataArray objectAtIndex:centerIndex];
    rightView.image = [self.dataArray objectAtIndex:rightIndex];
    if (scrollBlock) {
        scrollBlock(centerIndex);
    }
}
@end
