//
//  CommentTextFieldController.h
//  dzq
//
//  Created by 飞飞 on 16/4/2.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CommentModel.h"
#import <MJRefresh/MJRefresh.h>
@protocol CommentTextFieldControllerDelegate <NSObject ,UITextViewDelegate>

@required
-(void)commentWithCommentModel:(CommentModel *)cmtModel
                   commentText:(NSString *)commentText
                   commentType:(CommentType)commentType;

@optional
-(void)commentWithCommentModel:(CommentModel *)cmtModel
                   commentText:(NSString *)commentText
                   inTableView:(UITableView * )tableView
                   atIndexPath:(NSIndexPath *)indexPath
                   commentType:(CommentType)commentType;
@end


@interface CommentTextFieldController : BaseViewController

@property (nonatomic ,retain) UITextView * textView;
@property (nonatomic ,retain) NSString * firstName;
@property (nonatomic ,retain) NSString * selecterID;
@property (nonatomic ,retain) UITableView * currentTable;
@property (nonatomic ,retain) NSIndexPath * indexPath;
@property (nonatomic ,assign) CommentType commentType;
@property (nonatomic ,retain) CommentModel * commentModel;
@property (nonatomic ,retain ,readonly) UILabel * placeholderLabel;
@property (nonatomic ,retain) NSString * repleyedName;
@property (nonatomic ,weak)id <CommentTextFieldControllerDelegate> CTDelegate;

@end
