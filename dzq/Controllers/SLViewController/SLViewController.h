//
//  SLViewController.h
//  dzq
//
//  Created by chentianyu on 16/1/24.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>
#import "BaseViewController.h"
#import "SLCTViewController.h"

@interface SLViewController :BaseViewController <UIScrollViewDelegate, UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>


@property(nonatomic,strong)NSArray *dataArray;
- (CGFloat )originHeightInFact;
@end
