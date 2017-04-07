//
//  NSObject+Block.h
//  dzq
//
//  Created by 梁伟 on 16/4/18.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Block)

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;

@end
