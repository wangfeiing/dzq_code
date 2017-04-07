//
//  AlertView.h
//  dzq
//
//  Created by 梁伟 on 16/3/31.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlertViewDelegate <NSObject>

- (void)alertViewDidAppear;
- (void)alertViewDidDismiss;
- (void)restartPractice;
- (void)exitPractice;
- (void)continuePractice;

@end


@interface AlertView : UIWindow
@property (nonatomic, weak)id<AlertViewDelegate> deleagte;

@property (nonatomic, assign)CGFloat alph;

@property (nonatomic, strong)UIView *presentAlertView;
@property (nonatomic, strong)UIView *exitAlertView;
@property (nonatomic, strong)UIView *pauseAlertView;
@property (nonatomic, strong)UIView *messageAlertView;
@property (nonatomic, strong)UIView *restartAlertView;
@property (nonatomic, strong)UIView *completeAlertView;

- (void)display;
- (void)dismiss;

- (void)showMessage:(NSString *)message;

- (void)showCompleteAlertViewWithResult:(NSInteger)result;

- (void)showRestartAlertView;

- (void)showPauseAlertView;

- (void)showExitAlertView;

@end
