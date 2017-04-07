//
//  SLCategoryCollectionViewCell.m
//  dzq
//
//  Created by chentianyu on 16/2/19.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "SLCategoryCollectionViewCell.h"
#define CountLabelHeight  40  //用来标记数量标签的高度

@implementation SLCategoryCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
//        self.
        UIView *back_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        back_view.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:back_view];
        
        //设置上部的图片
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height*0.8)];
        self.imageView.clipsToBounds = YES;
        [back_view addSubview:self.imageView];
//        imageView.
        
        UIView *topView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height*0.8)];
        topView.backgroundColor = [UIColor clearColor];
        [self.imageView addSubview:topView];
        
        
//        CGRect rect = CGRectMake(0, self.imageView.frame.size.height/2-CountLabelHeight/2, self.imageView.frame.size.width, CountLabelHeight);
        CGRect rect = CGRectMake(0, self.imageView.frame.size.height-CountLabelHeight, self.imageView.frame.size.width, CountLabelHeight);
        self.countLabel = [[UILabel alloc] initWithFrame:rect];
        self.countLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        self.countLabel.textAlignment = NSTextAlignmentCenter;
        self.countLabel.textColor = [UIColor whiteColor];
        [topView addSubview:self.countLabel];
                                   
        
        
        //设置下部的标题和数量
        self.typeLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height*0.85, frame.size.width, frame.size.height*0.1)];
        self.typeLabel.textAlignment = NSTextAlignmentCenter;
        [back_view addSubview:self.typeLabel];
        
    }
    return self;
}
@end
