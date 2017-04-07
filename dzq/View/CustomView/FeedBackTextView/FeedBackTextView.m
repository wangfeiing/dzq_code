//
//  FeedBackTextView.m
//  dzq
//
//  Created by chentianyu on 16/4/3.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "FeedBackTextView.h"

static float kUITextViewPadding = 8.0;

@implementation FeedBackTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = RGBA(244, 244, 244, 1).CGColor;
        self.layer.cornerRadius = 5.0;
        self.font = [UIFont systemFontOfSize:15.0f];
        [self awakeFromNib];
        
    }
    return self;
}
- (void)awakeFromNib
{

    placeholderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    placeholderLabel.font = self.font;
    placeholderLabel.textColor = [UIColor grayColor];
    placeholderLabel.textAlignment = self.textAlignment;
//    placeholderLabel.text = @"请输入您的意见";
    placeholderLabel.text = NSLocalizedString(@"请输入您的意见", @"占位符文本");
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:placeholderLabel.font forKey:NSFontAttributeName];
    CGSize size = [placeholderLabel.text sizeWithAttributes:dic];
    placeholderLabel.frame = CGRectMake(kUITextViewPadding, kUITextViewPadding, size.width, size.height);
    [self addSubview:placeholderLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextViewTextDidChangeNotification object:self];
}

- (void)textChange:(NSNotification *)notification
{
    if (self.text.length<1) {
        [self addSubview:placeholderLabel];
    }else{
        [placeholderLabel removeFromSuperview];
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
