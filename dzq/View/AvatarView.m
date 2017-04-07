//
//  AvatarView.m
//  dzq
//
//  Created by chentianyu on 16/1/24.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "AvatarView.h"
#import "AppInfo.h"
@implementation AvatarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.frame = CGRectMake(0, 2*STATUS_HEIGTH, DOCK_ITEM_WIDTH, DOCK_ITEM_HEIGHT);
//        self.imageView.layer.cornerRadius = self.frame.size.width/2;
//        self.imageView.clipsToBounds = YES;
//        self.imageView.layer.borderColor = [[UIColor grayColor] CGColor];
//        self.imageView.layer.borderWidth = 1.0f;
        self.imageView.layer.cornerRadius = self.bounds.size.height/2;
        [self setImage:[UIImage imageNamed:@"avatar"] forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickAvatarViewNotification:) name:@"NSClickAvatarViewNotification" object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAvatarImageNotification:) name:@"SetAvatarImage" object:nil];
    }
    return self;
}
//
//- (void)clickAvatarViewNotification:(NSNotification *)notification
//{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSClickAvatarViewBackNotification" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self,@"clickView", nil]];
//}

//设置用户头像通知
- (void)setAvatarImageNotification:(NSNotification *)notification
{
    UIImage *image;
    AppInfo *appInfo = [AppInfo getInstance];
    NSString *avatarStr = appInfo.usermodel.avatar;
    if ((NSObject*)avatarStr == [NSNull null] || avatarStr == nil) {
        image = [UIImage imageNamed:@"defaultAvatar"];
    }else{
        NSString *URLString = [IMAGEDOMAIN stringByAppendingString:avatarStr];
        NSURL *URL = [NSURL URLWithString:URLString];
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:URL]];
    }


    [self setImage:image forState:UIControlStateNormal];

    
}
@end
