//
//  StartPracticeViewController.m
//  dzq
//
//  Created by 梁伟 on 16/1/27.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "StartPracticeViewController.h"

#define BACK_GROUND_COLOR [UIColor colorWithRed:1 green:0.99 blue:0.95 alpha:1]
#define BUTTON_COLOR [UIColor colorWithRed:0.33 green:0.81 blue:0.6 alpha:1]

@interface StartPracticeViewController ()

@property (nonatomic, strong)MIDIManager *manager;
@property (nonatomic, strong)YYSampler *sampler;
@property (nonatomic, strong)AVAudioPlayer *player;

@property (nonatomic, strong)ReadGameEngine *gameEngine;
@property (nonatomic, assign, getter=isPrompted)BOOL prompt;

@property (nonatomic, strong)ProgressHUD *progressHUD;
@property (nonatomic, strong)StaffView *staffView;
@property (nonatomic, strong)NSMutableArray *answers;


@property (nonatomic, strong)GreatView *greatView;
@property (nonatomic, strong)AlertView *alertView;
@property (nonatomic, strong)LWKeyboardView *keyboardView; // 键盘
@property (nonatomic, strong)UIPregressStar *progressStar; // 星星
@property (nonatomic, strong)WFTimer *timer; // 时钟
@property (nonatomic, strong)UIImageView *connectPianoImageVIew; //显示连接钢琴视图
@property (nonatomic, strong)UILabel *connectLabel; // 连接标签

@property (nonatomic, strong)UIButton *exitButton; // 退出练习
@property (nonatomic, strong)UIButton *parseButton; // 暂停练习
@property (nonatomic, strong)UIButton *startButton; // 开始练习
@property (nonatomic, strong)UIButton *promptButton; // 提示





@property (nonatomic, strong)UIWindow *window;
@end


@implementation StartPracticeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _prompt = NO;
    
    self.view.backgroundColor = BACK_GROUND_COLOR;

    
    // 初始化 MIDIManager
    [self initMIDIManager];
    
    // 初始化 YYSamper
    _sampler = [[YYSampler alloc] init];
    [_sampler YYSamplerPath:2];

   
    
    // 初始化键盘
    _keyboardView = [[LWKeyboardView alloc] init];
    _keyboardView.delegate = self;
    [_keyboardView scrollToIndex:22];
    [self.view addSubview:_keyboardView];

    // 初始化五线谱
    switch (_staffType) {
        case StaffTypeBass:
            _staffView = [[BassStaffView alloc] init];
            break;
        case StaffTypeTreble:
            _staffView = [[TrebleStaffView alloc] init];
            break;
            
        case StaffTypeGrand:
            _staffView = [[GrandStaffView alloc] init];
            break;
    }
    _staffView.keySignatureType = KeySignatureType_C;
    [self.view addSubview:_staffView];


    
    // 初始化星星
    _progressStar = [[UIPregressStar alloc] initWithOriginPoint:CGPointMake(40, 30)];
    [self.view addSubview:_progressStar];
    
    // 初始化进度条
    _timer = [[WFTimer alloc] initWithCenterPosition:CGPointMake(780, 60) radius:40 internalRadius:35];
    _timer.delegate = self;
    [self.view addSubview:_timer];
    
    // 初始化其他视图
    [self initSubViews];
    
    
    _greatView = [[GreatView alloc] initWithCenter:CGPointMake(self.view.centerX, 100)];
    [self.view addSubview:_greatView];
    
    // 初始化 AlertView
    _alertView = [[AlertView alloc] init];
    _alertView.deleagte = self;
    [self.view addSubview:_alertView];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Init

- (void)initSubViews{
    
    CGFloat x = 30;
    CGFloat y = 220;
    
    // 开始练习按键
    _startButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 100, 40)];
    [_startButton setTitle:@"开始练习" forState:UIControlStateNormal];
    [_startButton setBackgroundColor:BUTTON_COLOR];
    _startButton.layer.cornerRadius = 2;
    
    [_startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_startButton];
    
    // 提示按键
    _promptButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y+70, 100, 40)];
    [_promptButton setTitle:@"提示" forState:UIControlStateNormal];
    [_promptButton setBackgroundColor:BUTTON_COLOR];
    [_promptButton addTarget:self action:@selector(promptPractice) forControlEvents:UIControlEventTouchDown];
    _promptButton.layer.cornerRadius = 2;
    [self.view addSubview:_promptButton];
    
    // 退出按键
    _exitButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50, 30, 30, 30)];
    [_exitButton setImage:[UIImage imageNamed:@"exit_button.png"] forState:UIControlStateNormal];
    [_exitButton addTarget:self action:@selector(showExitAlertView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_exitButton];
    
    // 暂停按键
    _parseButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-90, 30, 30, 30)];
    [_parseButton setImage:[UIImage imageNamed:@"parse_button.png"] forState:UIControlStateNormal];
    _parseButton.hidden = YES;
    [_parseButton addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_parseButton];

}


- (void)initMIDIManager{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        self.manager = [[MIDIManager alloc] init];
        self.manager.delegate = self;
    });
}

- (void)showMessage:(NSString *)message{
    
    if (!_progressHUD) {
        _progressHUD = [[ProgressHUD alloc] init];
    }
    
    [_progressHUD HUDWithOnlyLabel:self.view withText:message delay:2];
    
    
}




#pragma mark - Action  Event


// 游戏开始
- (void)start{
    
    if (_startButton.selected) {
        [_alertView showRestartAlertView];
        return;
    }
    
    _startButton.selected = YES;
    
    _parseButton.hidden = NO;
    
    [_progressStar reset];
    
    [_startButton setTitle:@"重新开始" forState:UIControlStateNormal];
    
    NSMutableArray *models = [ReadPracticeModel createReadPracticesWithStaffType:_staffType keySignatureTypes:_keySignatures polyphoneType:_polyphoneType testCount:10];
    _gameEngine = [[ReadGameEngine alloc] initWithPracticeItems:models];
    _gameEngine.delegate = self;
    
    
    _gameEngine.state = GameStateStart;
    
    
    [self newPracticeWithIndex:_gameEngine.index];
    
    
}


// 暂停功能
- (void)pause{
    
    
//    [self.timer parse];
    [_alertView showPauseAlertView];
    
}



// 提示功能
- (void)promptPractice{
    
    _prompt = YES;
    
    ReadPracticeModel *practiceModel = _gameEngine.presentModel;
    [self.keyboardView scrollToRange:practiceModel.range];
    
    NSMutableArray *items = practiceModel.items;
    
    for (NSNumber *num in items) {
        NSInteger note = [num integerValue];
        
        [self.keyboardView touchWithViewTag:note touchDown:YES];
        
    }
    
}

// 退出练习

- (void)showExitAlertView{
    
    [_alertView showExitAlertView];
    
}

- (void)exited{
    [self dismissViewControllerAnimated:YES completion:nil];
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


#pragma mark - WFTimerDelegate

- (void)timeIsOut{
    [self promptPractice];
}



#pragma mark - PianoKeyBoardViewDelegate


- (void)touchWithKeyNote:(NSInteger)note isOn:(BOOL)on{
    
    [_sampler triggerNote:note isOn:on];
    
    [_staffView errorNoteImage:note showOrDismiss:on];
    
    if (on) {
        [_gameEngine answerOfUserInput:_keyboardView.items];
    }
    
    NSLog(@"****");
    for (NSNumber *note in _keyboardView.items) {
        NSLog(@"%@",note);
    }

}

- (void)showTest{
    
    
    ReadPracticeModel *model = _gameEngine.presentModel;
    
    _staffView.keySignatureType = model.keySignature;
    
    [_keyboardView scrollToRange:model.range];
    
    for (NSNumber *number in model.items) {
        
        NSInteger note = [number integerValue];
        
        [_staffView showNoteViewWithNote:note state:NoteViewStateError];
        
        [_sampler triggerNote:note isOn:YES];
        [self performBlock:^{
            
            [_sampler triggerNote:note isOn:NO];
            
        } afterDelay:0.5f];
        
        
    }

    
}


#pragma mark - GameEngineDelegate

- (void)practiceFinished{
    
    [_alertView showCompleteAlertViewWithResult:_progressStar.rightNum];
    
}

- (void)newPracticeWithIndex:(NSInteger)index{
    
    [_timer reset];
    _prompt = NO;

    
    [self performBlock:^{
        
        [self showTest];
        [_timer start];
        
        
    } afterDelay:2];
    
}

- (void)practiceResult:(BOOL)result number:(NSInteger)index{
    
    if (result) {
        
        [self rightResult];
        [_greatView showGreat];
        
        if (_prompt) {
            [_progressStar addWrongStarWith:index];
        }else{
            [_progressStar addRightStarWith:index];
        }
        
    }else{
        
//        [self falseResult];
    
    }
    
    
}

#pragma mark - AlertViewDelegate

- (void)exitPractice{
    [self exited];
}

- (void)restartPractice{
    _startButton.selected = NO;
    [self start];
    [_alertView dismiss];
}

- (void)alertViewDidAppear{
    [_timer parse];
}

- (void)alertViewDidDismiss{
    
}

// 暂停－继续
- (void)continuePractice{
    [_timer continueTime];
    [_alertView dismiss];
}


@end
