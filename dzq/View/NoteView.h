//
//  NoteView.h
//  pianoDemo
//
//  Created by 梁伟 on 16/4/7.
//  Copyright © 2016年 梁伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+LWFrame.h"
#import "LineView.h"

typedef NS_ENUM(NSInteger, NoteViewType){
    NoteViewTypeWhole = 0,
    NoteViewTypeHalf,
    NoteViewTypeNull
};
 

typedef NS_ENUM(NSInteger, NoteViewState){
    NoteViewStateCorrect = 0,
    NoteViewStateError,
    NoteViewStateDemo,
    NoteViewStateNull
};

@interface NoteView : UIView

@property (nonatomic, assign, getter = isUsed) BOOL used;
@property (nonatomic, assign) NoteViewType type;
@property (nonatomic, assign) NoteViewState state;
@property (nonatomic, strong) LineView *lineView;
@property (nonatomic, assign) BOOL addLine;
@property (nonatomic, assign) NSInteger note;
@property (nonatomic, strong) UIImageView *noteImageView;
@property (nonatomic, strong) UIImageView *sharpImageView;



- (instancetype)initWithNoteType:(NoteViewType)type state:(NoteViewState)state;

@end
