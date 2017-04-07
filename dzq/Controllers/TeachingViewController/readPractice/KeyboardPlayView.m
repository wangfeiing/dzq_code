//
//  PianoKeyBoardView.m
//  dzq
//
//  Created by 梁伟 on 16/2/19.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "KeyboardPlayView.h"

//#define KEY_NUN 88
//#define WHITE_KEY_NUM 52
//#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
//#define WHITE_KEY_NUM_SCREEN 14
//#define WHITE_KEY_WIDTH SCREEN_WIDTH/WHITE_KEY_NUM_SCREEN
//#define BLACK_KEY_WIDTH WHITE_KEY_WIDTH*0.7
//#define WHITE_KEY_HEIGH 200
//#define BLACK_KEY_HEIGH 120

//static const CGFloat whiteKeyNumber = 52;
static const CGFloat whiteKeyScreenNumber   = 14;
static const CGFloat whiteKeyHeigh = 200;
static const CGFloat blackKeyHeigh = 120;
static const CGFloat blackKeyMultiple = 0.7;


typedef  NS_ENUM(NSUInteger, PianoKeytype){
    kPianoKeyTypeWhite = 0,
    kPianoKeyTypeBlack
};

@protocol PianoKeyDelegate <NSObject>

- (void)touchWithNote:(NSInteger)note isOn:(BOOL)on;

@end


@interface PianoKey : UIView
@property (nonatomic, weak)id <PianoKeyDelegate> delegate;
@property (nonatomic, assign)PianoKeytype pianoKeyType;
@property (nonatomic, assign)NSInteger note;
@property (nonatomic, weak)PianoKey *leftBlackKey;
@property (nonatomic, weak)PianoKey *rightBlackKey;
@property (nonatomic, strong)UILabel *label;
@property (nonatomic, assign)BOOL isHandling;
@end
@implementation PianoKey


- (void)setNote:(NSInteger)note{
    _note = note;
    
    if (self.label) {
        [self labelWithNote:note];
    }
}



- (void)labelWithNote:(NSInteger)note{
    
    // note 21 - 88
    
    NSString *char1, *char2;
    
            
            
    NSInteger rem = (note - 12)/12;
    
    if (rem == 0) {
        
        char2 = @"";
        
    }else{
        
        char2 = [NSString stringWithFormat:@"%ld",rem];
        
    }

    
    switch ((note-12)%12) {
            
        case 0:
            char1 = @"C";
            break;
            
        case 2:
            char1 = @"D";
            break;
            
        case 4:
            char1 = @"E";
            break;
        
        case 5:
            char1 = @"F";
            break;
        
        case 7:
            char1 = @"G";
            break;
            
        case 9:
            char1 = @"A";
            break;
            
        default:
            char1 = @"B";
            break;
    }
    
    self.label.text = [NSString stringWithFormat:@"%@%@",char1,char2];

}


- (void)setPianoKeyType:(PianoKeytype)pianoKeyType{
    
    _pianoKeyType = pianoKeyType;
    
    
    if (pianoKeyType) {
        
        self.backgroundColor = [UIColor blackColor];
        
        
    }else{
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        
        
            
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 25)];

        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor colorWithRed:0.69 green:0.69 blue:0.69 alpha:1];
        _label.font = [_label.font fontWithSize:24];
        CGSize size = self.bounds.size;
        _label.center = CGPointMake(size.width/2, size.height-30);
        [self addSubview:_label];
        
        
    }
    
    
}


- (void)touchDown{
    
    
    self.backgroundColor = [UIColor colorWithRed:0.87 green:0.39 blue:0.38 alpha:1];
    [_delegate touchWithNote:self.note isOn:YES];
    
    
}


- (void)touchUp{
    
    
    if (_pianoKeyType) {
        
        self.backgroundColor = [UIColor blackColor];
        
    }else{
        
        self.backgroundColor = [UIColor whiteColor];
        
    }
    
    
    [_delegate touchWithNote:self.note isOn:NO];
}


@end

@interface KeyboardPlayView() <PianoKeyDelegate>
@property(nonatomic, strong) UIView *contentView;

@end

@implementation KeyboardPlayView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initContentView];
        self.contentSize = self.contentView.frame.size;
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.scrollEnabled = NO;
        
    }
    return self;
}

- (void)initContentView{
    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat whiteKeyWidth = screenWidth / whiteKeyScreenNumber;
    CGFloat blackKeyWidth = whiteKeyWidth * blackKeyMultiple;
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, whiteKeyHeigh)];
    
    
    NSDictionary *noteDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PianoKeyNote.plist" ofType:nil]];
    
    NSArray *whitePianoKeyNotes = [noteDic objectForKey:@"WhiteKeyNotes"];
    for (int i=0; i<whitePianoKeyNotes.count; i++) {
        
        PianoKey *pianoKey = [[PianoKey alloc] initWithFrame:CGRectMake(whiteKeyWidth * i, 0, whiteKeyWidth, whiteKeyHeigh)];
        pianoKey.pianoKeyType = kPianoKeyTypeWhite;
        pianoKey.note = [whitePianoKeyNotes[i] integerValue];
        pianoKey.tag = pianoKey.note;
        pianoKey.delegate = self;
        [_contentView addSubview:pianoKey];
    }
    
    
    NSArray *baclkPianoKeyNotes = [noteDic objectForKey:@"BlackKeyNotes"];
    for (int i=0; i<baclkPianoKeyNotes.count; i++) {
        
        
        NSInteger tag = [baclkPianoKeyNotes[i] integerValue];
        
        PianoKey *leftPianoKey  = [_contentView viewWithTag:tag-1];
        PianoKey *rightPianoKey = [_contentView viewWithTag:tag+1];
        
        CGFloat startX = rightPianoKey.frame.origin.x;
        
        PianoKey *pianoKey = [[PianoKey alloc] initWithFrame:CGRectMake(startX - blackKeyWidth/2, 0, blackKeyWidth, blackKeyHeigh)];
        pianoKey.pianoKeyType = kPianoKeyTypeBlack;
        pianoKey.tag = pianoKey.note = tag;
        [_contentView addSubview:pianoKey];
        pianoKey.delegate = self;
        leftPianoKey.rightBlackKey = pianoKey;
        rightPianoKey.leftBlackKey = pianoKey;
        
        
    }
    
    [self addSubview:self.contentView];
}

#pragma mark - TouchEvent

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    for (UITouch *touch in touches) {
        
        CGPoint point = [touch locationInView:_contentView];
        PianoKey * pianoKey = [self viewWithPoint:point];
        [pianoKey touchDown];
        touch.lastPianoKeyTag = pianoKey.tag;
        
    }
    
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    
    for (UITouch * touch in touches) {
        
        
        PianoKey * lastPianoKey = [_contentView viewWithTag:touch.lastPianoKeyTag];
        PianoKey * cPianoKey = [self viewWithPoint:[touch locationInView:self.contentView]];
        
        if (cPianoKey != lastPianoKey) {
            
            [lastPianoKey touchUp];
            [cPianoKey touchDown];
            
            touch.lastPianoKeyTag = cPianoKey.tag;
        }
        
    }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        
        PianoKey *lastPianoKey = [_contentView viewWithTag:touch.lastPianoKeyTag];
        [lastPianoKey touchUp];
        
    }
}

- (PianoKey *)viewWithPoint:(CGPoint)point{
    
    
    CGFloat whiteKeyWidth = [[UIScreen mainScreen] bounds].size.width/whiteKeyScreenNumber;
    NSInteger index = point.x/whiteKeyWidth;
    NSDictionary * noteDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PianoKeyNote.plist" ofType:nil]];
    NSArray * whitePianoKeyNotes = [noteDic objectForKey:@"WhiteKeyNotes"];
    NSInteger tag = [whitePianoKeyNotes[index] integerValue];
    
    
    PianoKey *pianoKey = [_contentView viewWithTag:tag];
    if (CGRectContainsPoint(pianoKey.leftBlackKey.frame, point)) {
        
        return pianoKey.leftBlackKey;
        
    }else if(CGRectContainsPoint(pianoKey.rightBlackKey.frame, point)){
        
        return pianoKey.rightBlackKey;
        
    }else {
        
        return pianoKey;
        
    }
    
}

- (void)showTouchWithTag:(NSInteger)tag{
    PianoKey *pianoKey = [_contentView viewWithTag:tag];
    pianoKey.backgroundColor = [UIColor colorWithRed:0.87 green:0.39 blue:0.38 alpha:1];
}

- (void)dismissTouchWithTag:(NSInteger)tag{
    PianoKey *pianoKey = [_contentView viewWithTag:tag];
    pianoKey.backgroundColor = [UIColor colorWithRed:0.87 green:0.39 blue:0.38 alpha:1];

    if (pianoKey.pianoKeyType) {
        
        pianoKey.backgroundColor = [UIColor blackColor];
        
    }else{
        
        pianoKey.backgroundColor = [UIColor whiteColor];
        
    }
    
}


- (void)touchWithTag:(NSInteger)tag isOn:(BOOL)on{
    
    PianoKey *pianoKey = [_contentView viewWithTag:tag];
    if (on) {
        [pianoKey touchDown];
    }else{
        [pianoKey touchUp];
    }
    
}


#pragma mark - Scrolled

- (void)scrollToIndex:(NSInteger)index{
    
    CGFloat width = [[UIScreen mainScreen] bounds].size.width/whiteKeyScreenNumber;
    [self setContentOffset:CGPointMake(width*index, 0) animated:YES];
    
}

#pragma mark - PianoKeyDelegate;


- (void)touchWithNote:(NSInteger)note isOn:(BOOL)on{
    
    [_keyboardPlayViewDelegate touchWithKeyNote:note isOn:on];

}


@end
