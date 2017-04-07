//
//  CommentCell.m
//  Paint
//
//  Created by 飞飞 on 16/3/30.
//  Copyright © 2016年 飞飞. All rights reserved.
/*
 
 */

#import "CommentCell.h"

@implementation CommentCell
{
    UILongPressGestureRecognizer * longPress;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressForDelete:)];
        
        _photoBtn = [[UIButton alloc] init];
        _photoBtn.enabled = NO;
        _photoBtn.layer.borderWidth =1.0f;
        _photoBtn.layer.cornerRadius = 17.5f;
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:13.f];
       
        _commentTextLabel = [[CommentTextLabel alloc] init];
        _commentTextLabel.font = [UIFont systemFontOfSize:11.f];
        _commentTextLabel.textColor = [UIColor grayColor];
        _commentTextLabel.numberOfLines = 0;
        _commentTimeLabel = [[UILabel alloc] init];
        _commentTimeLabel.font = [UIFont systemFontOfSize:11.f];
        _commentTimeLabel.textColor = [UIColor grayColor];

        
//        _answer = [[UIButton alloc] init];
//        _answer.titleLabel.font = [UIFont systemFontOfSize:11.f];
//        [_answer setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
//        [_answer setTitle:@"回复" forState:(UIControlStateNormal)];
        [self.contentView addSubview:_photoBtn];
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:_commentTimeLabel];
        [self.contentView addSubview: _commentTextLabel];

        //按钮
        __weak typeof(self) weakSelf = self;
        
        
        [_photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(35, 35));
            make.left.equalTo(weakSelf.contentView.mas_left).with.offset(9);
            make.top.equalTo(weakSelf.contentView.mas_top).with.offset(0);
        }];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 18));
            make.left.equalTo(_photoBtn.mas_right).with.offset(8);
            make.centerY.equalTo(_photoBtn);
        }];
        [_commentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameLabel.mas_bottom).with.offset(0);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).with.offset(-18);
            make.right.equalTo(weakSelf.contentView.mas_right).with.offset(0);
            make.left.equalTo(_photoBtn.mas_right).with.offset(8);
        }];
        [_commentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(132, 16));
            make.left.equalTo(_photoBtn.mas_right).with.offset(8);
            make.top.equalTo(_commentTextLabel.mas_bottom).with.offset(0);
        }];
        
//        [_answer mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(50, 20));
//            make.right.mas_equalTo(weakSelf.contentView.mas_right).with.offset(-20);
//            make.centerY.equalTo(_commentTimeLabel);
//        }];
//        [self.contentView addGestureRecognizer:longPress];
    }
    return self;
}

-(void)setFrame:(CGRect)frame{
    frame.origin.x += 90;
    frame.size.width = TABLE_WIDTH;
    [super setFrame:frame];
}
-(void)longPressForDelete:(UILongPressGestureRecognizer *)sender{

    CommentCell * cell = (CommentCell *)[sender.view superview];
    NSLog(@"%@",cell.commentTextLabel.text);
}
@end
