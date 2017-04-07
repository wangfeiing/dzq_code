//
//  PracticeViewController.h
//  dzq
//
//  Created by wangfei on 16/1/27.
//  Copyright © 2016年 chentianyu. All rights reserved.




#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ProgressHUD.h"

#import "NSObject+Block.h"

#import "YYSampler.h"
#import "MIDIManager.h"
#import "ListenPracticeModel.h"

#import "ListenGameEngine.h"

#import "GreatView.h"
#import "MessageView.h"
#import "AlertView.h"
#import "StaffView.h"
#import "GrandStaffView.h"
#import "LWKeyboardView.h"
#import "UIPregressStar.h"
#import "WFTimer.h"

@interface PracticeViewController : UIViewController <LWKeyboardViewDelegate, GameEngineDelegate, WFTimerDelegate, AlertViewDelegate>
@property (nonatomic, assign) PolyphoneType polyphone;
@property (nonatomic, assign) RangeType range;


@end
