//
//  DataDetailViewController.m
//  dzq
//
//  Created by chentianyu on 16/1/27.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "DataDetailViewController.h"

@interface DataDetailViewController ()

@end

@implementation DataDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self loadNav];
    

    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 768, 748)];
    NSMutableString *htmlTitle = [[NSMutableString alloc] initWithFormat:@"%@",@"<center>"];
    [htmlTitle appendString:self.dataTitle];
    [htmlTitle appendString:@"</center>"];
    
    
    NSString *htmlContent = self.dataContent;
    
    NSString *html = [htmlTitle stringByAppendingString:htmlContent];
    [self.webView loadHTMLString:html baseURL:nil];
    

    
    [self.view addSubview:self.webView];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];

}



- (void)loadNav
{
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeModel:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)closeModel:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(instancetype)initWithDataTitle:(NSString *)dataTitle dataContent:(NSString *)dataContent
{
    self = [super init];
    if (self) {
        self.dataTitle = dataTitle;
        self.dataContent = dataContent;
    }
    return self;
}


#pragma mark - webViewDelegate:未用
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //自适应高度
    CGRect frame = self.webView.frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];//将web
    
    frame.size.height = fittingSize.height;
    webView.frame = frame;
    DDLogInfo(@"%f",frame.size.height);
    if (frame.size.height<=self.view.frame.size.height) {
       webView.scrollView.scrollEnabled = NO;
    }else{
        webView.scrollView.scrollEnabled = YES;
    }
    webView.scrollView.contentSize = frame.size;
    

}


@end
