//
//  BaseViewController.h
//  dzq
//
//  Created by chentianyu on 16/3/25.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestApi.h"
#import "ProgressHUD.h"
#import "AppInfo.h"
#import "RegularJudge.h"

@class TeachingDataModel;


@interface BaseViewController : UIViewController


- (void)baseHUDWithOnlyLabel:(UIView *)view withText:(NSString *)str;
- (CGFloat)backNavHeight;
@end
