//
//  MessageView.h
//  dzq
//
//  Created by 梁伟 on 16/4/16.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageView : UIView
@property (nonatomic, strong)NSString *message;
@property (nonatomic, strong)UILabel *messageLabel;

- (instancetype)initWithMessage:(NSString *)message;


@end
