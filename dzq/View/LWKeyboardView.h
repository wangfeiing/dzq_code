//
//  LWKeyBoardView.h
//  dzq
//
//  Created by 梁伟 on 16/3/5.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaffType.h"
#import "KeyboardScrollView.h"

#import "KeyboardPlayView.h"



@protocol LWKeyboardViewDelegate <NSObject>


- (void)touchWithKeyNote:(NSInteger)note isOn:(BOOL)on;


@end


@interface LWKeyboardView : UIView <KeyboardPlayViewDelegate, KeyboardScrollViewDelegate>
@property (nonatomic, weak) id<LWKeyboardViewDelegate> delegate;
@property (nonatomic, strong)NSMutableArray *items;

- (instancetype)initWithKeyNumber:(NSInteger)keyInScreen;

// 滑动到指定音域
- (void)scrollToRange:(RangeType)range;

// 滑动到指定键
- (void)scrollToIndex:(NSInteger)index;

// 按下指定键
- (void)touchWithViewTag:(NSInteger)tag touchDown:(BOOL)down;

@end
