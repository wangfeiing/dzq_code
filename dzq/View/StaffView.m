//
//  StaffView.m
//  pianoDemo
//
//  Created by 梁伟 on 16/4/7.
//  Copyright © 2016年 梁伟. All rights reserved.
//

#import "StaffView.h"

@interface StaffView()

@end

@implementation StaffView


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, 620, 400);
        
        // 五线谱位置
        CGRect screemRect = [[UIScreen mainScreen] bounds];
        self.y = 60;
        self.x = screemRect.size.width / 2 - self.width / 2;

        
        self.backgroundColor = [UIColor clearColor];
        
        _noteViews = [[NSMutableArray alloc] init];
        
//        self.clipsToBounds = YES;
        
        _lineSpace  = 15;
        _lineWidth  = 1;
        _lineLength = 600;
        
    }
    return self;
}


// 调号类型生成对应的音列
- (void)setKeySignatureType:(KeySignatureType)keySignatureType{
    
    _keySignatureType = keySignatureType;
    
    _soundSeries = [[NSMutableArray alloc] init];
        
    int arr[] = {2, 2, 1, 2, 2, 2, 1};
    
    
//    for (int i = _keySignatureType; i < 128; ) {
//        
//        for (int j=0; j<7; j++) {
//            
//            i += arr[j];
//            
//            if (i > 20 && i < 128) {
//                [_soundSeries addObject:[NSNumber numberWithInt:i]];
//            }
//            
//        }
//        
//    }
    
    int i = _keySignatureType;
    
    while (i<128) {
        
        for (int j=0; j<7; j++) {
            i += arr[j];
            if (i > 20 && i < 128) {
                [_soundSeries addObject:[NSNumber numberWithInt:i]];
            }
        }
        
    }
    
    
    // 加入中央C
    
    switch (self.keySignatureType) {
            
        case KeySignatureType_C:
        case KeySignatureType_G:
        case KeySignatureType_F:
        case KeySignatureType_Bb:
        case KeySignatureType_Eb:
        case KeySignatureType_Ab:
        case KeySignatureType_Db:
            self.middleC = 60;
            break;
        
        case KeySignatureType_Gb:
        case KeySignatureType_Cb:
            self.middleC = 59;
            break;
            
            
        case KeySignatureType_D:
        case KeySignatureType_A:
        case KeySignatureType_E:
        case KeySignatureType_B:
        case KeySignatureType_Fx:
        case KeySignatureType_Cx:
            self.middleC = 61;
            break;
    }

    
}


- (void)errorNoteImage:(NSInteger)note showOrDismiss:(BOOL)show{
    
    if (show) {
//        [self showErrorNoteImage:note];
        [self showNoteViewWithNote:note state:NoteViewStateError];
    }else{
//        [self dismissErrorNoteImage:note];
        [self dismissNoteImageWithNote:note state:NoteViewStateError];
    }
    
    
}


// 指定 noteView 显示
- (void)showNoteViewWithNote:(NSInteger)note state:(NoteViewState)state{
    
    /*
     1、像判断 NoteView 是否存在
     2、存在：结束动画（LineView、NoteView）
     3、不存在：获取未使用的 NoteView（不存在动画）
     4、设置 NoteView 的类型
     5、设置 NoteView 的 Center
     6、判断是否需要加线
     
     */
    
    
    NoteView *noteView = [self noteViewWithNote:note state:state];
    if (noteView) {
        [self stopNoteViewDismissAnimation:noteView];
        return;
    }
    
    noteView = [self unusedNoteView];
    if ([self.soundSeries containsObject:[NSNumber numberWithInteger:note]]) {
        noteView.type = NoteViewTypeWhole;
    }else{
        noteView.type = NoteViewTypeHalf;
    }
    
    noteView.state = state;
    noteView.note = note;
    noteView.center = [self noteViewCenter:noteView];
    noteView.used = YES;
    
    [self addSubview:noteView];
    
    [self addLineViewwWithNoteView:noteView];
    

    
}


// 指定 noteView 消失
- (void)dismissNoteImageWithNote:(NSInteger)note state:(NoteViewState)state{
    
    
    NoteView *noteView = [self noteViewWithNote:note state:state];
    [self noteViewDismissAnimation:noteView];
    
}

// 消失动画
- (void)noteViewDismissAnimation:(NoteView *)noteView{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        noteView.alpha = 0.0f;
        
        if (noteView.lineView) {
            noteView.lineView.alpha = 0.0f;
        }
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            
            [noteView removeFromSuperview];
            noteView.used = NO;
            noteView.alpha = 1.f;
            
        }else{
            
            noteView.alpha = 1.0f;
            
        }
        
    }];
  
}

// 获取指定的 NoteView
- (NoteView *)noteViewWithNote:(NSInteger)note state:(NoteViewState)state{
    
    for (NoteView *noteView in self.noteViews) {
        if (noteView.isUsed == YES && noteView.note == note && noteView.state == state) {
            return noteView;
        }
    }
    
    return nil;
}

// 判断 noteView 是否存在
- (BOOL)noteViewExisted:(NSInteger)note state:(NoteViewState)state{
    
    NoteView *noteView = [self noteViewWithNote:note state:state];
    if (noteView) {
        return YES;
    }
    return NO;
    
}

// 获取缓存的 noteView
- (NoteView *)unusedNoteView{
    
    for (NoteView *noteView in _noteViews) {
        if (!noteView.isUsed) {
            return noteView;
        }
    }
    
    
    NoteView *noteView = [[NoteView alloc] init];
    noteView.used = NO;
    [_noteViews addObject:noteView];
    return noteView;
    
}




// 停止消失动画
- (void)stopNoteViewDismissAnimation:(NoteView *)noteView{
    
    [UIView animateWithDuration:0.0
                     animations:^{
                         noteView.alpha = 1.f;
                         if (noteView.lineView) {
                             noteView.lineView.alpha = 1.0f;
                         }
                    }
                     completion:nil];
    
}


// 需要子类重写
- (CGPoint)noteViewCenter:(NoteView *)view{
    return CGPointZero;
}

- (void)addLineViewwWithNoteView:(NoteView *)noteView{
    
}


@end
