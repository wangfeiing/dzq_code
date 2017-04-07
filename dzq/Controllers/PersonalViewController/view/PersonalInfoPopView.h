//
//  PopView.h
//  PopView
//
//  Created by chentianyu on 15/12/11.
//  Copyright © 2015年 chentianyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTableViewCell.h"

typedef NS_ENUM(NSInteger,UIPopViewDirection){
    Top =  1,
    Bottom = 2,
    Left = 3,
    Right= 4
};

@protocol PopViewDelegate
- (void)itemSelected:(int)index;
@end


#define TABLEVIEWCOLOR  ([UIColor whiteColor])//表视图背景颜色
#define TRIANGLECOLOR   ([UIColor whiteColor])//三角形背景颜色

#define Clear_color [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0f]
@interface PersonalInfoPopView : UIView<PopViewDelegate,UITableViewDelegate,UITableViewDataSource>


@property(nonatomic)UIPopViewDirection direc;
@property(nonatomic,strong)UIView *startingView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *item;
@property (nonatomic, weak) id <PopViewDelegate> delegate;


- (instancetype)initWithFrame:(CGRect)frame direction:(UIPopViewDirection)direction stachView:(UIView *)stachView items:(NSArray *)items;
@end
