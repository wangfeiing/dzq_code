//
//  CommentTextLabel.m
//  dzq
//
//  Created by 飞飞 on 16/4/9.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "CommentTextLabel.h"

@implementation CommentTextLabel
//{
//    CGFloat height;
//}
//
//-(void)setFrame:(CGRect)frame{
//    [self layoutIfNeeded];
//    [super setFrame:frame];
//}
//-(CGFloat)getHeightOfText:(NSString *)string{
//    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13.f],NSFontAttributeName,NSParagraphStyleAttributeName,NSParagraphStyle.copy ,nil];
//    CGRect frame  = [string boundingRectWithSize:CGSizeMake(150, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil];
//    NSLog(@"%@",NSStringFromCGRect(frame));
//    return frame.size.height;
//}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.numberOfLines = 0;
    }
    return self;
}
-(void)setText:(NSString *)text{
    text = [text stringByReplacingOccurrencesOfString:@"\n" withString:text];
    NSLog(@"%@",text) ;
    
    [super setText:text];
}
//-(void)setAttributedText:(NSAttributedString *)attributedText{
//
//}
@end
