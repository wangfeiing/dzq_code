//
//  FeedBackTextView.h
//  dzq
//
//  Created by chentianyu on 16/4/3.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedBackTextView : UITextView{
    UILabel *placeholderLabel;
}
@property(nonatomic,strong)NSString *placeholder;
@property(nonatomic,strong)UIColor *placeholderTextColor;
@end
