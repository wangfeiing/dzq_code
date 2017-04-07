//
//  Audio.m
//  dzq
//
//  Created by 梁伟 on 16/4/20.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "Audio.h"

@interface Audio()
@property (nonatomic, strong)AVAudioPlayer *player;
@end

@implementation Audio

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _player = [[AVAudioPlayer alloc] init];
        
    }
    return self;
}

- (void)playSoundWithUrl:(NSString *)urlString{
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:urlString withExtension:nil];
    
}

@end
