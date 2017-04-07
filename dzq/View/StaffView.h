//
//  StaffView.h
//  pianoDemo
//
//  Created by 梁伟 on 16/4/7.
//  Copyright © 2016年 梁伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+LWFrame.h"
#import "NoteView.h"
#import "LineView.h"

typedef NS_ENUM(NSUInteger, StaffType){
    StaffTypeTreble = 0,  // 高音谱表
    StaffTypeBass,        // 低音谱表
    StaffTypeGrand,      // 大谱表
};

typedef NS_ENUM(NSInteger, KeySignatureType){
    KeySignatureType_C = 0,   // C
    KeySignatureType_G = 7,       // G
    KeySignatureType_D = 2,       // D
    KeySignatureType_A = 9,       // A
    KeySignatureType_E = 4,       // E
    KeySignatureType_B = 11,       // B
    KeySignatureType_Fx = 6,      // F#
    KeySignatureType_Cx = 1,      // C#
    KeySignatureType_Cb = 23,      // Cb
    KeySignatureType_Gb = 18,      // Gb
    KeySignatureType_Db = 13,      // Db
    KeySignatureType_Ab = 8,      // Ab
    KeySignatureType_Eb = 3,      // Eb
    KeySignatureType_Bb = 10,      // Bb
    KeySignatureType_F = 5       // F
};

@interface StaffView : UIView


@property (nonatomic, assign, readonly)CGFloat lineSpace; // 五线谱每格高度
@property (nonatomic, assign, readonly)CGFloat lineWidth; // 五线谱线的宽度
@property (nonatomic, assign, readonly)CGFloat lineLength; // 五线谱线长度

@property (nonatomic, assign)StaffType staffType; // 谱号类型
@property (nonatomic, assign)KeySignatureType keySignatureType; // 调号类型

@property (nonatomic, strong)UIImageView *bassClef; // 低音谱号
@property (nonatomic, strong)UIImageView *trebleClef; // 高音谱号
@property (nonatomic, strong)UIImageView *keySignature; // 调号
@property (nonatomic, strong)UIImageView *accolade; // 连谱号

@property (nonatomic, strong)NSMutableArray *soundSeries; // 音列
@property (nonatomic, strong)NSMutableArray *noteViews;

@property (nonatomic, assign)NSInteger middleC;
@property (nonatomic, assign)CGFloat middleC_bass;
@property (nonatomic, assign)CGFloat middleC_treble;


- (void)showNoteViewWithNote:(NSInteger)note state:(NoteViewState)state;

- (void)dismissNoteImageWithNote:(NSInteger)note state:(NoteViewState)state;

- (CGPoint)noteViewCenter:(NoteView *)view;

- (void)addLineViewwWithNoteView:(NoteView *)noteView;

- (void)errorNoteImage:(NSInteger)note showOrDismiss:(BOOL)show;


@end
