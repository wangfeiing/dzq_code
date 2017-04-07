//
//  BaseViewController.m
//  dzq
//
//  Created by chentianyu on 16/3/25.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "BaseViewController.h"

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = ThemeColor;
    
}


- (void)baseHUDWithOnlyLabel:(UIView *)view withText:(NSString *)str
{
    ProgressHUD *hud = [[ProgressHUD alloc] init];
    [hud HUDWithOnlyLabel:view withText:str];
}

- (void)baseHUDWithWindow:(UIView *)view withText:(NSString *)str
{
    ProgressHUD *hud = [[ProgressHUD alloc] init];
    
    [hud HUDWithOnlyLabel:self.view withText:str];
}
- (CGFloat)backNavHeight
{
    return self.navigationController.navigationBar.frame.size.height;
}

- (BOOL)shouldAutorotate
{
    return false;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}
@end
