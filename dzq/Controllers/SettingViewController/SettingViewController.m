//
//  SettingViewController.m
//  dzq
//
//  Created by chentianyu on 16/1/24.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "SettingViewController.h"
#import <Masonry/Masonry.h>
#import "KSKRoundCornerCell.h"
#import "AppInfo.h"
#import "LoginViewController.h"
#import "FeedBackViewController.h"
#import "AboutViewController.h"
@interface SettingViewController ()
{
    UITableView *settingTableView;
    NSMutableArray *firstArray;
    NSMutableArray *secondArray;
    AppInfo *appInfo;
}

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"设置";
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    self.navigationController.navigationBar.barTintColor = ThemeColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil];
    self.view.backgroundColor = PC_Modal_Background_Color;
    
    appInfo = [AppInfo getInstance];
    if ([appInfo.token isEqualToString:@""] || appInfo.token == nil) {
        firstArray = [NSMutableArray arrayWithArray:@[@"登录"]];
    }else{
        firstArray = [NSMutableArray arrayWithArray:@[@"退出登录"]];
    }
    
    secondArray = [NSMutableArray arrayWithArray:@[@"当前版本",@"意见反馈",@"关于"]];
    
    [self addTableView];
    if([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)addTableView
{
    __weak typeof(self)weakself = self;
    settingTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    
    settingTableView.delegate = self;
    settingTableView.dataSource = self;
    settingTableView.backgroundColor = PC_Modal_Background_Color;
    settingTableView.tableFooterView = [UIView new];
    settingTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    settingTableView.separatorColor = PC_SeparatorLine_Color ;
    
    if ([settingTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [settingTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([settingTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [settingTableView setLayoutMargins:UIEdgeInsetsZero];
    }

    [self.view addSubview:settingTableView];
    
    [settingTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.view.mas_top).with.offset(0);
        make.left.equalTo(weakself.view.mas_left).with.offset(20);
        make.right.equalTo(weakself.view.mas_right).with.offset(-20);

        make.bottom.equalTo(weakself.view.mas_bottom).with.offset(0);
    }];

}
#pragma mark - tableView delegate

#pragma mark - tableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return firstArray.count;
    }else{
        return secondArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    KSKRoundCornerCell *cell = [KSKRoundCornerCell cellWithTableView:tableView style:UITableViewCellStyleDefault radius:10.0f indexPath:indexPath];
    if (indexPath.section == 0) {
        cell.textLabel.text = [firstArray objectAtIndex:indexPath.row];
    }
    if(indexPath.section == 1){
        cell.textLabel.text = [secondArray objectAtIndex:indexPath.row];
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:17.0f];
            AppInfo *info = [AppInfo getInstance];
            label.text = info.version;
            
            CGSize size = [label.text sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:17.0f] forKey:NSFontAttributeName]];
            label.frame = CGRectMake(0, 0, size.width, size.height);
            cell.accessoryView = label;
        }
    }
    cell.backgroundColor = [UIColor whiteColor];
  
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppInfo *info = [AppInfo getInstance];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if ([appInfo.token isEqualToString:@""] || appInfo.token == nil) {  //没有登录
                LoginViewController *login = [[LoginViewController alloc] init];
                
                login.view.backgroundColor = PC_Modal_Background_Color;
                
                [self.navigationController pushViewController:login animated:YES];
            }else{
                //退出登录
                UIAlertController * alter = [UIAlertController alertControllerWithTitle:@"退出" message:@"确定退出？" preferredStyle:(UIAlertControllerStyleAlert)] ;
                [alter addAction:[UIAlertAction actionWithTitle:@"返回" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    [alter dismissViewControllerAnimated:YES completion:nil];
                }]];
                [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    [self exit];
                }]];
                [self presentViewController:alter animated:YES completion:nil];
            }
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {   //意见反馈
            if ([[RegularJudge shareInstance] contentIsNil:info.token]) {
                [self baseHUDWithOnlyLabel:self.view withText:@"当前用户未登录,请登录"];
                return;
            }else{
                FeedBackViewController *feedBack = [[FeedBackViewController alloc] init];
                [self.navigationController pushViewController:feedBack animated:YES];
            }
            
        }else if (indexPath.row == 2){//关于
            AboutViewController *about = [[AboutViewController alloc] init];
            [self.navigationController pushViewController:about animated:YES];
        }
    }
}


//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}

- (void)exit
{
    
    [appInfo deleteUsernamewithPassword];
    appInfo.token = nil;
    appInfo.usermodel = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SetAvatarImage" object:nil];
    [self dismiss];
    
}
@end
