//
//  AlertView.m
//  dzq
//
//  Created by 梁伟 on 16/3/31.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#define BUTTON_COLOR [UIColor colorWithRed:0.33 green:0.81 blue:0.6 alpha:1]
#import "AlertView.h"

@interface AlertView()

@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *rightLabel;
@property (nonatomic, strong)UILabel *wrongLabel;
@property (nonatomic, strong)UILabel *accuracyLabel;

@end

@implementation AlertView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.frame = [[UIScreen mainScreen] bounds];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.windowLevel = UIWindowLevelAlert;
        self.hidden = YES;

    }
    return self;
}


- (void)setAlph:(CGFloat)alph{
    
    _alph = alph;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:_alph];
    
}


- (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title{
    
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    btn.backgroundColor = BUTTON_COLOR;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.layer.cornerRadius = 2;
    
    return btn;
}

- (UILabel *)labelWithText:(NSString *)text{
    return [self labelWithText:text color:nil fontSize:0];
}

- (UILabel *)labelWithText:(NSString *)text color:(UIColor *)color fontSize:(CGFloat)size{
    
    UILabel *label = [[UILabel alloc] init];
    
    if (!size) {
        size = 20;
    }
    label.font = [UIFont boldSystemFontOfSize:size];
    
    label.text = text;
    [label sizeToFit];
    
    if (!color) {
        color = BUTTON_COLOR;
    }
    label.textColor = color;

    return label;
}

#pragma mark - MessageAlterView

- (void)initMessageAlertView{
    
    _titleLabel = [self labelWithText:nil color:nil fontSize:0];
    
    _messageAlertView = [[UIView alloc] init];
    _messageAlertView.backgroundColor = [UIColor whiteColor];
    _messageAlertView.layer.cornerRadius = 8;
    _messageAlertView.center = self.center;
    _messageAlertView.hidden = YES;
    
    [_messageAlertView addSubview:_titleLabel];
    [self addSubview:_messageAlertView];
    
}

- (void)showMessage:(NSString *)message{
    
    if (!_messageAlertView) {
        [self initMessageAlertView];
    }
    
    _titleLabel.text = message;
    [_titleLabel sizeToFit];
    
    CGSize labelSize = _titleLabel.bounds.size;
    
    _messageAlertView.bounds = CGRectMake(0, 0, labelSize.width+40, labelSize.height+40);
    _titleLabel.frame = CGRectMake(20, 20, labelSize.width, labelSize.height);
    
    
    if (_presentAlertView) {
        _presentAlertView.hidden = YES;
    }
    
    _messageAlertView.hidden = NO;
    _presentAlertView = _messageAlertView;
    
    
    [self display];
    
}


#pragma mark - CompleteAlterView

- (void)initCompleteAlertView{
    
    _completeAlertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 250)];
    _completeAlertView.backgroundColor = [UIColor whiteColor];
    _completeAlertView.layer.cornerRadius = 8;
    _completeAlertView.center = self.center;
    _completeAlertView.hidden = YES;
    [self addSubview:_completeAlertView];
    
    _rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 40, 100, 20)];
    _rightLabel.textColor = BUTTON_COLOR;
    _rightLabel.font = [UIFont boldSystemFontOfSize:20];
    [_completeAlertView addSubview:_rightLabel];
    
    _wrongLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 75, 100, 20)];
    _wrongLabel.textColor = BUTTON_COLOR;
    _wrongLabel.font = [UIFont boldSystemFontOfSize:20];
    [_completeAlertView addSubview:_wrongLabel];
 
    _accuracyLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 110, 150, 20)];
    _accuracyLabel.textColor = BUTTON_COLOR;
    _accuracyLabel.font = [UIFont boldSystemFontOfSize:20];
    [_completeAlertView addSubview:_accuracyLabel];
    
    UIButton *exitButton = [self buttonWithFrame:CGRectMake(80, 170, 100, 40) title:@"退出练习"];
    [exitButton addTarget:self action:@selector(practiceExit) forControlEvents:UIControlEventTouchUpInside];
    [_completeAlertView addSubview:exitButton];
    
    
    UIButton *playButton = [[UIButton alloc] initWithFrame:CGRectMake(220, 170, 100, 40)];
    playButton.backgroundColor = BUTTON_COLOR;
    playButton.layer.cornerRadius = 2;
    [playButton setTitle:@"再来一次" forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(practiceRestart) forControlEvents:UIControlEventTouchUpInside];
    [_completeAlertView addSubview:playButton];
}

- (void)showCompleteAlertViewWithResult:(NSInteger)result{
    
    if (!_completeAlertView) {
        [self initCompleteAlertView];
    }
    
    _rightLabel.text = [NSString stringWithFormat:@"正确：%lu",result];
    _wrongLabel.text = [NSString stringWithFormat:@"错误：%lu",10-result];
    _accuracyLabel.text = [NSString stringWithFormat:@"准确度：%lu%%",result*10];
    
    if(_presentAlertView){
        _presentAlertView.hidden = YES;
    }
    
    _completeAlertView.hidden = NO;
    _presentAlertView = _completeAlertView;
    
    
    [self display];
    
}

#pragma mark - PauseAlertView

- (void)initPauseAlertView{
    
    _pauseAlertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 200)];
    _pauseAlertView.backgroundColor = [UIColor whiteColor];
    _pauseAlertView.layer.cornerRadius = 8;
    _pauseAlertView.center = self.center;
    _pauseAlertView.hidden = YES;
    [self addSubview:_pauseAlertView];
    
    CGPoint center = CGPointMake(_pauseAlertView.bounds.size.width/2, _pauseAlertView.bounds.size.height/2);
    
    UIButton *exitButton = [self buttonWithFrame:CGRectMake(0, 0, 100, 40) title:@"退出练习"];
    exitButton.center = CGPointMake(center.x-70, 100);
    [exitButton addTarget:self action:@selector(practiceExit) forControlEvents:UIControlEventTouchUpInside];
    [_pauseAlertView addSubview:exitButton];
    
    
    UIButton *playButton = [self buttonWithFrame:CGRectMake(150, 120, 100, 40) title:@"继续练习"];
    playButton.center = CGPointMake(center.x+70, 100);
    [playButton addTarget:self action:@selector(practiceContinue) forControlEvents:UIControlEventTouchUpInside];
    [_pauseAlertView addSubview:playButton];
    
    
}

- (void)showPauseAlertView{
    
    if (!_pauseAlertView) {
        [self initPauseAlertView];
    }
    
    if (_presentAlertView) {
        _presentAlertView.hidden = YES;
    }
    
    _pauseAlertView.hidden = NO;
    _presentAlertView = _pauseAlertView;
    
    [self display];
    
}

#pragma mark - RestartAlertView

- (void)initRestartAlertView{
    
    _restartAlertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 200)];
    _restartAlertView.backgroundColor = [UIColor whiteColor];
    _restartAlertView.layer.cornerRadius = 8;
    _restartAlertView.center = self.center;
    _restartAlertView.hidden = YES;
    [self addSubview:_restartAlertView];
    
    UILabel *title = [self labelWithText:@"确定要重新开始？"];
    
    CGSize size = title.bounds.size;
    CGFloat x = _restartAlertView.bounds.size.width/2 - size.width/2;
    CGFloat y = 60;
    title.frame = CGRectMake(x, y, size.width, size.height);
    [_restartAlertView addSubview:title];
    
    
    
    CGPoint center = CGPointMake(_restartAlertView.bounds.size.width/2, _restartAlertView.bounds.size.height/2);
    
    UIButton *noBtn = [self buttonWithFrame:CGRectMake(0, 0, 100, 40) title:@"取消"];
    noBtn.center = CGPointMake(center.x-80, 150);
    [noBtn addTarget:self action:@selector(practiceContinue) forControlEvents:UIControlEventTouchUpInside];
    [_restartAlertView addSubview:noBtn];
    
    UIButton *yesBtn = [self buttonWithFrame:CGRectMake(0, 0, 100, 40) title:@"确定"];
    yesBtn.center = CGPointMake(center.x+80, 150);
    [yesBtn addTarget:self action:@selector(practiceRestart) forControlEvents:UIControlEventTouchUpInside];
    [_restartAlertView addSubview:yesBtn];
    
}

- (void)showRestartAlertView{
    
    if (!_restartAlertView) {
        [self initRestartAlertView];
    }
    
    if (_presentAlertView) {
        _presentAlertView.hidden = YES;
    }
    
    _restartAlertView.hidden = NO;
    _presentAlertView = _restartAlertView;
    
    
    [self display];
}

#pragma mark - ExitAlertView

- (void)initExitAlertView{
    
    _exitAlertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 200)];
    _exitAlertView.backgroundColor = [UIColor whiteColor];
    _exitAlertView.layer.cornerRadius = 8;
    _exitAlertView.center = self.center;
    _exitAlertView.hidden = YES;
    [self addSubview:_exitAlertView];
    
    UILabel *title = [self labelWithText:@"确定要退出吗？"];
    
    CGSize size = title.bounds.size;
    CGFloat x = _exitAlertView.bounds.size.width/2 - size.width/2;
    CGFloat y = 60;
    title.frame = CGRectMake(x, y, size.width, size.height);
    [_exitAlertView addSubview:title];
    
    
    
    CGPoint center = CGPointMake(_exitAlertView.bounds.size.width/2, _exitAlertView.bounds.size.height/2);
    
    UIButton *noBtn = [self buttonWithFrame:CGRectMake(0, 0, 100, 40) title:@"取消"];
    noBtn.center = CGPointMake(center.x-80, 150);
    [noBtn addTarget:self action:@selector(practiceContinue) forControlEvents:UIControlEventTouchUpInside];
    [_exitAlertView addSubview:noBtn];
    
    UIButton *yesBtn = [self buttonWithFrame:CGRectMake(0, 0, 100, 40) title:@"确定"];
    yesBtn.center = CGPointMake(center.x+80, 150);
    [yesBtn addTarget:self action:@selector(practiceExit) forControlEvents:UIControlEventTouchUpInside];
    [_exitAlertView addSubview:yesBtn];
}

- (void)showExitAlertView{
    
    if (!_exitAlertView) {
        [self initExitAlertView];
    }
    
    if (_presentAlertView) {
        _presentAlertView.hidden = YES;
    }
    
    _exitAlertView.hidden = NO;
    _presentAlertView = _exitAlertView;
    
    
    [self display];
    
}


#pragma mark - Action Event


- (void)display{
    
    self.hidden = NO;
    [_deleagte alertViewDidAppear];
    
}

- (void)dismiss{
    
    self.hidden = YES;
    [_deleagte alertViewDidDismiss];
    
}

- (void)practiceExit{
    [_deleagte exitPractice];
}

- (void)practiceRestart{
    [_deleagte restartPractice];
}

- (void)practiceContinue{
    [_deleagte continuePractice];
}
@end
