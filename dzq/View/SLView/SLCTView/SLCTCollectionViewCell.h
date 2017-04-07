//
//  SLCTCollectionViewCell.h
//  dzq
//
//  Created by chentianyu on 16/4/11.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "SLCTCollectionButton.h"

@protocol SLCTCollectionViewCellDelegate <NSObject>

- (void)clickToCollect:(UIButton *)goodButton;

@end
@interface SLCTCollectionViewCell : UICollectionViewCell


@property(nonatomic,strong)UIImageView *avatarImageView;
@property(nonatomic,strong)UILabel *title;
@property(nonatomic,strong)SLCTCollectionButton *goodButton;
@property(nonatomic,weak)id <SLCTCollectionViewCellDelegate>collectDelegate;

@end
