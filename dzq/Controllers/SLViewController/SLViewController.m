//
//  SLViewController.m
//  dzq
//
//  Created by chentianyu on 16/1/24.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "SLViewController.h"

#import "SLHeaderScrollView.h"
#import "SLSeparactorLabel.h"
#import "SLHeaderLayout.h"
#import "SLCategoryCollectionViewCell.h"
#import "SLHotCollectionViewCell.h"

#import "CategoryModel.h"
#import "MusicModel.h"
#import "CommentViewController.h"

@interface SLViewController ()
{
    UIScrollView *_scrollView;
    
    UICollectionView *headerCollectionView;
    UICollectionView *_categoryCollectionView;
    
    NSMutableArray *hotRecommendArray;
    NSMutableArray *categoryArray;
}

@end

@implementation SLViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"谱库";
    NSLog(@"------>>>%@",[[AppInfo alloc] init].usermodel.token);
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 110, 100, 50)];
//    [label setText:@"谱库"];
//    label.layer.borderWidth = 1.0f;
//    [scrollView addSubview:label];
//    self.navigationController.navigationItem


//    self.navigationController.navigationBar.translucent = YES;
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self createScrollBackgroundView];


    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}


- (void)viewWillAppear:(BOOL)animated
{
        NSLog(@"%@",@"aa");
    RequestApi *request = [RequestApi shareInstance];
    
    [self get_sl_hotRecommand:request];
    [self get_sl_category:request];
    
  
    
}



//热门推荐
- (void)get_sl_hotRecommand:(RequestApi *)str
{
    NSDictionary *dic = [NSDictionary new];
    
    hotRecommendArray = [[NSMutableArray alloc] init];
    
    [str sl_categoryWithURLString:SCORE_recommend method:GET parameters:dic successBlock:^(id result) {
        if (str.msgCode == 1) {
            MusicModel *model = [[MusicModel alloc] init];
            hotRecommendArray = [model parseWithDic:result];
            if (!hotRecommendArray.count) {
                return ;
            }
            [headerCollectionView reloadData];
            NSLog(@"%@",hotRecommendArray);
            
        }
    } failurlBlock:^(NSString *message) {
//        ProgressHUD *hud = [[ProgressHUD alloc] init];
//        [hud textHUD:self.navigationController.view withText:@"请联系管理员"];
        [self baseHUDWithOnlyLabel:self.navigationController.view withText:@"获取推荐的曲子"];
    }];

}
//获取类别
- (void)get_sl_category:(RequestApi *)str
{
    NSDictionary *dic = [NSDictionary new];

    categoryArray = [[NSMutableArray alloc] init];
    
    [str sl_categoryWithURLString:SCORE_music_type method:GET parameters:dic successBlock:^(id result) {
        if (str.msgCode == 1) {
            CategoryModel *model = [[CategoryModel alloc] init];
            categoryArray = [model praseWithDictionary:result];
            if(!categoryArray.count) return ;
            [_categoryCollectionView reloadData];
            NSLog(@"%@",categoryArray);
            
        }
    } failurlBlock:^(NSString *message) {
        [self baseHUDWithOnlyLabel:self.navigationController.view withText:@"获取类别有误"];
//        ProgressHUD *hud = [[ProgressHUD alloc] init];
//        [hud textHUD:self.navigationController.view withText:@"请联系管理员"];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"%@",@"aa");
    
    //解决滚动视图不能滚到底部的情景
    float y = 0;
    
    y = y+_categoryCollectionView.frame.origin.y+_categoryCollectionView.contentSize.height+[self originHeightInFact]*2;;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH-DOCK_WIDTH, y);
//    for (UIView *views in _categoryCollectionView.subviews) {
//        float height = views.frame.size.height;
//        y += height;
//        NSLog(@"%@",_scrollView.subviews.lastObject);
//    }
//    NSLog(@"5f",y);
}

- (void)handlePan:(UIPanGestureRecognizer *)pan
{
    _scrollView.contentOffset = [pan translationInView:_scrollView];
//    _scrollView.subviews
}

- (void)createScrollBackgroundView
{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-DOCK_WIDTH, SCREEN_HEIGHT-[self originHeightInFact])];
//    scrollView.contentOffset = CGPointMake(0, 64);
//    scrollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT-[self originHeightInFact]);
//    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH-DOCK_WIDTH, (SCREEN_HEIGHT-[self originHeightInFact])+40);
//    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 200, 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.scrollEnabled = YES;
//    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_scrollView];
    
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//    [self.view addGestureRecognizer:pan];
    
    [self createHeaderView];
    [self createCategoryView];
}

- (CGFloat )originHeightInFact
{
    CGFloat navHeight = STATUS_HEIGTH+self.navigationController.navigationBar.frame.size.height;
    AppInfo *appInfo = [AppInfo getInstance];
    [appInfo setTheNavHeight:navHeight];
    return navHeight;
    
}

- (void)createHeaderView
{
    //“热门推荐”标签
    
    UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17.0f],NSFontAttributeName, nil];
    firstLabel.attributedText = [[NSAttributedString alloc] initWithString:@"热门推荐" attributes:attrs];
    [_scrollView addSubview:firstLabel];

    //"加重"标签
    
    CGRect labelSize = [firstLabel.attributedText boundingRectWithSize:CGSizeMake(100, 40) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    SLSeparactorLabel *deepLabel = [[SLSeparactorLabel alloc] initWithFrame:CGRectMake(10, 40, labelSize.size.width, 3)];
    [_scrollView addSubview:deepLabel];
    
    //“分割先”标签
    SLSeparactorLabel *separatorLabel = [[SLSeparactorLabel alloc] initWithFrame:CGRectMake(10, 42, SCREEN_WIDTH-DOCK_WIDTH-20, 1)];
    [_scrollView addSubview:separatorLabel];

    //“热门推荐”视图

//    SLHeaderScrollView *headView = [[SLHeaderScrollView alloc] initWithFrame:headerViewFrame];
//    headView.layer.borderColor = [[UIColor blackColor] CGColor];
//    headView.layer.borderWidth = 1.0f;
//    [scrollView addSubview:headView];
    
    CGRect headerViewFrame = CGRectMake(10, 54, SCREEN_WIDTH-DOCK_WIDTH-20, 135);
    SLHeaderLayout *flowLayout = [[SLHeaderLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(135, 135);

    headerCollectionView = [[UICollectionView alloc] initWithFrame:headerViewFrame collectionViewLayout:flowLayout];
    headerCollectionView.showsVerticalScrollIndicator = false;
    headerCollectionView.showsHorizontalScrollIndicator  = false;
    headerCollectionView.backgroundColor = [UIColor whiteColor];
    headerCollectionView.tag = 1;
    headerCollectionView.delegate = self;
    headerCollectionView.dataSource = self;
    [headerCollectionView registerClass:[SLHotCollectionViewCell class] forCellWithReuseIdentifier:@"header_cell"];
    [_scrollView addSubview:headerCollectionView];
}

- (void)createCategoryView
{
    
    CGFloat originHeight = 54+135+20;
    
    UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, originHeight, 100, 40)];
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17.0f],NSFontAttributeName, nil];
    firstLabel.attributedText = [[NSAttributedString alloc] initWithString:@"分类" attributes:attrs];
    [_scrollView addSubview:firstLabel];
    

    CGRect labelSize = [firstLabel.attributedText boundingRectWithSize:CGSizeMake(100, 40) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    SLSeparactorLabel *deepLabel = [[SLSeparactorLabel alloc] initWithFrame:CGRectMake(10, originHeight+40, labelSize.size.width, 3)];
    [_scrollView addSubview:deepLabel];
    

    SLSeparactorLabel *separatorLabel = [[SLSeparactorLabel alloc] initWithFrame:CGRectMake(10, originHeight+40+3, SCREEN_WIDTH-DOCK_WIDTH-20, 1)];
    [_scrollView addSubview:separatorLabel];
    
    CGFloat itemSize = (SCREEN_WIDTH-DOCK_WIDTH-20-3*20)/4;
    CGRect categoryFrame = CGRectMake(10, originHeight+41+3+10, SCREEN_WIDTH-DOCK_WIDTH-20,(17/4+1)*itemSize+17/4*10);
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.itemSize = CGSizeMake(itemSize, itemSize);
    _categoryCollectionView = [[UICollectionView alloc] initWithFrame:categoryFrame collectionViewLayout:flowLayout];
    _categoryCollectionView.backgroundColor = [UIColor whiteColor];
    _categoryCollectionView.scrollEnabled = NO;
    _categoryCollectionView.showsHorizontalScrollIndicator = NO;
    _categoryCollectionView.showsVerticalScrollIndicator = NO;
    _categoryCollectionView.tag = 2;
    _categoryCollectionView.delegate = self;
    _categoryCollectionView.dataSource = self;
    [_categoryCollectionView registerClass:[SLCategoryCollectionViewCell class] forCellWithReuseIdentifier:@"category_cell"];
    [_scrollView addSubview:_categoryCollectionView];

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (collectionView.tag == 1) {
        return 1;
    }
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag == 1 ) {
        return hotRecommendArray.count?hotRecommendArray.count:1;
    }else if (collectionView.tag == 2){
        return categoryArray.count?categoryArray.count:1;
    }
    
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView.tag == 1) {
        
        SLHotCollectionViewCell *cell = (SLHotCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"header_cell" forIndexPath:indexPath];
        if (!hotRecommendArray.count) {
            return cell;
        }
        MusicModel *model = (MusicModel *)[hotRecommendArray objectAtIndex:indexPath.row];
        if (model.m_avatar==nil) {
            cell.imageView.image = [UIImage imageNamed:@"sl_hot_default"];
        }else{
             NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEDOMAIN,model.m_avatar]];
            [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"sl_hot_default"]];
        }
        cell.titleLabel.text = model.m_name;
        cell.backgroundColor = [UIColor greenColor];
        return cell;
    }else if(collectionView.tag == 2){
        SLCategoryCollectionViewCell *cell = (SLCategoryCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"category_cell" forIndexPath:indexPath];
        
        if (!categoryArray.count) {
            return cell;
        }
        CategoryModel *model = (CategoryModel *)[categoryArray objectAtIndex:indexPath.row];
        cell.countLabel.text = [NSString stringWithFormat:@"%ld",(long)model.ca_count];

        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEDOMAIN,model.ca_cover_img]];
        

        [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"sl_type_default"] options:SDWebImageRefreshCached];
        cell.typeLabel.text = model.ca_type;
        return cell;
    }else{
        return [[UICollectionViewCell alloc] init];
    }
    

}

 - (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if (scrollView.contentOffset.x <= -1) {
//        [scrollView setScrollEnabled:NO];
//        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//        [scrollView setScrollEnabled:YES];
//    }
//    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH-DOCK_WIDTH, scrollView.contentSize.height+)
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake((SCREEN_WIDTH-DOCK_WIDTH-20-3*20)/4, (SCREEN_WIDTH-DOCK_WIDTH-20-3*20)/4);
//}
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}


//点击分类单元格，跳转
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.tag == 1){
        
        CommentViewController * cvc = [[CommentViewController alloc] init];
        if(!hotRecommendArray.count)
            return;
        MusicModel *model = (MusicModel *)[hotRecommendArray objectAtIndex:indexPath.row];
        cvc.music_model = model;
        [self.navigationController pushViewController:cvc animated:YES];
        
    }else if (collectionView.tag == 2) {
        SLCTViewController *slct = [[SLCTViewController alloc] init];
        if (!categoryArray.count) {
            return;
        }
        CategoryModel *model = (CategoryModel *)[categoryArray objectAtIndex:indexPath.row];
        slct.type_Text = model.ca_type;
        slct.type_id = model.ca_id;
        [self.navigationController pushViewController:slct animated:YES];
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    });
}
//设定指定组内cell的最小行距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}



@end
