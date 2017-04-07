//
//  MenuView.m
//  dzq
//
//  Created by chentianyu on 16/1/24.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "MenuView.h"

@implementation MenuView

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
        [self addDockItems];
        [self addMenuItemViews];
            
        self.frame = CGRectMake(0, 2*DOCK_ITEM_HEIGHT, DOCK_ITEM_HEIGHT, 3*DOCK_ITEM_HEIGHT);
        
    }
    
    return self;
}

- (void)addDockItems
{
    self.dockItems = @[
                       [DockItem itemWithIcon:@"sl" title:@"谱库" className:@"SLViewController" modal:NO],
                       [DockItem itemWithIcon:@"teaching" title:@"教学" className:@"TeachingViewController" modal:NO],
                       [DockItem itemWithIcon:@"personal" title:@"个人中心" className:@"PersonalViewController" modal:NO],
                       ];
}

- (void)addMenuItemViews
{
    
    int count = (int)self.dockItems.count;
    for (int i = 0; i < count; i++) {
        MenuItemView *menu = [[MenuItemView alloc] initWithFrame:CGRectMake(0, i*DOCK_ITEM_HEIGHT, self.frame.size.width, DOCK_ITEM_HEIGHT)];

        menu.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [menu setTheDockItem:self.dockItems[i]];
        if (i == 0) {
            [menu setEnabled:NO];
            self.currentItemView = menu;
            
        }
        [menu addTarget:self action:@selector(menuItemClick:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:menu];
    }
}


- (void)unselectAll
{   [self.currentItemView setEnabled:YES];
    self.currentItemView.selected = NO;
    self.currentItemView = nil;
}

#pragma mark - 菜单单击
- (void)menuItemClick:(MenuItemView *)sender
{

//        NSLog(@"aaa");
        [sender setEnabled:NO];
        [self.currentItemView setEnabled:YES];
        self.currentItemView.selected = NO;
        sender.selected = YES;
        self.currentItemView = sender;

    
    //事件传给block
    if (self.menuItemClickBlock) {
        self.menuItemClickBlock(sender.dockItem);
    }
    
}
@end
