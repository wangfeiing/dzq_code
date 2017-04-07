//
//  GameEngine.m
//  dzq
//
//  Created by 梁伟 on 16/4/18.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "GameEngine.h"

@implementation GameEngine


- (instancetype)initWithPracticeItems:(NSArray *)items
{
    self = [super init];
    if (self) {
        
        _practiceModels = items;
        _index = 0;
        
    }
    return self;
}



- (void)answerOfUserInput:(NSArray *)answer{
    
    if (_state == GameStateFinished) {
        return;
    }
    
    _answer = answer;
    
    if (_state == GameStateReady) {
        [self actionEventWhenReady];
    }
    
    if (_state == GameStateStart) {
        [self actionEventWhenStart];
    }
    
    
}

- (void)actionEventWhenReady{
    
}

- (void)actionEventWhenStart{
    
}

- (void)actionEventWhenFinished{
    
}


@end
