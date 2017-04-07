//
//  AboutViewController.h
//  dzq
//
//  Created by chentianyu on 16/4/3.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "BaseViewController.h"

@interface AboutViewController : BaseViewController<UIWebViewDelegate>

@property(nonatomic,strong)NSString *content;
@end
