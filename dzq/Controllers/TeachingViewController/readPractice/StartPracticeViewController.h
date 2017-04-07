//
//  StartPracticeViewController.h
//  dzq
//
//  Created by 梁伟 on 16/1/27.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "NSObject+Block.h"

#import "MIDIManager.h"
#import "YYSampler.h"
#import "StaffType.h"

#import "ProgressHUD.h"
#import "ReadGameEngine.h"

#import "GreatView.h"
#import "AlertView.h"
#import "WFTimer.h"
#import "UIPregressStar.h"
#import "StaffView.h"
#import "BassStaffView.h"
#import "TrebleStaffView.h"
#import "GrandStaffView.h"
#import "LWKeyboardView.h"

@interface StartPracticeViewController : UIViewController <MIDIManagerDelegate, LWKeyboardViewDelegate, WFTimerDelegate, GameEngineDelegate, AlertViewDelegate>
@property (nonatomic, assign)StaffType staffType;
@property (nonatomic, assign)PolyphoneType polyphoneType;
@property (nonatomic, strong)NSMutableArray *keySignatures;

@end
