//
//  GameEngine.h
//  dzq
//
//  Created by 梁伟 on 16/4/18.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, GameState) {
    GameStateReady = 0,
    GameStateStart,
    GameStateFinished
};


@protocol GameEngineDelegate <NSObject>

@optional
//- (void)readyPractice;
- (void)practiceStart;
- (void)practiceFinished;
- (void)newPracticeWithIndex:(NSInteger)index;
- (void)practiceResult:(BOOL)result number:(NSInteger)index;

@end


@interface GameEngine : NSObject
@property (nonatomic, assign)NSInteger index; // 题号
@property (nonatomic, assign)GameState state; // 状态
@property (nonatomic, strong)NSArray *answer;
@property (nonatomic, strong)NSArray *practiceModels; // 试题数组
@property (nonatomic, weak) id<GameEngineDelegate> delegate;


- (instancetype)initWithPracticeItems:(NSArray *)items;

- (void)answerOfUserInput:(NSArray *)answer;

- (void)actionEventWhenReady;
- (void)actionEventWhenStart;
- (void)actionEventWhenFinished;

@end
