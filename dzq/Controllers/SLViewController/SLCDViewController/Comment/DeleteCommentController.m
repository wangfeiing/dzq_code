//
//  DeleteCommentController.m
//  dzq
//
//  Created by 飞飞 on 16/4/19.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "DeleteCommentController.h"

@interface DeleteCommentController ()

@end

@implementation DeleteCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _label = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    _label.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_label setTitle:@"删除" forState:(UIControlStateNormal)];
    _label.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_label addTarget:self action:@selector(delete:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_label];
    // Do any additional setup after loading the view.
}

-(void)delete:(id )sender{
    if (_D_delegate) {
        NSLog(@"%@",sender);
        [_D_delegate longPressActionForCell:_deleteForCell];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
