//
//  LWKeyBoardView.m
//  dzq
//
//  Created by 梁伟 on 16/3/5.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "LWKeyBoardView.h"

static const CGFloat keyboardScrollViewHeigh = 80;
static const CGFloat keyboardPlayViewHeigh = 200;

@interface LWKeyboardView()
@property (nonatomic, assign)NSInteger keyInScreen;  // 屏幕上放的按键数 默认14
@property (nonatomic, assign)CGFloat maskViewOpcity; // 小键盘遮盖透明度 默认0.2
@property (nonatomic, assign)CGFloat scrollKeyboardHeigh; // 小键盘高度 默认80
@property (nonatomic, assign)CGFloat playKeyboardHeigh; // 大键盘高度 默认200
@property (nonatomic, assign)CGFloat blackKeyOpcity; // 黑键宽比白键宽 默认0.7

@property (nonatomic, strong)UIColor *scrollKeyboardHeighLightColor; // 小键盘高亮状态下显示的颜色 默认 [UIColor colorWithRed:0.4 green:0.8 blue:0.58 alpha:1]
@property (nonatomic, strong)UIColor *playKeyboardHeighLightColor; // 大键盘高亮状态下显示的颜色 默认 [UIColor colorWithRed:0.87 green:0.39 blue:0.38 alpha:1]
@property (nonatomic, strong)UIColor *fontColor; // 音符字体颜色 默认[UIColor colorWithRed:0.69 green:0.69 blue:0.69 alpha:1]
@property (nonatomic, assign)CGFloat *fontSize; // 音符字体大小 默认24

@property (nonatomic, strong)KeyboardScrollView *scrollView;
@property (nonatomic, strong)KeyboardPlayView *playView;

@end



@implementation LWKeyboardView

- (instancetype)initWithKeyNumber:(NSInteger)keyInScreen{
    self.keyInScreen = keyInScreen;
    return [self init];
}

- (instancetype)init{
    
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat width = screen.size.width;
    CGFloat heigh = screen.size.height;
    
    self = [super initWithFrame:CGRectMake(0, heigh - (keyboardPlayViewHeigh + keyboardScrollViewHeigh), width, keyboardScrollViewHeigh + keyboardPlayViewHeigh)];
    
    if (self) {
        
        self.scrollView = [[KeyboardScrollView alloc] initWithFrame:CGRectMake(0, 0, width, keyboardScrollViewHeigh)];
        self.scrollView.delegate = self;
        
        [self addSubview:self.scrollView];
        
        
        
        self.playView = [[KeyboardPlayView alloc] initWithFrame:CGRectMake(0, keyboardScrollViewHeigh, width, keyboardPlayViewHeigh)];
        self.playView.keyboardPlayViewDelegate = self;
        [self addSubview:self.playView];
        
        
        self.items = [[NSMutableArray alloc] init];
        
    }
    
    return self;
}

#pragma mark - Getter Setter

- (NSInteger)keyInScreen{
    if (_keyInScreen) {
        return _keyInScreen;
    }
    return 14;
}


- (void)scrollToRange:(RangeType)range{
  
    [self.scrollView scrollToIndex:36 - (range - RangeTypeC1)*7];
    
    
}


- (void)scrollToIndex:(NSInteger)index{
    
    [self.scrollView scrollToIndex:index];
    
}

- (void)touchWithViewTag:(NSInteger)tag touchDown:(BOOL)down{
    
    [self.playView showTouchWithTag:tag];
    [self.scrollView touchWithViewTag:tag touchDown:down];
    
}


#pragma mark - ScrollViewDelegate

- (void)keyboardScrollViewDidScrolled:(CGPoint)contentOffset{
    
    [self.playView setContentOffset:contentOffset];
    
}


- (void)keyboardScrollViewDidScrolledToIndex:(NSInteger)index{
    
    [self.playView scrollToIndex:index];
    
}


#pragma mark - PlayViewDelegate

- (void)touchWithKeyNote:(NSInteger)note isOn:(BOOL)on{
    
    if (on) {
        [self.items addObject:[NSNumber numberWithInteger:note]];
    }else{
        [self.items removeObject:[NSNumber numberWithInteger:note]];
    }
    
    
    [self.scrollView touchWithViewTag:note touchDown:on];
    [self.delegate touchWithKeyNote:note isOn:on];
    
}


@end
