//
//  UIView+LWFrame.m
//  dzq
//
//  Created by 梁伟 on 16/2/29.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "UIView+LWFrame.h"

@implementation UIView (LWFrame)

- (CGFloat)x{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x{
    self.frame = CGRectMake(x, self.y, self.width, self.height);
}

- (CGFloat)y{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y{
    self.frame = CGRectMake(self.x, y, self.width, self.height);
}

- (CGFloat)width{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width{
    self.frame = CGRectMake(self.x, self.y, width, self.height);
}

- (CGFloat)height{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height{
    self.frame = CGRectMake(self.x, self.y, self.width, height);
}

- (CGFloat)centerX{
    return self.bounds.size.width/2;
}


- (CGFloat)centerY{
    return self.bounds.size.height/2;
}


@end
