//
//  PersonalDetailViewController.m
//  dzq
//
//  Created by chentianyu on 16/4/12.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "PersonalDetailViewController.h"

@interface PersonalDetailViewController ()
{
    AppInfo *appInfo;
}
@property(nonatomic,strong)NSArray *detailViewControllers;

@end

@implementation PersonalDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBA(239, 239, 239, 1);
    
    
    self.personalInfo = [[PersonalInfoViewController alloc] init];
    self.personalCollect = [[PersonalCollectViewController alloc] init];
    self.personalViewer = [[PersonalViewerViewController alloc] init];
    self.personalPractice = [[PersonalPracticeViewController alloc] init];
    
    appInfo = [AppInfo getInstance];
    if([[RegularJudge shareInstance] contentIsNil:appInfo.token]){
//        appInfo = []
        [self.view addSubview:[UIView new]];
//        [self baseHUDWithOnlyLabel:self.view.window withText:@"当前用户未登录"];
    }else{
        [self.view addSubview:self.personalInfo.view];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addControllers
{

//    self.detailViewControllers = [[NSArray alloc] initWithObjects:personalInfo,personalCollect,personalViewer,personalPractice, nil];
    
}
- (BOOL)shouldAutorotate
{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
//- (void)setChildViewController
//{
//    if ([self.personalIndex isEqualToString:@"0"]) {
//        
////        self.personalInfo = [[PersonalInfoViewController alloc] init];
//        [self addChildViewController:self.personalInfo];
//        [self.view addSubview:self.personalInfo.view];
//    }else if([self.personalIndex isEqualToString:@"1"]){
//
//        [self addChildViewController:self.personalCollect];
//        [self.view addSubview:self.personalCollect.view];
//    }else if([self.personalIndex isEqualToString:@"2"]){
//
//        [self addChildViewController:self.personalViewer];
//        [self.view addSubview:self.personalViewer.view];
//    }else if([self.personalIndex isEqualToString:@"3"]){
//
//        [self addChildViewController:self.personalPractice];
//        [self.view addSubview:self.personalPractice.view];
//    }
//        
//}


- (void)updateView:(NSInteger)row
{
    if (row == 0) {//个人信息
        if (self.personalCollect.view.superview) {
            [self.personalCollect.view removeFromSuperview];
        }
        if (self.personalViewer.view.superview) {
            [self.personalViewer.view removeFromSuperview];
        }
        if (self.personalPractice.view.superview) {
            [self.personalPractice.view removeFromSuperview];
        }
        if (self.personalInfo.view.superview == nil) {
            appInfo = [AppInfo getInstance];
            if ([[RegularJudge shareInstance] contentIsNil:appInfo.token]) {
                [self baseHUDWithOnlyLabel:self.view.window withText:@"当前用户未登录"];
            }else{
                [self.view addSubview:self.personalInfo.view];
                [self.personalInfo.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
                }];
            }
            
        }
        
    }else if(row == 1){ //收藏
        if (self.personalInfo.view.superview) {
            [self.personalInfo.view removeFromSuperview];
        }
        if (self.personalViewer.view.superview) {
            [self.personalViewer.view removeFromSuperview];
        }
        if (self.personalPractice.view.superview) {
            [self.personalPractice.view removeFromSuperview];
        }
        if (self.personalCollect.view.superview == nil) {
            appInfo = [AppInfo getInstance];
            if ([[RegularJudge shareInstance] contentIsNil:appInfo.token]) {
                [self baseHUDWithOnlyLabel:self.view.window withText:@"当前用户未登录"];
            }else{
                [self.view addSubview:self.personalCollect.view];
                [self.personalCollect.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
                }];
            }
            
        }
        
    }else if(row == 2){ //浏览记录
        if (self.personalInfo.view.superview) {
            [self.personalInfo.view removeFromSuperview];
        }
        if (self.personalViewer.view.superview ==nil) {
            [self.view addSubview:self.personalViewer.view];
        }
        if (self.personalPractice.view.superview) {
            [self.personalPractice.view removeFromSuperview];
        }
        if (self.personalCollect.view.superview) {
            [self.personalCollect.view removeFromSuperview];
        }
        [self.personalViewer.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
        }];
    }else if(row == 3){ //练习记录
        if (self.personalInfo.view.superview) {
            [self.personalInfo.view removeFromSuperview];
        }
        if (self.personalCollect.view.superview) {
            [self.personalCollect.view removeFromSuperview];
        }
        if (self.personalViewer.view.superview) {
            [self.personalViewer.view removeFromSuperview];
        }
        if (self.personalPractice.view.superview == nil) {
            [self.view addSubview:self.personalPractice.view];
        }
        [self.personalPractice.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
        }];
    }
        
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
