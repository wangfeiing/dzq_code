//
//  TeachingViewController.h
//  dzq
//
//  Created by chentianyu on 16/1/24.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataViewController.h"
#import "ListenPracticeViewController.h"
#import "ReadPracticeViewController.h"

@interface TeachingViewController : UIViewController


@property(nonatomic,strong)DataViewController *dataViewController;
@property(nonatomic,strong)ListenPracticeViewController *listenPracticeViewController;
@property(nonatomic,strong)ReadPracticeViewController *readPracticeViewController;


@property(nonatomic,strong)UIView *readPracticeView;
@property(nonatomic,strong)UIView *listenPracticeView;
@property(nonatomic,strong)UIView *teacingDataView;

@end
