//
//  LoginViewController.m
//  dzq
//
//  Created by chentianyu on 16/3/24.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgetPwdViewController.h"
#import "RegistViewController.h"
#import "UIColor+Hex.h"
#import "RegularJudge.h"


@interface LoginViewController ()
{
    UITextField *usernameField ;
    UITextField *pwdField;
    
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.title = @"登录";
//    UINavigationItem *back = [UINavigationItem alloc]
//    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(loginBack)];
//    self.navigationItem.leftBarButtonItem = back;

    
    [self addSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)loginBack//:(UIBarButtonItem *)barButtonItem
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self baseHUDWithOnlyLabel: [[UIApplication sharedApplication] keyWindow] withText:@"登录成功"];
    }];
}

- (id)initwithContent:(NSString *)str
{
    NSLog(@"---");
    return self;
}

- (void)addSubViews
{
    __weak typeof(self)weakself = self;//防止block的循环引用
    

    
    UIView *loginSubview = [[UIView alloc] init];
    loginSubview.layer.cornerRadius = 5.0f;
    loginSubview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:loginSubview];
    
    [loginSubview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.width.offset(20);
        
        make.top.equalTo(weakself.view).with.offset(20);
        make.left.equalTo(weakself.view).with.offset(20);
        make.right.equalTo(weakself.view).with.offset(-20);
        make.height.mas_equalTo(@101);
    }];
    
    //用户名
    usernameField = [[UITextField alloc] init];
    usernameField.placeholder = @"用户名";
    usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [loginSubview addSubview:usernameField];
    [usernameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginSubview.mas_top).with.offset(0);
        make.height.mas_equalTo(@50);
        make.left.equalTo(loginSubview.mas_left).with.offset(5);
        make.right.equalTo(loginSubview.mas_right).with.offset(-5);
        
    }];
    
    UILabel *separatorLine = [[UILabel alloc] init];
    separatorLine.backgroundColor = PC_SeparatorLine_Color;
    [loginSubview addSubview:separatorLine];
    [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(usernameField.mas_bottom).with.offset(0);
        make.height.mas_equalTo(@1);
        make.right.equalTo(loginSubview.mas_right).with.offset(0);
        make.left.equalTo(loginSubview.mas_left).with.offset(0);
    }];
    
    //密码
    pwdField = [[UITextField alloc] init];
    pwdField.placeholder = @"密码";
    pwdField.secureTextEntry = YES;
    pwdField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [loginSubview addSubview:pwdField];
    [pwdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(separatorLine.mas_bottom).with.offset(0);
        make.left.equalTo(loginSubview.mas_left).with.offset(5);
        make.right.equalTo(loginSubview.mas_right).with.offset(-5);
        make.height.equalTo(@50);
        
    }];
    
//
//    
//    
    //登录按钮
    UIButton *loginButton = [[UIButton alloc] init];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setBackgroundColor:ThemeColor];
    [loginButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    loginButton.layer.cornerRadius = 5.0f;
    [self.view addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@50);
        make.top.equalTo(loginSubview.mas_bottom).with.offset(20);
        make.left.equalTo(loginSubview.mas_left).with.offset(0);
        make.right.equalTo(loginSubview.mas_right).with.offset(0);
    }];

//
    //忘记密码
    UIButton *forgetpwd = [[UIButton alloc] init];
    [forgetpwd setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetpwd setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [forgetpwd.titleLabel setTextAlignment: NSTextAlignmentLeft];
    [forgetpwd.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    
    [forgetpwd addTarget:self action:@selector(forgetPwd:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:forgetpwd];
    [forgetpwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@30);
        make.width.mas_equalTo(@100);
        make.left.equalTo(loginButton.mas_left).with.offset(0);
        make.top.equalTo(loginButton.mas_bottom).with.offset(20);
    }];
    [forgetpwd setTitleEdgeInsets:UIEdgeInsetsMake(0, -35, 0, 0) ];
    
    //注册
    UIButton *registButton = [[UIButton alloc] init];
    [registButton setTitle:@"注册" forState:UIControlStateNormal];
    [registButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [registButton.titleLabel setTextAlignment: NSTextAlignmentRight];
    [registButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [registButton addTarget:self action:@selector(regist:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:registButton];
    [registButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@30);
        make.width.mas_equalTo(@100);
        make.right.equalTo(loginButton.mas_right).with.offset(0);
        make.centerY.equalTo(forgetpwd.mas_centerY).with.offset(0);
    }];
    
    [registButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -60) ];
}

- (void)login:(UIButton *)loginButton
{
    /*
     用户名判断
     1.不能为空
     2.手机号
     */
    NSString *username = usernameField.text;
    if ([username isEqualToString:@""]) {
        [self baseHUDWithOnlyLabel:self.navigationController.view withText:@"手机号不能为空"];
        [usernameField becomeFirstResponder];
        return;
    }
    

    if (![[RegularJudge shareInstance] matchMobilephoneNumber:username]) {
        [self baseHUDWithOnlyLabel:self.navigationController.view withText:@"请输入正确的手机号"];
        [usernameField becomeFirstResponder];
        return;
    }


    /*密码判断
     1.不能为空
     2.6~18位的字母混合
     */
    NSString *passwd = pwdField.text;
    if ([passwd isEqualToString:@""]) {
        [self baseHUDWithOnlyLabel:self.navigationController.view withText:@"密码不能为空"];
        [pwdField becomeFirstResponder];
        return;
    }
    if (![[RegularJudge shareInstance] matchPassword:passwd]) {
        [self baseHUDWithOnlyLabel:self.navigationController.view withText:@"请输入正确的密码"];
        [pwdField becomeFirstResponder];
        return;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:username,@"account",passwd,@"password", nil];
    RequestApi *request = [RequestApi shareInstance];
    AppInfo *info = [AppInfo getInstance];
    [request userLoginWithApi:Public_User_Login method:GET parameters:dic successBlock:^(id result) {
        if (request.msgCode==1) {   //登录成功
            UserModel *model = [[UserModel alloc] initWithDic:result];
            [self loginBack];

            
            [info setUsermodel:model];
            [info setToken:model.token];
            [info saveUsername:username withPassword:passwd];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SetAvatarImage" object:nil];
            
        }else if(request.msgCode == 0){ //
            [self baseHUDWithOnlyLabel:self.navigationController.view withText:@"密码有误"];
            [self clearPwd];
            [info deleteUsernamewithPassword];
        }else if(request.msgCode == 2){
            [self baseHUDWithOnlyLabel:self.navigationController.view withText:@"该用户不存在，请先注册"];
            [self clearMobilephoneAndPwd];
            [info deleteUsernamewithPassword];
        }
    } failureBlock:^(NSString *message) {
        [self baseHUDWithOnlyLabel:self.navigationController.view withText:@"登录错误"];
        [info deleteUsernamewithPassword];
    }];
    
}

- (void)forgetPwd:(UIButton *)forgetpwd
{
    ForgetPwdViewController *forget = [[ForgetPwdViewController alloc] init];
    
    forget.view.backgroundColor = [UIColor  colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0f];
    [self.navigationController pushViewController:forget animated:YES];
}
- (void)regist:(UIButton *)registButton
{
    RegistViewController *regist = [[RegistViewController alloc] init];
    regist.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0f];
    [self.navigationController pushViewController:regist animated:YES];
}

#pragma mark - 重置用户名和密码
- (void)clearPwd
{
    pwdField.text = @"";
    [pwdField becomeFirstResponder];
    return;
}
- (void)clearMobilephoneAndPwd
{
    usernameField.text = @"";
    pwdField.text = @"";
    [usernameField becomeFirstResponder];
    return;
}

@end
