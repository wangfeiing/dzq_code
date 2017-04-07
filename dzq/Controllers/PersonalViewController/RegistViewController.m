//
//  RegistViewController.m
//  dzq
//
//  Created by chentianyu on 16/3/24.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "RegistViewController.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
#import "RegularJudge.h"
#import <SMS_SDK/SMSSDK.h>
@interface RegistViewController ()
{
    UITextField *usernameField;
    UITextField *verifyCodeField;
    UITextField *pwdField ;
}

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.title = @"注册";
    [self addFrames];
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
 - (void)addFrames
{
    __weak typeof(self)weakself = self;
    UIView *forgetSubview = [[UIView alloc] init];
    forgetSubview.layer.cornerRadius = 5.0f;
    forgetSubview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:forgetSubview];
    
    [forgetSubview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.view).with.offset(20);
        make.left.equalTo(weakself.view).with.offset(20);
        make.right.equalTo(weakself.view).with.offset(-20);
        make.height.mas_equalTo(@152);
    }];
    
    //用户名
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.text = @"手机号";
    phoneLabel.textColor = [UIColor colorWithHexString:@"FF545454"];
    
    phoneLabel.font = [UIFont systemFontOfSize:18.0];
    [forgetSubview addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(forgetSubview.mas_left).with.offset(5);
        make.width.mas_equalTo(@80);
    }];
    
    usernameField = [[UITextField alloc] init];
    usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [forgetSubview addSubview:usernameField];
    [usernameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(forgetSubview.mas_top).with.offset(0);
        make.height.mas_equalTo(@50);
        make.left.equalTo(phoneLabel.mas_right).with.offset(0);
        make.right.equalTo(forgetSubview.mas_right).with.offset(0);
    }];
    
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(usernameField.mas_centerY).with.offset(0);
    }];
    
    //分割线
    UILabel *firstSeparatorLine = [[UILabel alloc] init];
    firstSeparatorLine.backgroundColor = PC_SeparatorLine_Color;
    [forgetSubview addSubview:firstSeparatorLine];
    [firstSeparatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(usernameField.mas_bottom).with.offset(0);
        make.height.mas_equalTo(@1);
        make.right.equalTo(forgetSubview.mas_right).with.offset(0);
        make.left.equalTo(forgetSubview.mas_left).with.offset(0);
    }];
    
    //验证码
    UILabel *verifyCodeLabel = [[UILabel alloc] init];
    verifyCodeLabel.text = @"验证码";
    verifyCodeLabel.textColor = [UIColor colorWithHexString:@"FF545454"];
    [forgetSubview addSubview:verifyCodeLabel];
    [verifyCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(forgetSubview.mas_left).with.offset(5);
        make.width.mas_equalTo(@80);
    }];
    //
    UIButton *getVerifyCodeButton = [[UIButton alloc] init];
    [getVerifyCodeButton setTitle:@"获取" forState:UIControlStateNormal];
    getVerifyCodeButton.layer.cornerRadius = 3.0f;
    [getVerifyCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    getVerifyCodeButton.backgroundColor = PC_Get_Code_Color;
    [getVerifyCodeButton addTarget:self action:@selector(getVerifyCode:) forControlEvents:UIControlEventTouchUpInside];
    [forgetSubview addSubview:getVerifyCodeButton];
    
    [getVerifyCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@100);
        make.right.equalTo(forgetSubview.mas_right).with.offset(-5);
    }];
    //
    verifyCodeField = [[UITextField alloc] init];
    [forgetSubview addSubview:verifyCodeField];
    [verifyCodeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstSeparatorLine.mas_bottom).with.offset(0);
        make.left.equalTo(verifyCodeLabel.mas_right).with.offset(0);
        make.right.equalTo(getVerifyCodeButton.mas_left).with.offset(0);
        make.height.mas_equalTo(@50);
    }];
    
    [verifyCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(verifyCodeField.mas_centerY).with.offset(0);
    }];
    [getVerifyCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(verifyCodeField.mas_centerY).with.offset(0);
    }];
    
    
    
    //分割线
    UILabel *secondSeparatorLine = [[UILabel alloc] init];
    secondSeparatorLine.backgroundColor = PC_SeparatorLine_Color;
    [forgetSubview addSubview:secondSeparatorLine];
    [secondSeparatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(verifyCodeField.mas_bottom).with.offset(0);
        make.height.mas_equalTo(@1);
        make.right.equalTo(forgetSubview.mas_right).with.offset(0);
        make.left.equalTo(forgetSubview.mas_left).with.offset(0);
    }];
    //
    //新密码
    UILabel *pwdLabel = [[UILabel alloc] init];
    pwdLabel.text = @"密   码";
    pwdLabel.textColor = [UIColor colorWithHexString:@"FF545454"];
    [forgetSubview addSubview:pwdLabel];
    [pwdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(forgetSubview.mas_left).with.offset(5);
        make.width.mas_equalTo(@80);
    }];
    //
    pwdField = [[UITextField alloc] init];
    pwdField.secureTextEntry = YES;
    pwdField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [forgetSubview addSubview:pwdField];
    [pwdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secondSeparatorLine.mas_bottom).with.offset(0);
        make.height.mas_equalTo(@50);
        make.left.equalTo(pwdLabel.mas_right).with.offset(0);
        make.right.equalTo(forgetSubview.mas_right).with.offset(0);
    }];
    
    [pwdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(pwdField.mas_centerY).with.offset(0);
    }];
    
    //重置密码
    UIButton *registButton = [[UIButton alloc] init];
    [registButton setTitle:@"注册" forState:UIControlStateNormal];
    [registButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registButton setBackgroundColor:ThemeColor];
    [registButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [registButton addTarget:self action:@selector(regist:) forControlEvents:UIControlEventTouchUpInside];
    registButton.layer.cornerRadius = 5.0f;
    [self.view addSubview:registButton];
    [registButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@50);
        make.top.equalTo(forgetSubview.mas_bottom).with.offset(20);
        make.left.equalTo(forgetSubview.mas_left).with.offset(0);
        make.right.equalTo(forgetSubview.mas_right).with.offset(0);
    }];
}

#pragma mark - 重置密码
- (void)regist:(UIButton *)button
{
    NSString *phoneStr = usernameField.text;
    if ([phoneStr isEqualToString:@""]) {
        [self baseHUDWithOnlyLabel:self.navigationController.view withText:@"手机号不能为空"];
        [usernameField becomeFirstResponder];
        return;
    }
    if (![[RegularJudge shareInstance] matchMobilephoneNumber:phoneStr]) {
        [self baseHUDWithOnlyLabel:self.navigationController.view withText:@"请输入手机号"];
        [usernameField becomeFirstResponder];
        return;
    }
    
//    NSString *verifyStr = verifyCodeField.text;
//    if ([verifyStr isEqualToString:@""]) {
//        [self baseHUDWithOnlyLabel:self.navigationController.view withText:@"请输入验证码"];
//        [verifyCodeField becomeFirstResponder];
//        return;
//    }
//    [SMSSDK commitVerificationCode:verifyStr phoneNumber:phoneStr zone:@"86" result:^(NSError *error) {
//        
//        if (error != nil) {
//            [self baseHUDWithOnlyLabel:self.navigationController.view withText:@"请输入正确的验证码"];
//            verifyCodeField.text = @"";
//            [verifyCodeField becomeFirstResponder];
//            return ;
//        }
//    }];
    
    NSString *pwdStr = pwdField.text;
    if ([pwdStr isEqualToString:@""]) {
        [self baseHUDWithOnlyLabel:self.navigationController.view withText:@"新密码不能为空"];
        [pwdField becomeFirstResponder];
        return;
    }
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:phoneStr,@"account",pwdStr,@"password", nil];
    RequestApi *request = [RequestApi shareInstance];
    
    [request HTTPRequestWithURLString:Public_user_regist params:params HTTPMethod:POST success:^(id result) {
        if (request.msgCode == 1) {
            [self baseHUDWithOnlyLabel:self.navigationController.view withText:@"注册成功,请登录"];
            [self navBack];
        }else if (request.msgCode == 2){
            [self baseHUDWithOnlyLabel:self.navigationController.view withText:@"该用户已存在"];
            [self clearAllField];
        }else if (request.msgCode == 0){
            [self baseHUDWithOnlyLabel:self.navigationController.view withText:@"服务器异常"];
        }
        
    } failure:^(NSString *message) {
        [self baseHUDWithOnlyLabel:self.navigationController.view withText:@"请联系管理员"];
    }];
}

#pragma mark - 得到验证码
- (void)getVerifyCode:(UIButton *)button
{
    NSString *phone = usernameField.text;
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phone zone:@"86" customIdentifier:nil result:^(NSError *error) {
        NSLog(@"code:%ld,domain:%@,userInfo:%@",(long)error.code,error.domain,error.userInfo);
        if(error == nil){
            [self baseHUDWithOnlyLabel:self.navigationController.view withText:@"验证码发送成功"];
        }else{
            [self baseHUDWithOnlyLabel:self.navigationController.view withText:[error.userInfo objectForKey:@"getVerificationCode"]];
        }
    }];
}


- (void)navBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)clearAllField
{
    usernameField.text = @"";
    verifyCodeField.text = @"";
    pwdField.text = @"";
}
@end
