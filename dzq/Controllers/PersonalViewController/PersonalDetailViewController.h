//
//  PersonalDetailViewController.h
//  dzq
//
//  Created by chentianyu on 16/4/12.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PersonalInfoViewController.h"
#import "PersonalCollectViewController.h"
#import "PersonalViewerViewController.h"
#import "PersonalPracticeViewController.h"
#import <Masonry/Masonry.h>

@interface PersonalDetailViewController : BaseViewController

@property(nonatomic,assign)NSString *personalIndex;
@property(nonatomic,strong)PersonalInfoViewController *personalInfo;
@property(nonatomic,strong)PersonalCollectViewController *personalCollect;
@property(nonatomic,strong)PersonalViewerViewController *personalViewer;
@property(nonatomic,strong)PersonalPracticeViewController *personalPractice;



- (void)updateView:(NSInteger)row;
@end
