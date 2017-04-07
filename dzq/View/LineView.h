//
//  LineView.h
//  dzq
//
//  Created by 梁伟 on 16/5/7.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineView : UIView
@property (nonatomic, assign)NSInteger lineNumber;

- (instancetype)initWithLineNumber:(NSInteger)num;

- (void)dismiss;

@end
