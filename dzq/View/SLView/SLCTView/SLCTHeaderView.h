//
//  SLCTHeaderView.h
//  dzq
//
//  Created by chentianyu on 16/2/20.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLCTButton.h"

@protocol HeaderClick <NSObject>

@required
- (void)clickHeaderButton:(UIButton *)button;
@optional
@end

@interface SLCTHeaderView : UIView{
    SLCTButton *hotButton;
    SLCTButton *uploadButton;
    SLCTButton *updateButton;
    
    UILabel *label;//下方滑动的线
}


@property(nonatomic)id<HeaderClick>delegate;


@end
