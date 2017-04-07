//
//  MenuItemView.h
//  dzq
//
//  Created by chentianyu on 16/1/24.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DockItem.h"


@interface MenuItemView : UIButton


@property(nonatomic,strong)DockItem *dockItem;
- (void)setTheDockItem:(DockItem *)dockItem;
@end
