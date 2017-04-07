//
//  GrandStaffView.m
//  pianoDemo
//
//  Created by 梁伟 on 16/4/7.
//  Copyright © 2016年 梁伟. All rights reserved.
//

#import "GrandStaffView.h"

@interface GrandStaffView()
@property (nonatomic, strong)UIImageView *bassKeySignatureImageView;
@property (nonatomic, strong)UIImageView *trebleKeySignatureImageView;
@end

@implementation GrandStaffView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.staffType = StaffTypeGrand;
        
        
        self.middleC_treble = self.centerY - self.lineSpace * 2;
        self.middleC_bass   = self.centerY + self.lineSpace * 2;
        
        
        CGFloat y1 = self.centerY - self.lineSpace * 7;
        CGFloat y2 = self.centerY + self.lineSpace * 3;
        CGFloat x1 = self.centerX - self.lineLength / 2;
        
        
        self.trebleClef = [[UIImageView alloc] initWithFrame:CGRectMake(x1+10, y1-26, 40, 110)];
        self.trebleClef.image = [UIImage imageNamed:@"TrebleSymbols.png"];
        [self addSubview:self.trebleClef];
        
        
        self.bassClef = [[UIImageView alloc] initWithFrame:CGRectMake(x1+9, y2, 42, 46)];
        self.bassClef.image = [UIImage imageNamed:@"BassSymbols.png"];
        [self addSubview:self.bassClef];

        
        
        self.accolade = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 210)];
        self.accolade.center = CGPointMake(self.centerX - self.lineLength/2 - 15, self.centerY);
        self.accolade.image = [UIImage imageNamed:@"accolad"];
        [self addSubview:self.accolade];
        
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetLineCap(context, kCGLineCapButt);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    
    
    CGFloat y1 = self.centerY - self.lineSpace * 7;
    CGFloat y2 = self.centerY + self.lineSpace * 3;
    CGFloat x1 = self.centerX - self.lineLength / 2;
    CGFloat x2 = self.centerX + self.lineLength / 2;
    
    CGFloat s = self.lineSpace;
    
    
    for (int i=0; i<5; i++) {
        CGContextMoveToPoint(context, x1, y1 + s * i);
        CGContextAddLineToPoint(context, x2, y1 + s * i);
    }
    
    for (int i=0; i<5; i++) {
        CGContextMoveToPoint(context, x1, y2 + s * i);
        CGContextAddLineToPoint(context, x2, y2 + s * i);
    }
    
    CGContextMoveToPoint(context, x1, y1);
    CGContextAddLineToPoint(context, x1, y2 + s * 4);
    
    CGContextMoveToPoint(context, x2, y1);
    CGContextAddLineToPoint(context, x2, y2 + s* 4);
    
    
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
    
    CGFloat pointMiddleC;
    
    if (num >= 0) {
        pointMiddleC = self.middleC_treble;
    }else{
        pointMiddleC = self.middleC_bass;
    }
    
    CGFloat centerY = pointMiddleC - num * self.lineSpace/2;
    
    return CGPointMake(self.centerX - 5, centerY);
    
}

- (void)setKeySignatureType:(KeySignatureType)keySignatureType{
    
    [super setKeySignatureType:keySignatureType];
    
    if (!_bassKeySignatureImageView) {
        _bassKeySignatureImageView = [[UIImageView alloc] init];
        _trebleKeySignatureImageView = [[UIImageView alloc] init];
        
        [self addSubview:_bassKeySignatureImageView];
        [self addSubview:_trebleKeySignatureImageView];
    }
    
    
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"sk%lu",keySignatureType]];
    CGFloat width = image.size.width*3/4;
    CGFloat height = image.size.height*3/4;
    _bassKeySignatureImageView.image = image;
    _trebleKeySignatureImageView.image = image;
    
    CGFloat x1 = self.centerX - self.lineLength/2 + 60;
    CGFloat y1 = self.centerY - self.lineSpace*7 - 23;
    _trebleKeySignatureImageView.frame = CGRectMake(x1, y1, width, height);
    
    CGFloat x2 = self.centerX - self.lineLength/2 + 60;
    CGFloat y2 = self.centerY + self.lineSpace*3 - 23;
    _bassKeySignatureImageView.frame = CGRectMake(x2, y2, width, height);

    
}

- (void)addLineViewwWithNoteView:(NoteView *)noteView{
    
    NSInteger indexC = [self.soundSeries indexOfObject:[NSNumber numberWithInteger:self.middleC]];
    
    NSInteger soundSerieNote = noteView.note;
    if(![self.soundSeries containsObject:[NSNumber numberWithInteger:noteView.note]]){
        soundSerieNote--;
    }
    
    NSInteger indexN = [self.soundSeries indexOfObject:[NSNumber numberWithInteger:soundSerieNote]];
    
    NSInteger num = indexN - indexC;
    
    if ((num>=-17 & num<=-12) | (num>=12 & num<=17) | num==0) {
        
        LineView *lineView;
        NSInteger lineNumber;
        CGFloat x, y;
        
        if (num == 0) {
            
            lineNumber = 1;
            lineView = [[LineView alloc] initWithLineNumber:lineNumber];
            
            CGFloat line = self.middleC_treble - self.lineSpace;
            x = noteView.x + noteView.width/2 - lineView.width/2;
            y = line;
            
        }else if (num>0) {
            
            lineNumber = (num-12)/2 + 1;
            lineView = [[LineView alloc] initWithLineNumber:lineNumber];
            
            CGFloat line = self.middleC_treble - self.lineSpace*5;
            x = noteView.x + noteView.width/2 - lineView.width/2;
            y = line - lineView.height;
            
            
            
        }else{
            
            lineNumber = -(num+12)/2 + 1;
            lineView = [[LineView alloc] initWithLineNumber:lineNumber];
            CGFloat line = self.middleC_bass + self.lineSpace*5;
            x = noteView.x + noteView.width/2 - lineView.width/2;
            y = line;
            
        }
        
        lineView.frame = CGRectMake(x, y, lineView.width, lineView.height);
        [self addSubview:lineView];
        
        noteView.lineView = lineView;
        noteView.addLine = YES;
    }

    
    
    
}

@end
