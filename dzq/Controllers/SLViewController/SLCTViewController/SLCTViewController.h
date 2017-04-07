//
//  SLCTViewController.h
//  dzq
//
//  Created by chentianyu on 16/2/20.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLCTCell.h"
#import "SLCTHeaderView.h"
#import "BaseViewController.h"
#import "MusicModel.h"
#import "SLCTCollectionViewCell.h"

#import <MJRefresh/MJRefresh.h>
#import <UIImageView+WebCache.h>
@interface SLCTViewController : BaseViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SLCTCollectionViewCellDelegate>

@property(nonatomic,strong)NSString *type_Text;
@property(nonatomic)NSInteger type_id;//乐谱类id

@end
