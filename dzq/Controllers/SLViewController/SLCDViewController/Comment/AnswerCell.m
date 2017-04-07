//
//  AnswerCell.m
//  Paint
//
//  Created by 飞飞 on 16/3/31.
//  Copyright © 2016年 飞飞. All rights reserved.
//

#import "AnswerCell.h"
#import <Masonry.h>

@implementation AnswerCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        __weak typeof(self)  weakSelf = self;
        
        _answerText = [[CommentTextLabel alloc] init];
        _answerText.font = [UIFont systemFontOfSize:11.f];
        _answerText.textColor = [UIColor grayColor];
        _answerText.numberOfLines = 0;

        [self.contentView addSubview:_answerText];
        [_answerText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView).with.offset(0);
            make.left.equalTo(weakSelf.contentView.mas_left).with.offset(9);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).with.offset(0);
            make.right.equalTo(weakSelf.contentView.mas_right).with.offset(2);
        }];
    
    }

    return self;
}
-(NSMutableAttributedString *)getTextWithFirstName:(NSString *)firstName secened:(NSString *)secend text:(NSString *)text{
    
    NSString * string = @"回复";
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@" ,firstName,string]];
    NSRange range = NSMakeRange([[str string] rangeOfString:string].location, string.length);
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
    [str appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ： %@ ",secend ,text]]];
    
    return str;
}

-(void)setFrame:(CGRect)frame{
    frame.origin.x += 90 + 40;
    frame.size.width = TABLE_WIDTH - 40;
    [super setFrame:frame];
}
@end
