//
//  DataDetailViewController.h
//  dzq
//
//  Created by chentianyu on 16/1/27.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataDetailViewController : UIViewController<UIWebViewDelegate,UIScrollViewDelegate>


@property(nonatomic,strong)NSString *dataTitle;
@property(nonatomic,strong)NSString *dataContent;
@property(nonatomic,strong)UIWebView *webView;
-(instancetype)initWithDataTitle:(NSString *)dataTitle dataContent:(NSString *)dataContent;



@end
