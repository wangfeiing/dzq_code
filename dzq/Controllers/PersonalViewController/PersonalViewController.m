//
//  PersonalViewController.m
//  dzq
//
//  Created by chentianyu on 16/1/24.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "PersonalViewController.h"


@interface PersonalViewController ()
{
//    UISplitViewController *split;
}
@property(nonatomic,strong)UISplitViewController *split;
@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"个人中心";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    
    
//    PVHeaderView *headerView = [[PVHeaderView alloc] initWithFrame:CGRectMake(0, [self heightForStatusBarWithNavBar], SCREEN_WIDTH-DOCK_WIDTH, 50)];
//    headerView.delegate = self;
//    [self.view addSubview:headerView];
    
    [self addSplitController];
    
    
}



- (void)addSplitController
{
   self.split   = [[UISplitViewController alloc] init];

    
    PersonalMasterViewController *master = [[PersonalMasterViewController alloc] init];
    PersonalDetailViewController *detail = [[PersonalDetailViewController alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:detail];
    
    self.split.viewControllers = [NSArray arrayWithObjects:master,detail, nil];
    UIEdgeInsets margin = UIEdgeInsetsMake([self heightForStatusBarWithNavBar], 0, 0, 0);
    
    [self.view addSubview:self.split.view];
    [self.split.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(margin);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)heightForStatusBarWithNavBar
{
    
    return [[UIApplication sharedApplication] statusBarFrame].size.height+self.navigationController.navigationBar.frame.size.height;
}

- (void)clickLoginButton:(UIButton *)button
{
    LoginViewController *loginViewController = [[LoginViewController alloc] initwithContent:@"aa"];
    loginViewController.view.backgroundColor = PC_Modal_Background_Color;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    nav.navigationBar.barTintColor = ThemeColor;
    nav.navigationBar.tintColor = [UIColor whiteColor];
    nav.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:nav animated:YES completion:^{
        
    }];
    
 }
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)login:(UIButton *)sender
{
    NSString *username = @"123456";
    NSString *password = @"123456";
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:username,@"username",password,@"password", nil];
    RequestApi *request = [RequestApi shareInstance];
    [request userLoginWithApi:Public_User_Login method:POST parameters:dict successBlock:^(NSDictionary* result) {
        if (request.msgCode == 0) {
            UserModel *model = [[UserModel alloc] init];
            [model initWithToken:[result objectForKey:@"detail"]];
            NSLog(@"用户token:%@",model.token);
        }
    } failureBlock:^(NSString *message) {
        NSLog(@"%@",message.description);
    }];

}

@end
