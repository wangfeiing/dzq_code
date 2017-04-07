//
//  ProgressHUD.h
//  dzq
//
//  Created by chentianyu on 16/3/22.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ProgressHUD : NSObject

- (void)HUDWithIndicator:(UIView *)view withText:(NSString *)str;
- (void)HUDWithOnlyLabel:(UIView *)view withText:(NSString *)str;
- (void)HUDWithOnlyLabel:(UIView *)view withText:(NSString *)str delay:(NSTimeInterval)delay;
- (MBProgressHUD *)HUDWithIndeterminateMode:(UIView *)view withText:(NSString *)text;
- (void)hideHud:(MBProgressHUD *)hud;
@end
