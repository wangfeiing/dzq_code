//
//  TrebleStaffView.m
//  pianoDemo
//
//  Created by 梁伟 on 16/4/7.
//  Copyright © 2016年 梁伟. All rights reserved.
//

#import "TrebleStaffView.h"


@interface  TrebleStaffView()
@property (nonatomic, strong)UIImageView *keySignatureImageVIew;
@end

@implementation TrebleStaffView


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.middleC_treble = self.centerY + self.lineSpace * 3;
        
        
        CGFloat y1 = self.centerY - self.lineSpace * 2;

        CGFloat x1 = self.centerX - self.lineLength / 2;
        
        
        self.trebleClef = [[UIImageView alloc] initWithFrame:CGRectMake(x1+10, y1-26, 40, 110)];
        self.trebleClef.image = [UIImage imageNamed:@"TrebleSymbols.png"];
        [self addSubview:self.trebleClef];

        
        self.staffType = StaffTypeTreble;
        self.middleC_treble = self.centerY + self.lineSpace * 3;
        self.trebleClef = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.trebleClef.image = [UIImage imageNamed:@""];
        [self addSubview:self.trebleClef];

    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetLineCap(context, kCGLineCapButt);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    
    
    CGFloat y  = self.centerY - self.lineSpace * 2;
    CGFloat x1 = self.centerX - self.lineLength / 2;
    CGFloat x2   = self.centerX + self.lineLength / 2;
    CGFloat s = self.lineSpace;
    
    
    for (int i=0; i<5; i++) {
        CGContextMoveToPoint(context, x1, y + s * i);
        CGContextAddLineToPoint(context, x2, y + s * i);
    }
    
    CGContextMoveToPoint(context, x1, y);
    CGContextAddLineToPoint(context, x1, y + s * 4);
    
    CGContextMoveToPoint(context, x2, y);
    CGContextAddLineToPoint(context, x2, y + s * 4);
    
    CGContextDrawPath(context, kCGPathStroke);
}

- (CGPoint)noteViewCenter:(NoteView *)view{
    
    NSInteger indexC = [self.soundSeries indexOfObject:[NSNumber numberWithInteger:self.middleC]];
    
    
    NSInteger soundSerieNote = view.note;
    if (![self.soundSeries containsObject:[NSNumber numberWithInteger:soundSerieNote]]) {
        soundSerieNote--;
    }
    
    NSInteger indexN = [self.soundSeries indexOfObject:[NSNumber numberWithInteger:soundSerieNote]];
    
    NSInteger num = indexN - indexC;
    CGFloat pointMiddleC = self.middleC_treble;
    
    CGFloat centerY = pointMiddleC - num * self.lineSpace/2;
    
    return CGPointMake(self.centerX - 5, centerY);
    

}

- (void)setKeySignatureType:(KeySignatureType)keySignatureType{
    
    [super setKeySignatureType:keySignatureType];
    
    if (!_keySignatureImageVIew) {
        _keySignatureImageVIew = [[UIImageView alloc] init];
        [self addSubview:_keySignatureImageVIew];
    }
    
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"sk%lu.png",self.keySignatureType]];
    
    CGFloat y = self.centerY - self.lineSpace * 2 - 23;
    CGFloat x = self.centerX - self.lineLength / 2 + 60;
    CGFloat width = image.size.width*3/4;
    CGFloat height = image.size.height*3/4;
    
    _keySignatureImageVIew.image = image;
    _keySignatureImageVIew.frame = CGRectMake(x, y, width, height);
    
}

- (void)addLineViewwWithNoteView:(NoteView *)noteView{
    
    NSInteger indexC = [self.soundSeries indexOfObject:[NSNumber numberWithInteger:self.middleC]];
    
    NSInteger soundSerieNote = noteView.note;
    if(![self.soundSeries containsObject:[NSNumber numberWithInteger:noteView.note]]){
        soundSerieNote--;
    }
    
    NSInteger indexN = [self.soundSeries indexOfObject:[NSNumber numberWithInteger:soundSerieNote]];
    
    NSInteger num = indexN - indexC;
    
    if ((num<=0 & num>=-5) | (num>=12 & num<=17)) {
        
        LineView *lineView;
        NSInteger lineNumber;
        CGFloat x, y;
        CGFloat pointMiddleC = self.middleC_treble;
        
        if (num>0) {
            
            lineNumber = (num-12)/2 + 1;
            lineView = [[LineView alloc] initWithLineNumber:lineNumber];
            
            CGFloat line = pointMiddleC - self.lineSpace * 5;
            x = noteView.x + noteView.width/2 - lineView.width/2;
            y = line - lineView.height;
            
            
            
        }else{
            
            lineNumber = -num/2 + 1;
            lineView = [[LineView alloc] initWithLineNumber:lineNumber];
            CGFloat line = pointMiddleC - self.lineSpace;
            x = noteView.x + noteView.width/2 -20;
            y = line;
            
        }
        
        lineView.frame = CGRectMake(x, y, lineView.width, lineView.height);
        [self addSubview:lineView];
        
        noteView.lineView = lineView;
        noteView.addLine = YES;
    }
    

    
}

@end
