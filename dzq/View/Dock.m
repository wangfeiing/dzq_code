//
//  Dock.m
//  dzq
//
//  Created by chentianyu on 16/1/24.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "Dock.h"
#import "SettingViewController.h"

@implementation Dock

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, DOCK_WIDTH, DOCK_HEIGHT);
        self.backgroundColor = DOCK_BACKGROUNDCOLOR;
        
        //头像:不用添加单击事件
        self.avatarView = [[AvatarView alloc] init];
        
//        [self.avatarView addTarget:self action:@selector(avatarClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.avatarView];
        
        
        
        //菜单
        self.menuView = [[MenuView alloc] init];
        __unsafe_unretained Dock *dock = self;
        self.menuView.menuItemClickBlock = ^(DockItem *item){
            if (dock.dockItemClickBlock) {
                dock.dockItemClickBlock(item);
            }
        };
        [self addSubview:self.menuView];

        //设置
        SettingView *settingView = [[SettingView alloc] init];
        [settingView addTarget:self action:@selector(settingViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:settingView];
        
        
    }
    return self;
}

//- (void)avatarClick:(UIButton *)sender
//{
//
//    [self.menuView unselectAll];
////    if (self.dockItemClickBlock) {
////        DockItem *item = [DockItem itemWithIcon:nil className:@"AvatarViewController"];
////        self.dockItemClickBlock(item);
////    }
//}

#pragma mark -- 点击设置
- (void)settingViewClick:(SettingView *)sender
{
    NSLog(@"点击设置");
//    [self.menuView unselectAll];
    if (self.dockItemClickBlock) {
        DockItem *item = [DockItem itemWithIcon:nil className:@"SettingViewController"];
        
        
//        DockItem *item = [DockItem itemWithIcon:nil className:@"" modal:YES];
        self.dockItemClickBlock(item);
        
        
//        SettingView
    }
    
//    SettingViewController *settingViewController = [[SettingViewController alloc] init];
//    self.
    
}

@end
