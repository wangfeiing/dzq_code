//
//  TeachingViewController.m
//  dzq
//
//  Created by chentianyu on 16/1/24.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "TeachingViewController.h"



@interface TeachingViewController ()

@end

@implementation TeachingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //识谱练习
    self.readPracticeViewController = [[ReadPracticeViewController alloc] init];
    self.readPracticeView = self.readPracticeViewController.view;
    self.readPracticeView.frame = CGRectMake(0, STATUS_HEIGTH, [[UIScreen mainScreen] bounds].size.width-DOCK_WIDTH, [[UIScreen mainScreen] bounds].size.height-STATUS_HEIGTH);
    [self.view addSubview:self.readPracticeView];
    self.readPracticeViewController.superController = self;
    
    //教学资料
    self.dataViewController   =[[DataViewController alloc] init];
    self.teacingDataView = self.dataViewController.view;
    self.teacingDataView.frame = CGRectMake(0-([[UIScreen mainScreen] bounds].size.width-DOCK_WIDTH), STATUS_HEIGTH, [[UIScreen mainScreen] bounds].size.width-DOCK_WIDTH, [[UIScreen mainScreen] bounds].size.height-STATUS_HEIGTH);
    [self.view addSubview:self.teacingDataView];
    
    
    //听音练习
    self.listenPracticeViewController   = [[ListenPracticeViewController alloc] init];
    self.listenPracticeView = self.listenPracticeViewController.view;
    self.listenPracticeView.frame = CGRectMake(0+([[UIScreen mainScreen] bounds].size.width-DOCK_WIDTH), STATUS_HEIGTH, [[UIScreen mainScreen] bounds].size.width-DOCK_WIDTH, [[UIScreen mainScreen] bounds].size.height-STATUS_HEIGTH);
    self.listenPracticeViewController.superViewController = self;
    [self.view addSubview:self.listenPracticeView];

    
    
    
    
    [self addTitle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addTitle
{
    NSArray *titleArray = @[@"识谱练习",@"听音练习",@"教学资料"];
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:titleArray];

    self.navigationItem.titleView = segmentControl;
    [segmentControl addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventValueChanged];
    segmentControl.selectedSegmentIndex = 0;
    segmentControl.tintColor = [UIColor colorWithRed:0.13 green:0.51 blue:0.26 alpha:1.00];
    
    for (int i=0; i<segmentControl.numberOfSegments; i++) {
        [segmentControl setWidth:140 forSegmentAtIndex:i];
    }
    
}

- (void)titleClick:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            DDLogInfo(@"识谱练习");
            [self addReadPracticeView];
            break;
          
        case 1:
            DDLogInfo(@"听音练习");
            [self addListenPracticeView];
            break;
            
        default:
            DDLogInfo(@"教学资料");

            [self addTeachingDataView];
            break;
    }
}

#pragma mark - 识谱练习
- (void)addReadPracticeView
{
    self.readPracticeView.frame = CGRectMake(0, STATUS_HEIGTH, [[UIScreen mainScreen] bounds].size.width-DOCK_WIDTH, [[UIScreen mainScreen] bounds].size.height-STATUS_HEIGTH);
    self.listenPracticeView.frame = CGRectMake(0+([[UIScreen mainScreen] bounds].size.width-DOCK_WIDTH), STATUS_HEIGTH, [[UIScreen mainScreen] bounds].size.width-DOCK_WIDTH, [[UIScreen mainScreen] bounds].size.height-STATUS_HEIGTH);
    self.teacingDataView.frame = CGRectMake(0-([[UIScreen mainScreen] bounds].size.width-DOCK_WIDTH), STATUS_HEIGTH, [[UIScreen mainScreen] bounds].size.width-DOCK_WIDTH, [[UIScreen mainScreen] bounds].size.height-STATUS_HEIGTH);
    
    self.readPracticeView.hidden = NO;
    self.teacingDataView.hidden = YES;
    self.listenPracticeView.hidden = YES;
}
#pragma mark - 听音练习
- (void)addListenPracticeView
{
    self.readPracticeView.frame = CGRectMake(0-([[UIScreen mainScreen] bounds].size.width-DOCK_WIDTH), STATUS_HEIGTH, [[UIScreen mainScreen] bounds].size.width-DOCK_WIDTH, [[UIScreen mainScreen] bounds].size.height-STATUS_HEIGTH);
    self.listenPracticeView.frame = CGRectMake(0, STATUS_HEIGTH, [[UIScreen mainScreen] bounds].size.width-DOCK_WIDTH, [[UIScreen mainScreen] bounds].size.height-STATUS_HEIGTH);
    self.teacingDataView.frame = CGRectMake(0+([[UIScreen mainScreen] bounds].size.width-DOCK_WIDTH), STATUS_HEIGTH, [[UIScreen mainScreen] bounds].size.width-DOCK_WIDTH, [[UIScreen mainScreen] bounds].size.height-STATUS_HEIGTH);
    
    self.readPracticeView.hidden = YES;
    self.teacingDataView.hidden = YES;
    self.listenPracticeView.hidden = NO;
}

#pragma mark - 教学资料
- (void)addTeachingDataView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"presentTeachDataView" object:nil];
    self.readPracticeView.frame = CGRectMake(0+([[UIScreen mainScreen] bounds].size.width-DOCK_WIDTH), STATUS_HEIGTH, [[UIScreen mainScreen] bounds].size.width-DOCK_WIDTH, [[UIScreen mainScreen] bounds].size.height-STATUS_HEIGTH);
    self.listenPracticeView.frame = CGRectMake(0-([[UIScreen mainScreen] bounds].size.width-DOCK_WIDTH), STATUS_HEIGTH, [[UIScreen mainScreen] bounds].size.width-DOCK_WIDTH, [[UIScreen mainScreen] bounds].size.height-STATUS_HEIGTH);
    self.teacingDataView.frame = CGRectMake(0, STATUS_HEIGTH, [[UIScreen mainScreen] bounds].size.width-DOCK_WIDTH, [[UIScreen mainScreen] bounds].size.height-STATUS_HEIGTH);
    
    self.readPracticeView.hidden = YES;
    self.teacingDataView.hidden = NO;
    self.listenPracticeView.hidden = YES;
}
@end
