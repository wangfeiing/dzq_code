//
//  SLCTViewController.m
//  dzq
//
//  Created by chentianyu on 16/2/20.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "SLCTViewController.h"

#import "CommentViewController.h"
#import "MusicModel.h"
#import "CollectModel.h"
//#import <Ma>


#define SLCTHeaderViewHeight 55
#define kSLCTNumberOfPage 10
@interface SLCTViewController ()<HeaderClick>
{
    UICollectionView *slCollectionView;
    NSMutableArray *listArray;
    
    UILabel *label;
    
    NSString *orderType;
    NSInteger isUpOrDown;//0是下拉，1是上拉
    
    NSUInteger page;
    
    NSMutableArray *collectArray;
}

@end

@implementation SLCTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.type_Text;

    self.view.backgroundColor = RGBA(239, 239, 239, 1);
    
    [self addHeaderView];
    [self addCollectionView];
    
    orderType = @"1";
    
    slCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

        NSLog(@"+++++++");
        isUpOrDown = 0;
        [self addFavorite];
        [self sentRequestWithOrderType:orderType];//最热门
    }];
    slCollectionView.mj_header.automaticallyChangeAlpha = YES;
    [slCollectionView.mj_header beginRefreshing];//马上进入刷新状态
    
    slCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        isUpOrDown = 1;
        [self addFavorite];
        [self sentRequestWithOrderType:orderType];
    }];
    
    //设置底部的inset
    slCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    //忽略了底部inset
    slCollectionView.mj_footer.ignoredScrollViewContentInsetBottom = 30;
    

   
    

}

- (void)addFavorite
{
    AppInfo *info = [AppInfo getInstance];
    if ([[RegularJudge shareInstance] contentIsNil:info.token]) {
        
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            RequestApi *request = [RequestApi shareInstance];
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:info.token,@"token",[NSString stringWithFormat:@"%ld",self.type_id],@"m_type", nil];
            [request user_collectListWithURLString:USER_user_collectList method:POST parameters:dic successBlock:^(id result) {
                if (request.msgCode == 1) {
                    CollectModel *collectModel = [[CollectModel alloc] init];
                    collectArray = [collectModel parseArray:result];
                    
                    [slCollectionView reloadData];
                }
            } failureBlock:^(NSString *message) {
                [self baseHUDWithOnlyLabel:self.view withText:@"收藏为空"];
            }];
        });
    }

}

//判断某首曲子是否收藏
- (BOOL)isCollect:(NSInteger)m_id
{
    for (CollectModel *model in collectArray) {
        if (m_id==model.music_id) {
            return true;
        }
    }
    return false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)sentRequestWithOrderType:(NSString *)theOrderType
{
   
    RequestApi *request = [RequestApi shareInstance];
    NSLog(@"%@",request);
    
    NSString *order_type = theOrderType;
    NSString *the_type_id =  [NSString stringWithFormat:@"%ld",(long)self.type_id];//
    
    

    if(isUpOrDown == 0){//下拉刷新
       //指定page为1
        page = 1;
        NSString *firstPage = [NSString stringWithFormat:@"%lu",(unsigned long)page];
        NSString *numberOfPange = [NSString stringWithFormat:@"%d",kSLCTNumberOfPage];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:the_type_id,@"id",order_type,@"order_type",firstPage,@"p",numberOfPange,@"n", nil];
    
        
        //
        listArray = [[NSMutableArray alloc] init];
        [listArray removeAllObjects];
        [request sl_categoryWithURLString:SCORE_type_music method:GET parameters:dic successBlock:^(id result) {
            if (request.msgCode == 1) {
                MusicModel * model = [[MusicModel alloc] init];
                listArray = [model parseWithDic:result];
                
                [slCollectionView reloadData];
                [slCollectionView.mj_header endRefreshing];//结束刷新状态
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    
//                    });
                page++;
            }else if(request.msgCode == 0){
                [slCollectionView.mj_header endRefreshing];//结束刷新状态
            }
        } failurlBlock:^(NSString *message) {
                [self baseHUDWithOnlyLabel:self.navigationController.view withText:@"请联系管理员"];
                
            }];
    }
    if (isUpOrDown == 1) {  //上拉加载
        NSString *firstPage = [NSString stringWithFormat:@"%lu",(unsigned long)page];
        NSString *numberOfPange = [NSString stringWithFormat:@"%d",kSLCTNumberOfPage];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:the_type_id,@"id",order_type,@"order_type",firstPage,@"p",numberOfPange,@"n", nil];
        
        [request sl_categoryWithURLString:SCORE_type_music method:GET parameters:dic successBlock:^(id result) {
            if (request.msgCode == 1) {
                MusicModel * model = [[MusicModel alloc] init];
                [listArray addObjectsFromArray: [model parseWithDic:result]];
                
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    
//                    
//                });
                [slCollectionView reloadData];
                [slCollectionView.mj_footer endRefreshing];//结束刷新状态
                page++;
            }else if (request.msgCode == 0){
                [slCollectionView.mj_footer endRefreshing];//结束刷新状态
            }
        } failurlBlock:^(NSString *message) {
            [self baseHUDWithOnlyLabel:self.navigationController.view withText:@"请联系管理员"];
            
        }];
    }
   

}

- (void)back:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat )originHeightInFact
{
    return STATUS_HEIGTH+self.navigationController.navigationBar.frame.size.height;
}

- (void)addHeaderView
{
    SLCTHeaderView *headerView = [[SLCTHeaderView alloc] initWithFrame:CGRectMake(0, [self originHeightInFact], SCREEN_WIDTH-DOCK_WIDTH, SLCTHeaderViewHeight)];
    headerView.delegate = self;
    [self.view addSubview:headerView];
    
    
}

- (void)addCollectionView
{

    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    

    
    slCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, [self originHeightInFact]+SLCTHeaderViewHeight, SCREEN_WIDTH-DOCK_WIDTH, SCREEN_HEIGHT-[self originHeightInFact]-44) collectionViewLayout:layout];
    slCollectionView.delegate = self;
    slCollectionView.dataSource = self;
    slCollectionView.backgroundColor = RGBA(239, 239, 239, 1);
    [slCollectionView registerClass:[SLCTCollectionViewCell class] forCellWithReuseIdentifier:@"slctItemIdentifier"];
    [self.view addSubview:slCollectionView];
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return listArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SLCTCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"slctItemIdentifier" forIndexPath:indexPath];
    MusicModel *model = (MusicModel *)[listArray objectAtIndex:indexPath.row];
    if (model.m_avatar == nil) {
        cell.avatarImageView.image = [UIImage imageNamed:@"sl_hot_default"];
    }else{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEDOMAIN,model.m_avatar]];
        [cell.avatarImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"sl_hot_default"]];
    }

    cell.title.text = model.m_name;
    cell.goodButton.tag = model.m_id;
    if ([self isCollect:model.m_id]) {//是否收藏
        cell.goodButton.selected = YES;
        [cell.goodButton setImage:[UIImage imageNamed:@"goodButton_selected"] forState:UIControlStateSelected];
    }else{
        cell.goodButton.selected = NO;
        [cell.goodButton setImage:[UIImage imageNamed:@"goodButton_unselect"] forState:UIControlStateNormal];
    }
    
    cell.collectDelegate = self;

    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = {(SCREEN_WIDTH-DOCK_WIDTH-20-3*10)/4,(SCREEN_WIDTH-DOCK_WIDTH-20-3*20)/4};
    return size;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
{
    return CGSizeMake(SCREEN_WIDTH-DOCK_WIDTH, 10);
}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;



}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    CommentViewController * cvc = [[CommentViewController alloc] init];
   
    cvc.music_model = (MusicModel *)[listArray objectAtIndex:indexPath.row];
    NSLog(@"------音乐model:%@",cvc.music_model);
    [self.navigationController pushViewController:cvc animated:YES];

}

# pragma mark - 用户收藏曲子
- (void)clickToCollect:(UIButton *)goodButton
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
                             [NSString stringWithFormat:@"%ld",goodButton.tag],@"m_id",
                             [NSString stringWithFormat:@"%ld",self.type_id],@"m_type",
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
- (void)clickHeaderButton:(UIButton *)button
{
    if (button.tag == 1) {
        DDLogInfo(@"最热门");
        orderType = @"1";
        
    }else if(button.tag == 2){
        DDLogInfo(@"最新上传");
        orderType = @"2";
    }else if(button.tag == 3){
        DDLogInfo(@"最近跟新");
        orderType = @"3";
    }
    page = 1;
    [slCollectionView.mj_header beginRefreshing];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)button.tag],@"orderTypes", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SLCategoryOrderType" object:nil userInfo:dic];

}


@end
