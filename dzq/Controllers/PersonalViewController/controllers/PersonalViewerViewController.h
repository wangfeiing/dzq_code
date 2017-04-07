//
//  PersonalViewerViewController.h
//  dzq
//
//  Created by chentianyu on 16/4/13.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "BaseViewController.h"

#import "SLCTCollectionViewCell.h"
#import <Masonry/Masonry.h>
@interface PersonalViewerViewController : BaseViewController<SLCTCollectionViewCellDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@end
