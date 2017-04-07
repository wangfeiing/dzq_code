//
//  ProgressHUD.m
//  dzq
//
//  Created by chentianyu on 16/3/22.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "ProgressHUD.h"



@implementation ProgressHUD

- (void)HUDWithIndicator:(UIView *)view withText:(NSString *)str;
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
//    HUD.contentColor = [UIColor blackColor];
//    HUD.label.textColor = [UIColor whiteColor];
    HUD.label.text = NSLocalizedString(@"Loading", str);
    HUD.label.textColor = [UIColor whiteColor];
    HUD.bezelView.color = [UIColor blackColor];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
       
        //do something in the background
        [self doSomework];
        
        //back to the main queue
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hideAnimated:YES];
        });
        
    });
}

- (void)HUDWithOnlyLabel:(UIView *)view withText:(NSString *)str;
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    HUD.backgroundColor = [UIColor blackColor];
    HUD.mode = MBProgressHUDModeText;
    HUD.label.text = str;
    HUD.label.textColor = [UIColor whiteColor];
    HUD.bezelView.color = [UIColor blackColor];
    
    [HUD hideAnimated:YES afterDelay:0.7f];//延迟3f后 执行
}

- (void)HUDWithOnlyLabel:(UIView *)view withText:(NSString *)str delay:(NSTimeInterval)delay{
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.mode = MBProgressHUDModeText;
    HUD.label.text = str;
    HUD.label.textColor = [UIColor whiteColor];
    HUD.bezelView.color = [UIColor blackColor];
    [HUD hideAnimated:YES afterDelay:delay];//延迟3f后 执行

    
}

- (void)doSomework
{
    sleep(2.);
}

- (MBProgressHUD *)HUDWithIndeterminateMode:(UIView *)view withText:(NSString *)text
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.label.text = text;
    HUD.label.textColor = [UIColor whiteColor];
    HUD.bezelView.color = [UIColor blackColor];
    return HUD;
}
- (void)hideHud:(MBProgressHUD *)hud;
{
    [hud setHidden:YES];
}
@end
