//
//  SLCTHeaderView.m
//  dzq
//
//  Created by chentianyu on 16/2/20.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "SLCTHeaderView.h"

@implementation SLCTHeaderView

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
        
        
        self.backgroundColor = [UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1.0f];
        [self addSomeButton];
        label.text = @"";
        label.backgroundColor = [UIColor colorWithRed:217/255.0 green:110/255.0 blue:93/255.0 alpha:1.0f];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lineMove:) name:@"SLCategoryOrderType" object:nil];
    }
    return self;
}

- (void)addSomeButton
{
    //"最热门"

    
    hotButton = [[SLCTButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/3-1, self.frame.size.height)];
    [hotButton setTitle:@"最热门" forState:UIControlStateNormal];

    [hotButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [hotButton setTitleColor:[UIColor colorWithRed:217/255.0 green:110/255.0 blue:93/255.0 alpha:1.0f] forState:UIControlStateSelected];
    [hotButton setBackgroundColor:[UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1.0f]];
    [hotButton setSelected:YES];
    hotButton.tag = 1;
    [hotButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:hotButton];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-4, self.frame.size.width/3-1, 3)];
    [self addSubview:label];
    
    
    UILabel *hotWithUploadLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/3-1, 6, 1, self.frame.size.height-12)];
    hotWithUploadLabel.backgroundColor = SL_SeparatorLine_Color;
    [self addSubview:hotWithUploadLabel];
    
    //最新上传
    uploadButton = [[SLCTButton alloc] initWithFrame:CGRectMake(self.frame.size.width/3, 0, self.frame.size.width/3, self.frame.size.height)];
    [uploadButton setTitle:@"最新上传" forState:UIControlStateNormal];
    [uploadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [uploadButton setTitleColor:[UIColor colorWithRed:217/255.0 green:110/255.0 blue:93/255.0 alpha:1.0f] forState:UIControlStateSelected];
    [uploadButton setBackgroundColor:[UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1.0f]];
    uploadButton.tag = 2;
        [uploadButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:uploadButton];
    
    UILabel *UploadWithUpdateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/3*2, 6, 1, self.frame.size.height-12)];
    UploadWithUpdateLabel.backgroundColor = SL_SeparatorLine_Color;
    [self addSubview:UploadWithUpdateLabel];
    
    //“最近更新”
    updateButton = [[SLCTButton alloc] initWithFrame:CGRectMake(self.frame.size.width/3*2+1, 0, self.frame.size.width/3, self.frame.size.height)];
    [updateButton setTitle:@"最近更新" forState:UIControlStateNormal];
    [updateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [updateButton setTitleColor:[UIColor colorWithRed:217/255.0 green:110/255.0 blue:93/255.0 alpha:1.0f] forState:UIControlStateSelected];
    [updateButton setBackgroundColor:[UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1.0f]];
    [updateButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    updateButton.tag = 3;
    [self addSubview:updateButton];
    
    
    
}

- (void)buttonClick:(UIButton *)button
{
    [self.delegate clickHeaderButton:button];
}

//标题下面的线移动
- (void)lineMove:(NSNotification *)notification
{
    NSDictionary *dic = notification.userInfo;
    [UIView beginAnimations:nil context:nil];
    
    if ([[dic objectForKey:@"orderTypes"] isEqualToString:@"1"]) {
        [UIView animateWithDuration:2 animations:^{
            label.frame = CGRectMake(0, self.frame.size.height-4, self.frame.size.width/3-1, 3);
        }];
        hotButton.selected = YES;
        uploadButton.selected = NO;
        updateButton.selected = NO;
    }else if([[dic objectForKey:@"orderTypes"] isEqualToString:@"2"]) {
        [UIView animateWithDuration:2 animations:^{
            label.frame = CGRectMake(self.frame.size.width/3, self.frame.size.height-4, self.frame.size.width/3, 3);
        }];
        hotButton.selected = NO;
        uploadButton.selected = YES;
        updateButton.selected = NO;
    }else if([[dic objectForKey:@"orderTypes"] isEqualToString:@"3"]) {
        [UIView animateWithDuration:2 animations:^{
            label.frame = CGRectMake(self.frame.size.width/3*2+1, self.frame.size.height-4, self.frame.size.width/3, 3);
        }];
        hotButton.selected = NO;
        uploadButton.selected = NO;
        updateButton.selected = YES;
        
    }
    [UIView commitAnimations];
    
    [self addSubview:label];
}
@end
