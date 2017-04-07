//
//  CommentTextFieldController.m
//  dzq
//
//  Created by 飞飞 on 16/4/2.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "CommentTextFieldController.h"
#import <Masonry.h>

#define PLACE_HOLDER @"回复： "

@interface CommentTextFieldController ()

@end

@implementation CommentTextFieldController
{
    UILabel * number;
    UIImageView * bgimg;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _placeholderLabel = [[UILabel alloc] init];
        bgimg = [[UIImageView alloc] initWithFrame:self.view.frame];
        [bgimg setImage:[UIImage imageNamed:@"ji.png"]];
        [self.view addSubview:bgimg];

        
    }
    return self;
}
- (void)viewDidLoad {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [super viewDidLoad];
    
    
    self.title = @"写下你的感受...";
    UIBarButtonItem * leftBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemStop) target:self action:@selector(dimiss:)];
    UIBarButtonItem * rightBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemDone) target:self action:@selector(send:)];
    rightBar.enabled = NO;

    self.navigationItem.leftBarButtonItem = leftBar;
    self.navigationItem.rightBarButtonItem = rightBar;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    _textView = [[UITextView alloc] init];
//    _textView.layer.borderWidth = 1.0f;
//    _textView.layer.borderColor = [[UIColor grayColor] CGColor];
    _textView.delegate = (id)self;
    _textView.font = [UIFont systemFontOfSize:13.f];
    
    _placeholderLabel.backgroundColor = [UIColor clearColor];
    _placeholderLabel.font = [UIFont systemFontOfSize:13.f];
    _placeholderLabel.textColor = [UIColor grayColor];
    
    number = [[UILabel alloc] init];
    
    [_textView addSubview:_placeholderLabel];
    [self.view addSubview:_textView];
  
    __weak typeof (self) weakSelf = self;
    __weak typeof (_textView) Weak_textView = _textView;
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(450, 300));
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view.mas_top).with.offset(5);
    }];
    [_placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 30));
        make.left.equalTo(Weak_textView.mas_left).with.offset(0);
        make.left.equalTo(Weak_textView.mas_top).with.offset(10);
    }];
}
-(void)dimiss:(id)sender{
  
    [self dismissViewControllerAnimated:YES completion:nil];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    if (_textView.text.length != 0) {
        _textView.text = @"";
    }
}
-(void)send:(id)sender{
    NSLog(@"%@",_textView.text);
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (_CTDelegate && [_CTDelegate respondsToSelector:@selector(commentWithCommentModel:commentText: inTableView: atIndexPath: commentType:)]) {
            [_CTDelegate commentWithCommentModel:_commentModel  commentText:[_textView.text stringByReplacingOccurrencesOfString:@"\n" withString:@""] inTableView:_currentTable atIndexPath:_indexPath commentType:_commentType];
        }
        [_CTDelegate commentWithCommentModel:_commentModel commentText:[_textView.text stringByReplacingOccurrencesOfString:@"\n" withString:@""] commentType:_commentType];
        self.navigationItem.rightBarButtonItem.enabled = NO;
        if (_textView.text.length != 0) {
            _textView.text = @"";
        }

    }];
    
}
- (void)setRepleyedName:(NSString *)repleyedName{
    _repleyedName = repleyedName;
    repleyedName = [PLACE_HOLDER stringByAppendingString:repleyedName];
    _placeholderLabel.text = repleyedName;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    _placeholderLabel.text = @"";
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = YES;
        _placeholderLabel.text = @"";
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
