//
//  PianoKeyView.h
//  dzq
//
//  Created by 梁伟 on 16/2/20.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol KeyboardScrollViewDelegate <NSObject>
@required
@optional

- (void)keyboardScrollViewDidScrolled:(CGPoint)contentOffset;

- (void)keyboardScrollViewDidScrolledToIndex:(NSInteger)index;

@end



@interface KeyboardScrollView : UIView <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id<KeyboardScrollViewDelegate> delegate;
@property (nonatomic, assign) CGFloat maskViewOpacity;
@property (nonatomic, assign) NSInteger keyInScreen;

- (instancetype)initWithFrame:(CGRect)frame keyNumber:(NSInteger)number;

- (void)scrollToIndex:(NSInteger)index;

- (void)touchWithViewTag:(NSInteger)tag touchDown:(BOOL)down;

//- (void)touchDownKeyViewWithTag:(NSInteger)tag;


@end
