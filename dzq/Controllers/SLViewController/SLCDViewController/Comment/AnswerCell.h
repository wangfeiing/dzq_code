//
//  AnswerCell.h
//  Paint
//
//  Created by 飞飞 on 16/3/31.
//  Copyright © 2016年 飞飞. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CommentTextLabel.h"

@interface AnswerCell : UITableViewCell

@property (nonatomic ,retain)NSString * firstNameID;
@property (nonatomic ,retain)NSString * secendNameID;
@property (nonatomic ,retain)CommentTextLabel * answerText;

-(NSMutableAttributedString *)getTextWithFirstName:(NSString *)firstName secened:(NSString *)secend text:(NSString *)text;

@end
