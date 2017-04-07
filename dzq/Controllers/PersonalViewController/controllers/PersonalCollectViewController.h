//
//  PersonalCollectViewController.h
//  dzq
//
//  Created by chentianyu on 16/4/13.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "BaseViewController.h"
#import "SLCTCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>
#import <UIImageView+WebCache.h>
#import "CollectModel.h"
#import "MusicModel.h"
#import "SLCTCollectionButton.h"
@interface PersonalCollectViewController : BaseViewController<SLCTCollectionViewCellDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end
