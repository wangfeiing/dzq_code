//
//  NSObject+Block.m
//  dzq
//
//  Created by 梁伟 on 16/4/18.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "NSObject+Block.h"

@implementation NSObject (Block)

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay{

    
    [self performSelector:@selector(performBlock:) withObject:[block copy] afterDelay:delay];

}

- (void)performBlock:(void (^)(void))block{
    
    block();
    
}

@end
