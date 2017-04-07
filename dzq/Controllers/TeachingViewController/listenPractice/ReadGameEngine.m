
//
//  ReadGameEngine.m
//  dzq
//
//  Created by 梁伟 on 16/4/23.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "ReadGameEngine.h"

@implementation ReadGameEngine



- (void)actionEventWhenStart{
    [super actionEventWhenStart];
    
    BOOL result = [self resultOfUserAnswer];
    
    [self.delegate practiceResult:result number:self.index];
    
    if (result) {
        
        [self nextPractice];
        
    }
    

    
}


- (BOOL)resultOfUserAnswer{
    
    ReadPracticeModel *model = self.practiceModels[self.index];
    
    if (self.answer.count == model.items.count) {
        
        int count = 0;
        
        for (NSNumber *item in self.answer) {
            
            for (NSNumber *practice in model.items) {
                if ([item isEqualToNumber:practice]) {
                    count++;
                    break;
                }
            }
            
        }
        
        if (count == model.items.count) {
            return YES;
        }
        
    }
    
    return NO;
    
}


- (void)nextPractice{
    
    if (self.state == GameStateFinished) {
        return;
    }
    
    if (self.index == self.practiceModels.count-1) {
        
        self.state = GameStateFinished;
        [self.delegate practiceFinished];
        return;
    }
    
    self.index++;
    
    [self.delegate newPracticeWithIndex:self.index];
    
}

- (ReadPracticeModel *)presentModel{
    
    _presentModel = self.practiceModels[self.index];
    
    return _presentModel;
    
}

@end
