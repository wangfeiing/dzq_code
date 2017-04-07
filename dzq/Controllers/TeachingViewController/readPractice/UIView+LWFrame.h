//
//  UIView+LWFrame.h
//  dzq
//
//  Created by 梁伟 on 16/2/29.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LWFrame)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, readonly) CGFloat centerX;
@property (nonatomic, readonly) CGFloat centerY;
@end
