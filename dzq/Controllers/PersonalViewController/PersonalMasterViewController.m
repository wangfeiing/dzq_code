//
//  PersonalMasterViewController.m
//  dzq
//
//  Created by chentianyu on 16/4/12.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "PersonalMasterViewController.h"
#import "PersonalMasterTableViewCell.h"

#define kTitleTextKey   @"title"
#define kTitleIconKey  @"icon"
@interface PersonalMasterViewController ()
{
    UITableView *masterTableView;
    NSMutableArray *titleArray;

}
@property(nonatomic,strong)PersonalInfoViewController *personalInfo;
@property(nonatomic,strong)PersonalCollectViewController *personalCollect;
@property(nonatomic,strong)PersonalViewerViewController *personalViewer;
@property(nonatomic,strong)PersonalPracticeViewController *personalPractice;

@end


@implementation PersonalMasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    

    
    titleArray = [[NSMutableArray alloc] initWithObjects:
                  [NSDictionary dictionaryWithObjectsAndKeys:@"个人资料",kTitleTextKey,@"personal_profile",kTitleIconKey ,nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"我的收藏",kTitleTextKey,@"personal_collect",kTitleIconKey ,nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"浏览记录",kTitleTextKey,@"personal_viewer",kTitleIconKey ,nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"练习记录",kTitleTextKey,@"personal_practice",kTitleIconKey ,nil],nil];
    
    [self addTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addTableView
{
    __weak typeof(self) weakSelf= self;
    masterTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    [self.view addSubview:masterTableView];
    [masterTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).with.insets(UIEdgeInsetsZero);
    }];
    masterTableView.delegate = self;
    masterTableView.dataSource = self;
    masterTableView.tableFooterView = [UIView new];
    [masterTableView registerClass:[PersonalMasterTableViewCell class] forCellReuseIdentifier:@"cell"];
    

    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PersonalMasterTableViewCell *cell = (PersonalMasterTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    cell.titleIconImageView.image = [UIImage imageNamed:[[titleArray objectAtIndex:indexPath.row] objectForKey:kTitleIconKey]];
    if (indexPath.row == 1) {
        cell.selected = YES;
    }
    cell.titleTextLabel.text = [[titleArray objectAtIndex:indexPath.row] objectForKey:kTitleTextKey];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonalDetailViewController * detailViewController = [self.splitViewController.viewControllers lastObject];
    [detailViewController updateView:indexPath.row];
//    if (indexPath.row == 0) {
//        
//        self.personalInfo = (PersonalInfoViewController *)[self.splitViewController.viewControllers lastObject];//= [[PersonalInfoViewController alloc] init];
//        
////        [detailViewController addChildViewController:self.personalInfo];
////        [detailViewController.view addSubview:self.personalInfo.view];
//    }else if(indexPath.row == 1){
//        self.personalCollect = (PersonalCollectViewController *)[self.splitViewController.viewControllers lastObject];
////        self.personalCollect = [[PersonalCollectViewController alloc] init];
////        [detailViewController addChildViewController:self.personalCollect];
////        [detailViewController.view addSubview:self.personalCollect.view];
//    }else if(indexPath.row == 2){
//        self.personalViewer = [[PersonalViewerViewController alloc] init];
//        [detailViewController addChildViewController:self.personalViewer];
//        [detailViewController.view addSubview:self.personalViewer.view];
//    }else if(indexPath.row == 3){
//        self.personalPractice = [[PersonalPracticeViewController alloc] init];
//        [detailViewController addChildViewController:self.personalPractice];
//        [detailViewController.view addSubview:self.personalPractice.view];
//    }
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
