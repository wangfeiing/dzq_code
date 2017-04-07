//
//  HomeViewController.h
//  dzq
//
//  Created by chentianyu on 16/1/24.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dock.h"
#import "SLViewController.h"
//#import "Header.h"
//#import <CocoaLumberjack/CocoaLumberjack.h>


@interface HomeViewController : UIViewController

@property(nonatomic,strong)Dock *dock;
@property(nonatomic,strong)NSMutableDictionary *allChilds;
@property(nonatomic,strong)UINavigationController *currentChild;
@end
