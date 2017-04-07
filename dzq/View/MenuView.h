//
//  MenuView.h
//  dzq
//
//  Created by chentianyu on 16/1/24.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DockItem.h"
#import "TeachingViewController.h"
#import "MenuItemView.h"
@interface MenuView : UIView

@property(nonatomic,strong)NSArray *dockItems;

@property(nonatomic,copy) void (^menuItemClickBlock)(DockItem *item);

@property(nonatomic,strong)MenuItemView *currentItemView;

//取消选中全部
- (void)unselectAll;


@end
