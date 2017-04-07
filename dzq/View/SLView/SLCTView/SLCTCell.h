//
//  SLCTCell.h
//  dzq
//
//  Created by chentianyu on 16/2/20.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLCTCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introlLabel;
@property (weak, nonatomic) IBOutlet UIImageView *authorIcon;
@property (weak, nonatomic) IBOutlet UILabel *uploaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodIcon;
@property (weak, nonatomic) IBOutlet UILabel *goodLabel;
@property (weak, nonatomic) IBOutlet UIImageView *viewerIcon;
@property (weak, nonatomic) IBOutlet UILabel *viewerLabel;

@end
