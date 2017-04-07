//
//  UITouch+PianoKey.m
//  dzq
//
//  Created by 梁伟 on 16/2/26.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "UITouch+PianoKey.h"
#import <objc/runtime.h>
static void * LastPianoKeyTag = &LastPianoKeyTag;

@implementation UITouch (PianoKey)

- (void)setLastPianoKeyTag:(NSInteger)lastPianoKeyTag{
    objc_setAssociatedObject(self, LastPianoKeyTag, [NSNumber numberWithInteger:lastPianoKeyTag], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)lastPianoKeyTag{
    return [objc_getAssociatedObject(self, LastPianoKeyTag) integerValue];
}

@end
