//
//  PianoKeyBoardView.h
//  dzq
//
//  Created by 梁伟 on 16/2/19.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITouch+PianoKey.h"

@protocol KeyboardPlayViewDelegate <NSObject>


@required
- (void)touchWithKeyNote:(NSInteger)note isOn:(BOOL)on;

@end



@interface KeyboardPlayView : UIScrollView 
@property (nonatomic, weak) id <KeyboardPlayViewDelegate> keyboardPlayViewDelegate;

- (void)scrollToIndex:(NSInteger)index;

- (void)touchWithTag:(NSInteger)tag isOn:(BOOL)on;

- (void)showTouchWithTag:(NSInteger)tag;

@end
