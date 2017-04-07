//
//  DataViewController.h
//  dzq
//
//  Created by chentianyu on 16/1/25.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataDetailViewController.h"
#import "TeachingDataModel.h"
#import "TeachTitleView.h"
#import "TeachDataCell.h"
#import "BaseViewController.h"

@interface DataViewController : BaseViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataList;
@property(nonatomic,strong)UICollectionView *teachCollectionView;

@end
