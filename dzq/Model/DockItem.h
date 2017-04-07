//
//  DockItem.h
//  dzq
//
//  Created by chentianyu on 16/1/24.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DockItem : NSObject

@property (nonatomic, copy) NSString *icon; // 图标
@property (nonatomic, copy) NSString *title; // 文字
@property (nonatomic, copy) NSString *className; // 点击Item要打开的控制器
@property (nonatomic, assign) BOOL modal; // 是否以模态窗口的形式展示

+ (id)itemWithIcon:(NSString *)icon title:(NSString *)title className:(NSString *)className modal:(BOOL)modal;
+ (id)itemWithIcon:(NSString *)icon title:(NSString *)title className:(NSString *)className;

+ (id)itemWithIcon:(NSString *)icon className:(NSString *)className modal:(BOOL)modal;
+ (id)itemWithIcon:(NSString *)icon className:(NSString *)className;

@end
