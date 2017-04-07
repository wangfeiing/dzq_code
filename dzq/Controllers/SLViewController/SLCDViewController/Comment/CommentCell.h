//
//  CommentCell.h
//  Paint
//
//  Created by 飞飞 on 16/3/30.
//  Copyright © 2016年 飞飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "CommentTextLabel.h"

@interface CommentCell : UITableViewCell

@property (nonatomic ,retain)UIButton * photoBtn;
@property (nonatomic ,retain)UILabel * nameLabel;
@property (nonatomic ,retain)CommentTextLabel * commentTextLabel;
@property (nonatomic ,retain)UILabel * commentTimeLabel;
@property (nonatomic ,retain)UIButton * answer;
@property (nonatomic ,retain)NSString * firstName;
@property (nonatomic ,retain)NSString * firstID;
@property (nonatomic ,retain)NSString * secendName;
@property (nonatomic ,retain)NSString * secendID;

@end
