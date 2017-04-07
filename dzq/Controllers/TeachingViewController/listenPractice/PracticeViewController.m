//
//  PracticeViewController.m
//  dzq
//
//  Created by wangfei on 16/1/27.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "PracticeViewController.h"

#define BACK_GROUND_COLOR [UIColor colorWithRed:1 green:0.99 blue:0.95 alpha:1]
#define BUTTON_COLOR [UIColor colorWithRed:0.33 green:0.81 blue:0.6 alpha:1]

@interface PracticeViewController (){
    NSInteger timerNumber;
    NSTimer *time;
    CGFloat resultNum;
}
@property (nonatomic, strong)GreatView *greatView;
@property (nonatomic, strong)YYSampler *sampler;
@property (nonatomic, strong)MIDIManager *manager;
@property (nonatomic, strong)ListenGameEngine *gameEngine;
@property (nonatomic, assign)BOOL prompt;

@property (nonatomic, strong)AVAudioPlayer *player;

@property (nonatomic, strong)ProgressHUD *progressHUD;

@property (nonatomic, strong)MessageView *messageView;
@property (nonatomic, strong)AlertView *alertView;
@property (nonatomic, strong)LWKeyboardView *keyboardView;
@property (nonatomic, strong)UIPregressStar *progressStar;
@property (nonatomic, strong)WFTimer *timer;
@property (nonatomic, strong)StaffView *staffView;

@property (nonatomic, strong)UIButton *exitButton; // 退出练习
@property (nonatomic, strong)UIButton *parseButton; // 暂停练习
@property (nonatomic, strong)UIButton *lstnAginBtn; // 重听试题
@property (nonatomic, strong)UIButton *lstnTstbtn; // 试听标准音
@property (nonatomic, strong)UIButton *promBtn; // 提示

@end

@implementation PracticeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    timerNumber = 0;
    resultNum = 0;
    
    NSMutableArray *models = [ListenPracticeModel createListenPracticesWithRangeTypes:_range ployphoneType:_polyphone practiceNumber:10];
    _gameEngine = [[ListenGameEngine alloc] initWithPracticeItems:models];
    _gameEngine.delegate = self;
    
    self.view.backgroundColor = BACK_GROUND_COLOR;
    
    // MIDI
    _manager = [[MIDIManager alloc] init];
    
    _sampler = [[YYSampler alloc] init];
    [_sampler YYSamplerPath:2];

    _keyboardView = [[LWKeyboardView alloc] init];
    _keyboardView.delegate = self;
    [self.view addSubview:_keyboardView];

    _staffView = [[GrandStaffView alloc] init];
    _staffView.keySignatureType = KeySignatureType_C;
    [self.view addSubview:_staffView];

    _progressStar = [[UIPregressStar alloc] initWithOriginPoint:CGPointMake(40, 30)];
    [self.view addSubview:_progressStar];

    _timer = [[WFTimer alloc] initWithCenterPosition:CGPointMake(780, 60) radius:40 internalRadius:35];
    _timer.delegate = self;
    [self.view addSubview:_timer];
    
    [self initSubViews];
    
    _greatView = [[GreatView alloc] initWithCenter:CGPointMake(self.view.centerX, 100)];
    [self.view addSubview:_greatView];
    
    _alertView = [[AlertView alloc] init];
    _alertView.deleagte = self;
    [self.view addSubview:_alertView];

}

//初始化视图
- (void)initSubViews{
    
    CGFloat x = 30;
    CGFloat y = 180;
    
    _lstnTstbtn = [self buttonWithFrame:CGRectMake(x, y, 100, 40) title:@"试听标准音"];
    [_lstnTstbtn addTarget:self action:@selector(playMiddleCSound) forControlEvents:UIControlEventTouchUpInside];
    
    _lstnAginBtn = [self buttonWithFrame:CGRectMake(x, y+70, 100, 40) title:@"重听试题"];
    [_lstnAginBtn addTarget:self action:@selector(playTest) forControlEvents:UIControlEventTouchUpInside];
    
    _promBtn = [self buttonWithFrame:CGRectMake(x, y+140, 100, 40) title:@"提示"];
    [_promBtn addTarget:self action:@selector(promptTest) forControlEvents:UIControlEventTouchUpInside];
    
    _exitButton = [[UIButton alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-50, 30, 30, 30)];
    [_exitButton setImage:[UIImage imageNamed:@"exit_button.png"] forState:UIControlStateNormal];
    [_exitButton addTarget:self action:@selector(showExitAlertView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_exitButton];
    
    _parseButton = [[UIButton alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-90, 30, 30, 30)];
    [_parseButton addTarget:self action:@selector(showPauseAlertView) forControlEvents:UIControlEventTouchUpInside];
    [_parseButton setImage:[UIImage imageNamed:@"parse_button.png"] forState:UIControlStateNormal];
    [self.view addSubview:_parseButton];
    
  
}

- (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title{
    
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    [btn setBackgroundColor:BUTTON_COLOR];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.layer.cornerRadius = 2;
    [self.view addSubview:btn];
    
    return btn;
    
}




- (void)showMessage:(NSString *)message{
    
    if (!_progressHUD) {
        _progressHUD = [[ProgressHUD alloc] init];
    }
        
    [_progressHUD HUDWithOnlyLabel:self.view withText:message delay:2];
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidAppear:(BOOL)animated{
    
    // 准备练习
    [self readlyPractice];
    
}



#pragma mark - Action Event

// 准备练习 - 播放标准音
- (void)readlyPractice{
    
    [_keyboardView scrollToIndex:22];
    [_keyboardView touchWithViewTag:60 touchDown:YES];
    
    [_alertView showMessage:@"正在播放标准音"];
    [_alertView display];
    
    timerNumber = 0;
    
    time = [NSTimer scheduledTimerWithTimeInterval:0.7f target:self selector:@selector(playStandardSound) userInfo:nil repeats:YES];
    
}

// 播放连续标准音
- (void)playStandardSound{
    
    int list[] = {0, 2, 4, 5, 7, 9, 11};
    
    if (timerNumber != 0) {
        [_sampler triggerNote:60+list[timerNumber-1] isOn:NO];
    }
    
    if (timerNumber != 7) {
        [_sampler triggerNote:60+list[timerNumber] isOn:YES];
    }
    
    timerNumber++;
    
    if (timerNumber == 8) {
        [time invalidate];
        
        CGRect frame = _alertView.frame;
        
        [UIView animateWithDuration:0.5f animations:^{
            
            // 遮罩上移，显示键盘
            _alertView.frame = CGRectMake(frame.origin.x, frame.origin.y - 280, frame.size.width, frame.size.height);
            
        } completion:^(BOOL finished) {
            
            [_alertView showMessage:@"点击红键进入练习"];
            _gameEngine.state = GameStateReady;
            
        }];
    }
    
}




// 播放当前试题
- (void)playTest{
    
    ListenPracticeModel *model = _gameEngine.presentModel;
    
    [_keyboardView scrollToRange:model.range];
    
    for (NSNumber *number in model.items) {
        
        NSInteger note = [number integerValue];
        
        [_sampler triggerNote:note isOn:YES];
        [self performBlock:^{
            
            [_sampler triggerNote:note isOn:NO];
            
        } afterDelay:0.5f];
        
        
    }
    
}

// 试听标准音 60
- (void)playMiddleCSound{
    
    [self playNote:60];
    
}

// 播放指定音
- (void)playNote:(NSInteger)note{
    
    [_sampler triggerNote:note isOn:YES];
    
    [self performBlock:^{
        
        [_sampler triggerNote:note isOn:NO];
        
    } afterDelay:0.5f];
    
}

// 提示

- (void)promptTest{
    
    ListenPracticeModel *model = _gameEngine.presentModel;
    
    _prompt = YES;
    
    [_keyboardView scrollToRange:model.range];
    
    for (NSNumber *noteNumber in model.items) {
        
        [_keyboardView touchWithViewTag:[noteNumber integerValue] touchDown:YES];
        
    }
    
}

// 退出练习
- (void)showExitAlertView{
    
    [_alertView showExitAlertView];
    
}

- (void)showPauseAlertView{
    
    [_alertView showPauseAlertView];
    
}

- (void)exited{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)restart{
    
    [_timer reset];
    [_progressStar reset];
    
    [self readlyPractice];
    
    
}

- (void)continued{
    
    
    
}

- (void)falseResult{
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"false.mp3" withExtension:nil];
    
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    [self performBlock:^{
        
        [_player prepareToPlay];
        [_player play];
        
    } afterDelay:0.3];
    


}

- (void)rightResult{
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"right.mp3" withExtension:nil];
    
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    [self performBlock:^{
        
        [_player prepareToPlay];
        [_player play];
        
    } afterDelay:0.3];
    
    

}

#pragma mark - Keyborad Delegate

- (void)touchWithKeyNote:(NSInteger)note isOn:(BOOL)on{
    
    if (on) {
        [_gameEngine answerOfUserInput:self.keyboardView.items];
    }
    
    [_sampler triggerNote:note isOn:on];
    
    [_staffView errorNoteImage:note showOrDismiss:on];
    
    
}

#pragma mark - GameEngineDelegate

// 开始练习
- (void)practiceStart{
    
    [_alertView dismiss];
    _alertView.frame = [UIScreen mainScreen].bounds;
    
}


/*
 * 练习结果
 */
- (void)practiceResult:(BOOL)result number:(NSInteger)index{
    
    if (result) {
        
        [self rightResult];
        [_greatView showGreat];
        
        if (_prompt) {
            [_progressStar addWrongStarWith:index];
        }else{
            result++;
            [_progressStar addRightStarWith:index];
        }
        
    }else{
        
//        [self falseResult];
        
    }
    
}


/// 新的练习
- (void)newPracticeWithIndex:(NSInteger)index{
    
    [_timer reset];
    _prompt = NO;

    [self performBlock:^{
        
        [self playTest];
        [_timer reset];
        [_timer start];
        
        
    } afterDelay:2];
    
}



/// 练习完成
- (void)practiceFinished{
    
    [_timer reset];
    [_alertView showCompleteAlertViewWithResult:_progressStar.rightNum];
    [_alertView display];
    
}

#pragma mark - WFTimerDelegate

/// 时间到
- (void)timeIsOut{
    
    [self promptTest];
    
}

#pragma mark - AlertViewDelegate

- (void)restartPractice{
    
    [self restart];
//    [_alertView dismiss];
    
}

- (void)exitPractice{
    
    [self exited];
    
}

- (void)continuePractice{
    
    [_timer continueTime];
    [_alertView dismiss];
    
}

- (void)alertViewDidDismiss{
    
}

- (void)alertViewDidAppear{
    [_timer parse];
}


@end
