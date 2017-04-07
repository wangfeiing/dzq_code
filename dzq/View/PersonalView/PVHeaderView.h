//
//  PVHeaderView.h
//  dzq
//
//  Created by chentianyu on 16/3/24.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PVHeaderViewDelegate <NSObject>

- (void)clickLoginButton:(UIButton *)button;

@end
@interface PVHeaderView : UIView<PVHeaderViewDelegate>

@property(weak,nonatomic)id <PVHeaderViewDelegate> delegate;
@end
