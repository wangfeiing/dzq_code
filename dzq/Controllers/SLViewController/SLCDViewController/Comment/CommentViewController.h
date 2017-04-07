//
//  CommentViewController.h
//  dzq
//
//  Created by 飞飞 on 16/4/7.
//  Copyright © 2016年 chentianyu. All rights reserved.

#import <UIKit/UIKit.h>
#import "CommentTextFieldController.h"
#import "MusicModel.h"
#import "DeleteCommentController.h"
#import <MJRefresh.h>

@interface CommentViewController : UITableViewController <CommentTextFieldControllerDelegate ,UIPopoverPresentationControllerDelegate ,DeleteCommentControllerDelegate>

@property (nonatomic ,retain) MusicModel * music_model;

@end
