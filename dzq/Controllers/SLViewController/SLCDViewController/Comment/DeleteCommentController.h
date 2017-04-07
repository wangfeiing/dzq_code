//
//  DeleteCommentController.h
//  dzq
//
//  Created by 飞飞 on 16/4/19.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DeleteCommentControllerDelegate <NSObject>

@required
-(void)longPressActionForCell:(UITableViewCell *)cell;
@end

@interface DeleteCommentController : UIViewController

@property(nonatomic ,retain)     UIButton * label;
@property(nonatomic ,weak) id<DeleteCommentControllerDelegate> D_delegate;
@property(nonatomic ,retain)UITableViewCell * deleteForCell;

@end
