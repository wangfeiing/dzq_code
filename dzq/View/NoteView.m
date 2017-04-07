//
//  NoteView.m
//  pianoDemo
//
//  Created by 梁伟 on 16/4/7.
//  Copyright © 2016年 梁伟. All rights reserved.
//

#import "NoteView.h"

@interface NoteView()
@end
@implementation NoteView



- (instancetype)initWithNoteType:(NoteViewType)type state:(NoteViewState)state{
    
    self = [super initWithFrame:CGRectMake(0, 0, 38, 60)];
    
    if(self){
        _used = NO;
        _type = type;
        _state = state;

        self.noteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 22.5, 28, 15)];
        self.noteImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"whole%ld",_state]];
        [self addSubview:self.noteImageView];
        

        self.sharpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 60)];
        self.sharpImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"sharp%ld",_state]];
        [self addSubview:self.sharpImageView];
        

        if (_type == NoteViewTypeWhole) {
            self.sharpImageView.hidden = YES;
        }else{
            self.sharpImageView.hidden = NO;
        }
        
    }
    
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, 38, 60);
        _used = NO;
        _state = NoteViewStateNull;
        _type = NoteViewTypeNull;
        
        
        _noteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 22.5, 28, 15)];
        
        _sharpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 60)];

        [self addSubview:_noteImageView];
        [self addSubview:_sharpImageView];
    }
    return self;
}


- (void)setType:(NoteViewType)type{
    
    if (_type == type) {
        return;
    }
    
    
    _type = type;
    
    if (_type == NoteViewTypeWhole) {
        self.sharpImageView.hidden = YES;
    }else {
        self.sharpImageView.hidden = NO;
    }
    
    
}

- (void)setState:(NoteViewState)state{
    
    if (_state == state) {
        return;
    }
    
    
    _state = state;
    
    
    

    _noteImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"whole%ld",_state]];
    
    _sharpImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"sharp%ld",_state]];

}

- (void)setUsed:(BOOL)used{
    
    _used = used;
    
    if (_used) {
        
    }else{
        
        [_lineView dismiss];
        _lineView = nil;
        _addLine = NO;
        
    }
    
    
}


- (NSString *)description{
    
    NSString *frameDscp = [NSString stringWithFormat:@"frame:(%f,%f,%f,%f)",self.x,self.y,self.width,self.height];
    
    
    NSString *type = self.type == NoteViewTypeWhole ? @"whole" : @"Half";
    NSString *typeDscp = [NSString stringWithFormat:@"type:%@",type];
    
    NSString *state;
    switch (self.state) {
        case NoteViewStateCorrect:
            state = @"Correct";
            break;
        case NoteViewStateDemo:
            state = @"Demo";
            break;
            
        case NoteViewStateError:
            state = @"Error";
            break;
        default:
            state = @"Null";
            break;
    }
    
    NSString *stateDscp = [NSString stringWithFormat:@"state:%@",state];
    
    NSString *noteDscp = [NSString stringWithFormat:@"note:%lu",self.note];
    
    
    
    
    return [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n",frameDscp,typeDscp,stateDscp,noteDscp];
}

@end
