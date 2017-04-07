//
//  ReadGameEngine.h
//  dzq
//
//  Created by 梁伟 on 16/4/23.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "GameEngine.h"
#import "ReadPracticeModel.h"

@interface ReadGameEngine : GameEngine
@property (nonatomic, strong)ReadPracticeModel *presentModel; // 当前试题

@end
