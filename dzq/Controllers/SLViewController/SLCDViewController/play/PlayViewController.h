//
//  PlayViewController.h
//  Play
//
//  Created by chentianyu on 16/5/8.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSScrollView.h"
#import <SeeScoreLib/SeeScoreLib.h>
#import "YYSampler.h"
@interface PlayViewController : UIViewController<UIScrollViewDelegate,SSSyControls,SSUTempo>

@property (readonly) SSScore *score;
@property int cursorBarIndex;


@property(nonatomic,strong)SSScrollView *theScrollView;


-(void)stopPlaying;

-(void)colourPDNotes:(NSArray*)notes;

@property(nonatomic,strong)UILabel *countInLabel;

@property(nonatomic,strong)NSString *xmlFilePath;
@property(nonatomic,strong)NSString *titleOfMusic;

//====
//key
@property(nonatomic,retain)YYSampler *sampler;

@end
