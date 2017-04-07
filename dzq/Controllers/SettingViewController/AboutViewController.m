//
//  AboutViewController.m
//  dzq
//
//  Created by chentianyu on 16/4/3.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "AboutViewController.h"
#import <Masonry/Masonry.h>
#import "AppInfo.h"
#import "RequestApi.h"
@interface AboutViewController ()
{
    UIWebView *webView;
}
//@property()
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = PC_Modal_Background_Color;
    [self addWebView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *dic = [NSDictionary new];
        RequestApi *requset = [RequestApi shareInstance];
        [requset public_introduceWithApi:Public_introduce method:GET parameters:dic successBlock:^(id result) {
            if (requset.msgCode == 1) {
                [webView loadHTMLString:[result objectForKey:@"result"] baseURL:nil];
            }
        } failureBlock:^(NSString *message) {
            DDLogInfo(@"%@",message);
        }];
    });
    
    NSLog(@"%@",self.content);
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)loadRequest
{
   
}

- (void)addWebView
{
    webView = [[UIWebView alloc] init];
    webView.delegate = self;
    [webView loadHTMLString:@"" baseURL:nil];
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
    }];
    
 
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
    NSLog(@"start load");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"finish load");
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    [self baseHUDWithOnlyLabel:self.view withText:@"请向我们反馈"];
    if ([error code]== NSURLErrorCancelled) {
        return;
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
