//
//  Dock.h
//  dzq
//
//  Created by chentianyu on 16/1/24.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AvatarView.h"
#import "MenuView.h"
#import "SettingView.h"

@interface Dock : UIView


@property(nonatomic,strong)AvatarView *avatarView;
@property(nonatomic,strong)MenuView *menuView;
@property(nonatomic,copy)void (^dockItemClickBlock)(DockItem *item);

@end
