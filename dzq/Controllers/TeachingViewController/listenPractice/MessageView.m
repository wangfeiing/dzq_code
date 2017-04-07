//
//  MessageView.m
//  dzq
//
//  Created by 梁伟 on 16/4/16.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "MessageView.h"


#define MESSAGE_COLOR [UIColor colorWithRed:0.33 green:0.81 blue:0.6 alpha:1]
#define BG_COLOR [UIColor colorWithRed:0.22 green:0.22 blue:0.24 alpha:0.8]

@implementation MessageView

- (instancetype)initWithMessage:(NSString *)message{
    
    self = [super init];
    
    if (self) {

        self.backgroundColor = BG_COLOR;
        self.layer.cornerRadius = 8;
        
        _message = message;
        
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.text = _message;
        _messageLabel.font = [UIFont boldSystemFontOfSize:20];
        _messageLabel.textColor = MESSAGE_COLOR;
        [_messageLabel sizeToFit];
        
        CGSize size = _messageLabel.bounds.size;
        
        _messageLabel.frame = CGRectMake(20, 20, size.width, size.height);
        [self addSubview:_messageLabel];
        
        self.bounds = CGRectMake(0, 0, size.width+40, size.height+40);

        
    }
    
    return self;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = BG_COLOR;
        self.layer.cornerRadius = 8;
        
        _messageLabel = [[UILabel alloc] init];
        [self addSubview:_messageLabel];
        
    }
    return self;
}


- (void)setMessage:(NSString *)message{
    
    _message = message;
    
    _messageLabel.text = _message;
    _messageLabel.font = [UIFont boldSystemFontOfSize:20];
    _messageLabel.textColor = MESSAGE_COLOR;
    [_messageLabel sizeToFit];
    
    CGSize size = _messageLabel.bounds.size;
    
    _messageLabel.frame = CGRectMake(20, 20, size.width, size.height);
    self.bounds = CGRectMake(0, 0, size.width+40, size.height+40);
    
}

@end
