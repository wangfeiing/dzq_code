//
//  PersonalPracticeViewController.m
//  dzq
//
//  Created by chentianyu on 16/4/13.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "PersonalPracticeViewController.h"

@interface PersonalPracticeViewController ()
@property(nonatomic,strong)UITableView *pc_practice_tableView;

@end

@implementation PersonalPracticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addSubTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addSubTableView
{
    self.pc_practice_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//    self.pc_practice_tableView.
    [self.view addSubview:self.pc_practice_tableView];
    self.pc_practice_tableView.delegate = self;
    self.pc_practice_tableView.dataSource = self;
    [self.pc_practice_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
    }];
    self.pc_practice_tableView.backgroundColor = [UIColor whiteColor];
    self.pc_practice_tableView.tableFooterView = [UIView new];
    [self.pc_practice_tableView registerClass:[PersonalPracticeTableViewCell class] forCellReuseIdentifier:@"pc_practice_cell"];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonalPracticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pc_practice_cell" forIndexPath:indexPath];
    cell.rightRateLabel.text = @"60%";
    cell.practiceTimeLabel.text = @"2016/2/3";
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    headerView.backgroundColor = RGBA(239, 239, 239, 1);
    
    UILabel *practiceTimeLabel = [[UILabel alloc] init];
    [headerView addSubview:practiceTimeLabel];
    practiceTimeLabel.text = @"练习时间";
//    practiceTimeLabel
    CGSize practiceTimeLabelSize = [practiceTimeLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:20] forKey:NSFontAttributeName]];
    [practiceTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView.mas_centerY).with.offset(0);
        make.left.equalTo(headerView.mas_left).with.offset(30);
        make.width.mas_equalTo(practiceTimeLabelSize.width);
    }];
    
    //正确率
    UILabel *rightRateLabel = [[UILabel alloc] init];
    [headerView addSubview:rightRateLabel];
    rightRateLabel.text = @"正确率";
    //    practiceTimeLabel
    CGSize rightRateLabelSize = [rightRateLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:20] forKey:NSFontAttributeName]];
    [rightRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView.mas_centerY).with.offset(0);
        make.right.equalTo(headerView.mas_right).with.offset(-30);
        make.width.mas_equalTo(rightRateLabelSize.width);
    }];
    
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
@end
