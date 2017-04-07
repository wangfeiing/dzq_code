//
//  FeedBackViewController.m
//  dzq
//
//  Created by chentianyu on 16/4/3.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "FeedBackViewController.h"
#import <Masonry/Masonry.h>
#import "FeedBackTextView.h"

@interface FeedBackViewController ()
{
    FeedBackTextView *_textView;
}

@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = PC_Modal_Background_Color;
    [self addControls];
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

- (void)addControls
{
    
    __weak typeof(self) weakSelf = self;
    
    _textView = [[FeedBackTextView alloc] init];
    [self.view addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).with.offset(20);
        make.left.equalTo(weakSelf.view).with.offset(20);
        make.right.equalTo(weakSelf.view).with.offset(-20);
        make.height.mas_equalTo(@150);
    }];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:ThemeColor];
    [button setTitle:@"发表" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(commitFeedBack:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 5.0f;
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_textView.mas_bottom).with.offset(20);
        make.left.mas_equalTo(_textView.mas_left).with.offset(0);
        make.right.mas_equalTo(_textView.mas_right).with.offset(0);
        make.height.equalTo(@50);
    }];
    
    
}

#pragma mark - 发表反馈
- (void)commitFeedBack:(UIButton *)button
{
    RequestApi *request = [RequestApi shareInstance];
    AppInfo *info = [AppInfo getInstance];
    NSString *userToken = info.token;
    RegularJudge *regular = [RegularJudge shareInstance];
    if ([regular contentIsNil:_textView.text]) {
        [self baseHUDWithOnlyLabel:self.view withText:@"内容不能为空"];
        [_textView becomeFirstResponder];
        return;
    }
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:userToken,@"token",_textView.text,@"content", nil];
    
    [request user_feedbackInfoWithURLString:USER_feedback method:POST parameters:dic successBlock:^(id result) {
        if (request.msgCode==1) {
            [self baseHUDWithOnlyLabel:self.view withText:@"反馈成功"];
            _textView.text = @"";
            [_textView becomeFirstResponder];
        }else if(request.msgCode == 0){
            [self baseHUDWithOnlyLabel:self.view withText:@"反馈失败，请稍后再试"];
        }
        
    } failureBlock:^(NSString *message) {
        [self baseHUDWithOnlyLabel:self.view withText:message];
    }];
}
@end
