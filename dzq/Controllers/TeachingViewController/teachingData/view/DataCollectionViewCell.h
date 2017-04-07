//
//  DataCollectionViewCell.h
//  dzq
//
//  Created by chentianyu on 16/4/10.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

@interface DataCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIImageView *discloureView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *subTitleLabel;
@end
