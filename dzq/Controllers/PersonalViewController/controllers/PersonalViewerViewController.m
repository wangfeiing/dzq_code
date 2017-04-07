//
//  PersonalViewerViewController.m
//  dzq
//
//  Created by chentianyu on 16/4/13.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "PersonalViewerViewController.h"

@interface PersonalViewerViewController ()
@property(nonatomic,strong)UICollectionView *pc_viewer_CollectionView;
@end

@implementation PersonalViewerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = RGBA(239, 239,239,1);
    [self addSubCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)addSubCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.pc_viewer_CollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    
    
    [self.view addSubview:self.pc_viewer_CollectionView];
    [self.pc_viewer_CollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        
    }];
    self.pc_viewer_CollectionView.backgroundColor = RGBA(239, 239, 239, 1);
    self.pc_viewer_CollectionView.delegate = self;
    self.pc_viewer_CollectionView.dataSource = self;
    [self.pc_viewer_CollectionView registerClass:[SLCTCollectionViewCell class] forCellWithReuseIdentifier:@"pc_collect"];
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 7;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SLCTCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pc_collect" forIndexPath:indexPath];
    cell.avatarImageView.image = [UIImage imageNamed:@"sl_collectionDefault"];
    cell.title.text = @"我们都爱笑";
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

- (void)clickToCollect:(UIButton *)goodButton
{
    NSLog(@"单击是否收藏");
}



@end
