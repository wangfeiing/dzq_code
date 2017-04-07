//
//  MenuItemView.m
//  dzq
//
//  Created by chentianyu on 16/1/24.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "MenuItemView.h"

@implementation MenuItemView

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
        self.imageView.contentMode = UIViewContentModeCenter;//图像居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;//内容居中
    }
    return self;
}

- (void)setTheDockItem:(DockItem *)dockItem
{
    self.dockItem = dockItem;


    [self setImage:[UIImage imageNamed:self.dockItem.icon] forState:UIControlStateNormal];//图像
    [self setTitle:self.dockItem.title forState:UIControlStateNormal];//文字
}

//重新设置button的图像和标题的位置
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, DOCK_ITEM_HEIGHT, DOCK_ITEM_HEIGHT);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, contentRect.origin.y+33, DOCK_ITEM_HEIGHT, DOCK_ITEM_HEIGHT);
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
}

@end
