//
//  PersonalCollectViewController.m
//  dzq
//
//  Created by chentianyu on 16/4/13.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "PersonalCollectViewController.h"

#define SLCTHeaderViewHeight 55
#define kSLCTNumberOfPage 10
@interface PersonalCollectViewController ()
{
    
    UICollectionView *pc_collect_CollectionView;
    NSMutableArray *listArray;
    
    UILabel *label;
    
    
    NSInteger isUpOrDown;//0是下拉，1是上拉
    
    NSUInteger page;
    
//    NSMutableArray *collectArray;
}



@end


@implementation PersonalCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 50)];
//    label.text = @"我的收藏";
//    [self.view addSubview:label];
    self.view.backgroundColor = RGBA(239, 239,239,1);
    [self addSubCollectionView];

    pc_collect_CollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //
        
        isUpOrDown = 0;
        [self sentRequestWithOrderType];
    }];
    pc_collect_CollectionView.mj_header.automaticallyChangeAlpha = YES;
    [pc_collect_CollectionView.mj_header beginRefreshing];//马上进入刷新状态
    
    pc_collect_CollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        isUpOrDown = 1;
        [self sentRequestWithOrderType];
    }];
    
    //设置底部的inset
    pc_collect_CollectionView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    //忽略了底部inset
    pc_collect_CollectionView.mj_footer.ignoredScrollViewContentInsetBottom = 30;
    
    
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//判断某首曲子是否收藏
- (BOOL)isCollect:(NSInteger)m_id
{
    for (CollectModel *model in listArray) {
        if (m_id==model.music_id) {
            return true;
        }
    }
    return false;
}

- (void)sentRequestWithOrderType
{
    
    AppInfo *info = [AppInfo getInstance];
    if ([[RegularJudge shareInstance] contentIsNil:info.token]) {
        [self baseHUDWithOnlyLabel:self.view withText:@"当前用户未登录"];
    }else{
        
        
    }
    RequestApi *request = [RequestApi shareInstance];
    
    
    
    
    
    
    
    if(isUpOrDown == 0){//下拉刷新
        //指定page为1
        page = 1;
        NSString *firstPage = [NSString stringWithFormat:@"%lu",(unsigned long)page];
        NSString *numberOfPange = [NSString stringWithFormat:@"%d",kSLCTNumberOfPage];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             info.token,@"token",
                             firstPage,@"page",
                             numberOfPange,@"list_rows",
                             @"0",@"m_type",nil];
        
        
        //
        listArray = [[NSMutableArray alloc] init];
        [listArray removeAllObjects];
        [request user_collectWithURLString:USER_user_collect method:POST parameters:dic successBlock:^(id result) {
            if (request.msgCode == 1) {
                CollectModel *collectModel = [[CollectModel alloc] init];
                
                listArray = [collectModel parseArray:result];
//                [pc_collect_CollectionView reloadData];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    
//                });
                [pc_collect_CollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
                [pc_collect_CollectionView reloadData];
                [pc_collect_CollectionView.mj_header endRefreshing];//结束刷新状态
                page++;
            }else if (request.msgCode == 0){
                [self baseHUDWithOnlyLabel:self.view withText:request.msg];
                [pc_collect_CollectionView.mj_header endRefreshing];
            }
        } failureBlock:^(NSString *message) {
            [self baseHUDWithOnlyLabel:self.navigationController.view withText:@"请联系管理员"];
        }];
      
    }
    if (isUpOrDown == 1) {  //上拉加载
        NSString *firstPage = [NSString stringWithFormat:@"%lu",(unsigned long)page];
        NSString *numberOfPange = [NSString stringWithFormat:@"%d",kSLCTNumberOfPage];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             info.token,@"token",
                             firstPage,@"page",
                             numberOfPange,@"list_rows",
                             @"0",@"m_type",nil];
        
        
        //
        listArray = [[NSMutableArray alloc] init];
        [listArray removeAllObjects];
        [request user_collectWithURLString:USER_user_collect method:POST parameters:dic successBlock:^(id result) {
            if (request.msgCode == 1) {
                CollectModel *collectModel = [[CollectModel alloc] init];
                
                [listArray addObjectsFromArray:[collectModel parseArray:result]];
                
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [pc_collect_CollectionView reloadData];
                    [pc_collect_CollectionView.mj_footer endRefreshing];//结束刷新状态
                });
                page++;
            }else if (request.msgCode == 0){
                [self baseHUDWithOnlyLabel:self.view withText:request.msg];
                [pc_collect_CollectionView.mj_footer endRefreshing];
            }
        } failureBlock:^(NSString *message) {
            [self baseHUDWithOnlyLabel:self.navigationController.view withText:@"请联系管理员"];
        }];

    }
    
    
}


- (void)addSubCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    pc_collect_CollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    
    pc_collect_CollectionView.backgroundColor = RGBA(239, 239, 239, 1);
    pc_collect_CollectionView.delegate = self;
    pc_collect_CollectionView.dataSource = self;
    [pc_collect_CollectionView registerClass:[SLCTCollectionViewCell class] forCellWithReuseIdentifier:@"pc_collect"];
    [self.view addSubview:pc_collect_CollectionView];
    [pc_collect_CollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);

    }];
    
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return listArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SLCTCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pc_collect" forIndexPath:indexPath];
    CollectModel *model = (CollectModel *)[listArray objectAtIndex:indexPath.row];
    
    if (model.m_avatar == nil) {
        cell.avatarImageView.image = [UIImage imageNamed:@"sl_collectionDefault"];
    }else{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEDOMAIN,model.m_avatar]];
        [cell.avatarImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"sl_collectionDefault"]];
    }
    cell.title.text = model.m_name;
    
    
    cell.goodButton.m_id = model.music_id;
    cell.goodButton.type_id = model.music_type;
    if ([self isCollect:model.music_id]) {//是否收藏
        cell.goodButton.selected = YES;
        [cell.goodButton setImage:[UIImage imageNamed:@"goodButton_selected"] forState:UIControlStateSelected];
    }else{
        cell.goodButton.selected = NO;
        [cell.goodButton setImage:[UIImage imageNamed:@"goodButton_unselect"] forState:UIControlStateNormal];
    }

    cell.collectDelegate = self;
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//设置item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = collectionView.frame.size;
    NSLog(@"%@",NSStringFromCGSize(size));
    CGFloat itemWidth = (size.width-30-2*10)/3;
    CGFloat itemHeight = (size.width-30-2*10)/3;//高度再减40比较good
    return CGSizeMake(itemWidth, itemHeight);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 15, 0, 15);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;



# pragma mark - 用户收藏曲子
- (void)clickToCollect:(SLCTCollectionButton *)goodButton
{
    
    AppInfo *info = [AppInfo getInstance];
    NSInteger flag = 1;
    if ([[RegularJudge shareInstance] contentIsNil:info.token]) {
        [self baseHUDWithOnlyLabel:self.view withText:@"用户没有登录"];
    }else{
        if (goodButton.selected == YES) {   //取消收藏
            flag = 2;
            //            [goodButton setImage:[UIImage imageNamed:@"goodButton_unselect"] forState:UIControlStateNormal];
            [goodButton setSelected:NO];
            
        }else if (goodButton.selected == NO) {  //收藏
            flag = 1;
            //            [goodButton setImage:[UIImage imageNamed:@"goodButton_selected"] forState:UIControlStateNormal];
            [goodButton setSelected:YES];
        }
        
        RequestApi *request = [RequestApi shareInstance];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             info.token,@"token",
                             [NSString stringWithFormat:@"%ld",goodButton.m_id],@"m_id",
                             [NSString stringWithFormat:@"%ld",goodButton.type_id],@"m_type",
                             [NSString stringWithFormat:@"%ld",flag],@"status", nil];
        [request sl_collectWithURLString:SCORE_collection method:POST parameters:dic successBlock:^(id result) {
            if (request.msgCode == 1) {
                if (flag == 1) {
                    [self baseHUDWithOnlyLabel:self.view withText:@"收藏成功"];
                }else{
                    [self baseHUDWithOnlyLabel:self.view withText:@"取消收藏成功"];
                }
                
            }
        } failurlBlock:^(NSString *message) {
            [self baseHUDWithOnlyLabel:self.view withText:@"请向我们反馈"];
        }];
    }
    
    
}

@end
