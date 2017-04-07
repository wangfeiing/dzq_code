//
//  BassStaffView.m
//  pianoDemo
//
//  Created by 梁伟 on 16/4/7.
//  Copyright © 2016年 梁伟. All rights reserved.
//

#import "BassStaffView.h"

@interface BassStaffView()
@property (nonatomic, strong)UIImageView *keySignatureImageVIew;

@end

@implementation BassStaffView


- (instancetype)init{
    self = [super init];
    if (self) {

        self.middleC_bass   = self.centerY - self.lineSpace * 3;
        
        
        CGFloat y1 = self.centerY - self.lineSpace * 2;

        CGFloat x1 = self.centerX - self.lineLength / 2;
        

        
        
        self.bassClef = [[UIImageView alloc] initWithFrame:CGRectMake(x1+9, y1, 42, 46)];
        self.bassClef.image = [UIImage imageNamed:@"BassSymbols.png"];
        [self addSubview:self.bassClef];

        

        self.staffType = StaffTypeBass;
        
        self.middleC_bass = self.centerY - self.lineSpace * 3;
        
        self.bassClef = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.trebleClef.image = [UIImage imageNamed:@""];
        [self addSubview:self.bassClef];

    }
    return self;
}


- (void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    

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
    if(![self.soundSeries containsObject:[NSNumber numberWithInteger:view.note]]){
        soundSerieNote--;
    }
    
    NSInteger indexN = [self.soundSeries indexOfObject:[NSNumber numberWithInteger:soundSerieNote]];
    
    NSInteger num = indexN - indexC;
    
    CGFloat pointMiddleC = self.middleC_bass;
    
    CGFloat centerY = pointMiddleC - num * self.lineSpace/2;
    
    return CGPointMake(self.centerX - 5, centerY);
    
    
    
}

- (void)addLineViewwWithNoteView:(NoteView *)noteView{
    
    NSInteger indexC = [self.soundSeries indexOfObject:[NSNumber numberWithInteger:self.middleC]];
    
    NSInteger soundSerieNote = noteView.note;
    if(![self.soundSeries containsObject:[NSNumber numberWithInteger:noteView.note]]){
        soundSerieNote--;
    }
    
    NSInteger indexN = [self.soundSeries indexOfObject:[NSNumber numberWithInteger:soundSerieNote]];
    
    NSInteger num = indexN - indexC;
    
    if ((num>=0 & num<=5) | (num>=-17 & num<=-12)) {
        
        LineView *lineView;
        NSInteger lineNumber;
        CGFloat x, y;
        CGFloat pointMiddleC = self.middleC_bass;
        
        if (num>=0) {
            
            lineNumber = num/2 + 1;
            lineView = [[LineView alloc] initWithLineNumber:lineNumber];
            
            CGFloat line = pointMiddleC + self.lineSpace;
            x = noteView.x + noteView.width/2 - lineView.width/2;
            y = line - lineView.height;
            

            
        }else{
            
            lineNumber = -(num+12)/2 + 1;
            lineView = [[LineView alloc] initWithLineNumber:lineNumber];
            CGFloat line = pointMiddleC + self.lineSpace*5;
            x = noteView.x + noteView.width/2 -20;
            y = line;
            
        }
        
        lineView.frame = CGRectMake(x, y, lineView.width, lineView.height);
        [self addSubview:lineView];
        
        noteView.lineView = lineView;
        noteView.addLine = YES;
    }

    
}

/*
 
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

 
    G: (15, 45)
    D: (30, 66)
    A: (45, 66)
    E: (62, 66)
    B: (75, 64)
    #F: (90, 64)
    #c: (105, 64)
 
    F: 22*50
    bB: 42*80
    bE: 61*90
    bA: 80*90
    bD: 99*101
    bG: 120*101
    bC: 140*101
 /Users/liangwei/Desktop/sk2@2x.png
/Users/liangwei/Desktop/sk2.png
 */

- (void)setKeySignatureType:(KeySignatureType)keySignatureType{
    
    [super setKeySignatureType:keySignatureType];
    
    if (!_keySignatureImageVIew) {
        _keySignatureImageVIew = [[UIImageView alloc] init];
        [self addSubview:_keySignatureImageVIew];
    }
    
    /*
    switch (keySignatureType) {
        case KeySignatureType_C:
            
            break;
            
        case KeySignatureType_A:
        case KeySignatureType_G:
        case KeySignatureType_D:
            
            break;
            
        
        case KeySignatureType_E:
        case KeySignatureType_B:
            
            break;
    }
     */
    
    
     UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"sk%lu.png",self.keySignatureType]];
    
    CGFloat y = self.centerY - self.lineSpace * 2 - 23;
    CGFloat x = self.centerX - self.lineLength / 2 + 60;
    CGFloat width = image.size.width*3/4;
    CGFloat height = image.size.height*3/4;
    
    _keySignatureImageVIew.image = image;
    _keySignatureImageVIew.frame = CGRectMake(x, y, width, height);
    
}

/*
 0-5, -12 - -17
 */


@end
