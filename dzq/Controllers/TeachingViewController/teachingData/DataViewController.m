//
//  DataViewController.m
//  dzq
//
//  Created by chentianyu on 16/1/25.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "DataViewController.h"
#import "DataCollectionViewCell.h"
#import "DataCollectionHeaderView.h"
#import "SLViewController.h"

#define kCTY_dataCollectionCellHeight (SCREEN_WIDTH-DOCK_WIDTH)/2
@interface DataViewController ()
{
    NSMutableArray *_dataArray;
    
}

@end

@implementation DataViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self loadData];
    
//    [self initTableView];
//    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
    [self initCollectionView];
    
//    [self ]
    _dataArray  = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillPresent:) name:@"presentTeachDataView" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillPresent:(NSNotification *)notification
{
    [_dataArray removeAllObjects];
    RequestApi *request = [RequestApi shareInstance];
    [request teach_getDataWithURLString:TEACH_get_date method:GET success:^(id result) {

        if (request.msgCode == 1) {
            NSArray *array = [(NSDictionary *)result objectForKey:@"result"];
            for (int i = 0; i < array.count; i ++) {
                TeachingDataModel *modelArray =[TeachingDataModel modelWithDict:array[i]];
                [_dataArray addObject:modelArray];
            }

        }
        [self.teachCollectionView reloadData];

        
    } failure:^(NSString *message) {
        NSLog(@"%@",message);
    }];
    
}



- (void)initCollectionView
{
    AppInfo *info = [AppInfo getInstance];

    CGFloat navHeight = info.theNavHeight;
//    self
    CGRect collectionViewFrame = CGRectMake(0, navHeight-STATUS_HEIGTH, SCREEN_WIDTH-DOCK_WIDTH, SCREEN_HEIGHT-navHeight);
    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
//    collectionViewLayout.minimumLineSpacing = 30;
    self.teachCollectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:collectionViewLayout];
    self.teachCollectionView.delegate = self;
    self.teachCollectionView.dataSource = self;
    self.teachCollectionView.backgroundColor = RGBA(239, 239, 239, 1);
    
    [self.teachCollectionView registerNib:[UINib nibWithNibName:@"DataCollectionHeaderView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"teach_data_header_view"];
    [self.teachCollectionView registerClass:[DataCollectionViewCell class] forCellWithReuseIdentifier:@"teach_data_cell"];
    [self.view addSubview:self.teachCollectionView];
}
#pragma mark- collection view delegate

//返回这个collectionView是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    
    
    NSString *title = [(TeachingDataModel *)[_dataArray objectAtIndex:indexPath.row] title];
    NSString *content = [(TeachingDataModel *)[_dataArray objectAtIndex:indexPath.row] content];
    DataDetailViewController *dataDetailViewController = [[DataDetailViewController alloc] initWithDataTitle:title dataContent:content];
    
    dataDetailViewController.view.backgroundColor = [UIColor whiteColor];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dataDetailViewController];
    nav.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentViewController:nav animated:YES completion:^{
    }];

}
//添加头部视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *resuableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        DataCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"teach_data_header_view" forIndexPath:indexPath];
        resuableView = headerView;
    }
    return resuableView;
}


#pragma mark - collection view data_source
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    DataCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"teach_data_cell" forIndexPath:indexPath];
    if (_dataArray.count == 0) {
        
    }else{
        TeachingDataModel *model = (TeachingDataModel *)[_dataArray objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"teaching_book"];
        cell.titleLabel.text = model.title;
//        cell.subTitleLabel.text = model.content;
    }
    

    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark - collection view Flow Layout
//每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kCTY_dataCollectionCellHeight-20, 90);
}
//定义每个item的margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 40;
}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    
//}
//设置头部视图的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = {collectionView.frame.size.width,111};
    return size;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    
//}

//- (void)initTableView
//{
//    CGFloat navHeight = self.navigationController.navigationBar.frame.size.height;
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_HEIGTH+navHeight,SCREEN_WIDTH-DOCK_WIDTH, SCREEN_HEIGHT-STATUS_HEIGTH-navHeight) style:UITableViewStyleGrouped];
//    
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
//    [self.tableView registerNib:[UINib nibWithNibName:@"TeachDataCell" bundle:nil] forCellReuseIdentifier:@"TeachDataCell"];
//    self.tableView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.tableView];
//}
//
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return  _dataArray.count;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellIdentifier = @"cell";
//    TeachDataCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (tableViewCell == nil) {
//
//        tableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"TeachDataCell" owner:self options:nil ] lastObject];
//    }
//    
//    tableViewCell.titleLabel.text = [(TeachingDataModel *)[_dataArray objectAtIndex:indexPath.row] title];
////    tableViewCell.titleLabel.text = [[self.dataList objectAtIndex:indexPath.row] title];
//    [tableViewCell setNeedsDisplay];
//    return tableViewCell;
//
//}
//
//
//
//
////点击单元格
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//
//}
//
////自定义头部视图
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
// 
//    TeachTitleView *titleView = [[[NSBundle mainBundle] loadNibNamed:@"TeachTitleView" owner:self options:nil] lastObject];
//    return titleView;
//    
//}
//
////自定义头高度
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 111;
//}



@end
