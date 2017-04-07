//
//  CommentViewController.m
//  dzq
//
//  Created by 飞飞 on 16/4/7.
//  Copyright © 2016年 chentianyu. All rights reserved.
//
//#import "ShareSDK.h"
//#import "WXApi.h"
//#import "WeiboSDK.h"
//#import <TencentOpenAPI/QQApiInterface.h>
//#import <TencentOpenAPI/TencentOAuth.h>
#import "CommentViewController.h"
#import "DetailScroView.h"
#import "CommentCell.h"
#import "CommentModel.h"
#import <Masonry/Masonry.h>
#import "CommentTextLabel.h"
#import <AFNetworking.h>
#import "AppInfo.h"
#import "AlertView.h"
#import "ProgressHUD.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import "PlayViewController.h"
#import "MBProgressHUD.h"
#import "RegularJudge.h"
@interface CommentViewController ()

@end

@implementation CommentViewController
{
    CommentTextFieldController * ctfc;
    DeleteCommentController * delete;
    CocllectionStatus isCollection;
    DetailScroView * ds;
    AppInfo * app;
    UIButton * btn;

    __block NSMutableDictionary * modelForRowsArr;
    __block NSInteger numOfSection;

    UIBarButtonItem * rightBarButton;
    BOOL isUserInsert;
    MJRefreshHeader * header;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    numOfSection = 0;

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshWithDownOrUp:(RefreshOrientationTypeDown)];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self refreshWithDownOrUp:(RefreshOrientationTypeUp)];
    }];
    
    isUserInsert = NO;
    app = [AppInfo getInstance];
    
    ctfc  = [[CommentTextFieldController alloc] init];  //初始化评论界面
   
    btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    
    [btn addTarget:self action:@selector(clickShare:) forControlEvents:(UIControlEventTouchUpInside)];
    [btn setBackgroundImage:[UIImage imageNamed:@"toolbar_retweet_highlighted"] forState:(UIControlStateNormal)];
    modelForRowsArr = [[NSMutableDictionary alloc] init];
    rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:btn];

    ds = [[DetailScroView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - DOCK_WIDTH,  SCREEN_HEIGHT+500 )
          authorName:_music_model.m_author
          views:[NSString stringWithFormat:@"%ld",_music_model.m_viewer_count]
          collection:[NSString stringWithFormat:@"%ld",_music_model.m_good_count]
          introduce:_music_model.m_intro];
    NSString * m_img_photoPath = [NSString stringWithFormat:@"%@%@",IMAGEDOMAIN,_music_model.m_avatar];
    NSString * m_table_img_path = [NSString stringWithFormat:@"%@%@",IMAGEDOMAIN,_music_model.m_score];
    [ds setMusic_img_Image:m_img_photoPath];
    [ds set_tablature_img:m_table_img_path];
//    ds.scrollEnabled  = NO;
    
    self.title = _music_model.m_name;
    self.navigationItem.rightBarButtonItems = @[rightBarButton,rightBarButton];
    self.tableView.tableHeaderView = ds;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressForDelete:)];
    longPress.numberOfTouchesRequired = 1;
    [self.tableView addGestureRecognizer:longPress];
    
    [self getCommentWithMusicID:_music_model.m_id];

    numOfSection += ONCE_LOAD;
    if (numOfSection > modelForRowsArr.count) {
        numOfSection = modelForRowsArr.count;
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)dealloc
{

    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectionBtn:) name:@"collectionBtn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickShare:) name:@"clickShare" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startPlayMusic:) name:@"startPlayMusic" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addComment:) name:@"clickAddComment" object:nil];
}
#pragma mark - 刷新事件
-(void)refreshWithDownOrUp:(RefreshOrientationType)refreshOrientationType{
    if (refreshOrientationType == RefreshOrientationTypeDown) {
        [self getCommentWithMusicID:_music_model.m_id];
        [self.tableView.mj_header endRefreshing];
    }else if (refreshOrientationType == RefreshOrientationTypeUp){
        numOfSection =  [self getRefreshRowsNumberWithPreviousNumber:numOfSection];
        if (!modelForRowsArr.count) {
            return;
        }
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];

    }
}
-(NSInteger)getRefreshRowsNumberWithPreviousNumber:(NSInteger)preNumber{
    if (preNumber <= modelForRowsArr.count) {
        if (preNumber + ONCE_LOAD < modelForRowsArr.count) {
            preNumber +=ONCE_LOAD;
        }else{
            ProgressHUD * phud = [[ProgressHUD alloc] init];
            [phud HUDWithOnlyLabel:[UIApplication sharedApplication].keyWindow withText:@"没有更多数据了！"];
            preNumber = modelForRowsArr.count;
        }
    }
    return preNumber;
}

#pragma mark - 按钮事件处理

//长按删除
-(void)longPressForDelete:(UILongPressGestureRecognizer *)press{
    if (press.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [press locationInView:self.tableView];
        NSIndexPath * indexPath  = [self.tableView indexPathForRowAtPoint:point];
        
        if (indexPath != nil && !([app.token isEqualToString:@""] || app.token == nil)) {

            delete = [[DeleteCommentController alloc] init];
            delete.preferredContentSize = CGSizeMake(100, 30);
            delete.modalPresentationStyle = UIModalPresentationPopover;
            delete.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown;
            delete.popoverPresentationController.backgroundColor = [UIColor blackColor];
            delete.popoverPresentationController.sourceView = [self.tableView cellForRowAtIndexPath:indexPath].contentView;
            delete.popoverPresentationController.sourceRect = [self.tableView cellForRowAtIndexPath:indexPath].bounds;
            delete.popoverPresentationController.delegate = self;
            delete.deleteForCell = [self.tableView cellForRowAtIndexPath:indexPath];
            delete.D_delegate = self;
            NSMutableArray * arr =  [modelForRowsArr objectForKey:[NSNumber numberWithInteger:indexPath.section]];
            CommentModel  * cmtModel = [arr objectAtIndex:indexPath.row];
            BOOL isEqual =   [cmtModel.com_user_token isEqualToString:app.usermodel.token];
            if (isEqual) {
                [self presentViewController:delete animated:YES completion:^{
                }];
            }
        }else{
            ProgressHUD * phud = [[ProgressHUD alloc] init];
            UIWindow * window = [[UIApplication sharedApplication] keyWindow];
            window.backgroundColor = [UIColor blackColor];
            [phud HUDWithOnlyLabel:window withText:@"请先登录哦"];
        }
    }
}
-(void)longPressActionForCell:(UITableViewCell *)cell{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    NSMutableArray * arr =  [modelForRowsArr objectForKey:[NSNumber numberWithInteger:indexPath.section]];
    CommentModel  * cmtModel = [arr objectAtIndex:indexPath.row];
    BOOL isEqual =   [cmtModel.com_user_token isEqualToString:app.usermodel.token];
    if (isEqual) {
        NSDictionary * dic = @{@"id":cmtModel.com_id,@"token":cmtModel.com_user_token};
        [self delete_comment:dic];
    }else{
        [delete dismissViewControllerAnimated:YES completion:^{
            ProgressHUD * phud = [[ProgressHUD alloc] init];
            UIWindow * window = [[UIApplication sharedApplication] keyWindow];
            window.backgroundColor = [UIColor blackColor];
            [phud HUDWithOnlyLabel:window withText:@"无操作权限"];
        }];
    }
}
#pragma mark - 添加评论
-(void)addComment:(NSNotification *)sender{
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:[modelForRowsArr count]];
    isUserInsert = YES;
    [self showCommentViewControllerWithIndexPath:indexPath tableView:self.tableView commentType:CommentTypeAddComment];
    NSLog(@"add comment");
    
}

#pragma mark - 收藏按钮 事件
-(void)collectionBtn:(NSNotification *)sender{
    DetailScroView * dsv = (DetailScroView *)[sender object];
    isCollection = dsv.cocllectionStatus;
    if (!isCollection) {
        NSLog(@"collected success!");
        [ds ChangeBtnImgByBlock:^(UIButton *cbtn) {
            [cbtn setBackgroundImage:[UIImage imageNamed:@"toolbar_favorite_highlighted.png"] forState:(UIControlStateNormal)];
            [cbtn setTitle:@"取消收藏" forState:(UIControlStateNormal)];
            [cbtn setTitleColor:[UIColor colorWithRed:255/255.0 green:135/255.0 blue:0/255.0 alpha:1.0f]  forState:(UIControlStateNormal)];
        }];
    }else{
        NSLog(@"cancel collection success!");
        [ds ChangeBtnImgByBlock:^(UIButton *cbtn) {
            [cbtn setBackgroundImage:[UIImage imageNamed:@"toolbar_favorite.png"] forState:(UIControlStateNormal)];
            [cbtn setTitle:@"收藏" forState:(UIControlStateNormal)];
            [cbtn setTitleColor:[UIColor blackColor]  forState:(UIControlStateNormal)];
        }];
    }
}
/*
    App Key :1208d85d56ad0
    App Secret:7d1af4464138f8ce9f86585cb3f99f06
 */
#pragma mark - 分享按钮 事件
-(void)clickShare:(id)sender{

    NSLog(@"this is a other notifi - %@",sender);
    UIImage * image = [UIImage imageNamed:@"shareImg.jpg"];
    NSString * shareStr = @"just test!";
    if (shareStr && image) {
        NSMutableDictionary * shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:shareStr images:image url:[NSURL URLWithString:@"http://mob.com"] title:@"这是一个分享！" type:(SSDKContentTypeAuto)];
        [ShareSDK showShareActionSheet:btn items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
            NSLog(@"%lu",(unsigned long)state);
            if (state == SSDKResponseStateSuccess) {
                
                UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"分享成功！" preferredStyle:(UIAlertControllerStyleAlert)];
                [ac addAction:[UIAlertAction actionWithTitle:@"Cancel" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:ac animated:YES completion:nil];
            }
            else if (state == SSDKResponseStateFail){
                UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"分享失败！" preferredStyle:(UIAlertControllerStyleAlert)];
                [ac addAction:[UIAlertAction actionWithTitle:@"Cancel" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                }]];
                [self presentViewController:ac animated:YES completion:nil];
            }
        }];
    }
}
//-()
#pragma mark - 播放按钮
-(void)startPlayMusic:(NSNotification *)sender{
    NSLog(@"--%@--",sender);
//    if (!dsv.isPlay) {
//        NSLog(@"开始播放");
//        [dsv ChangeBtnImgByBlockStart:^(UIButton *startBtn) {
//            [startBtn setBackgroundImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
//            [startBtn setImage:[UIImage imageNamed:@"start_iorn_continue.png"] forState:(UIControlStateNormal)];
//        }];
//        dsv.isPlay = YES;
        ProgressHUD *theHUD = [ProgressHUD new];
        if ([self.music_model.m_file isKindOfClass:[NSNull class]]) {
            [theHUD HUDWithOnlyLabel:[[UIApplication sharedApplication] keyWindow] withText:@"该乐谱文件暂未上传" delay:0.5];
        }else{
            MBProgressHUD *HUD = [theHUD HUDWithIndeterminateMode:[[UIApplication sharedApplication] keyWindow] withText:@"下载中"];
            
            
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
            NSString *filePath = [NSString stringWithFormat:@"%@%@",IMAGEDOMAIN,self.music_model.m_file];
            NSURL *fileURL = [NSURL URLWithString:filePath];
            NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
            NSURLSessionDownloadTask *downloadTast = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                
                NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                return [documentsDirectoryURL URLByAppendingPathComponent:[response  suggestedFilename]];
            } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                if (error != nil) {
                    //                [self ]
                }else
                {
                    [theHUD hideHud:HUD];
                    NSLog(@"file download to:%@ ",filePath);
                    
                    NSString *str = [filePath absoluteString];
                    if ([str hasPrefix:@"file://"]) {
                        str = [str substringFromIndex:7];
                    }
                    PlayViewController *play = [[PlayViewController alloc] init];
                    play.xmlFilePath = str;
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:play];
                    play.view.backgroundColor = [UIColor whiteColor];
                    [self.view.window.rootViewController presentViewController:nav animated:YES completion:nil];
                }
                
            }];
            [downloadTast resume];
        }
        
        
        
//    }else{
//        NSLog(@"暂停播放");
//        [dsv ChangeBtnImgByBlockStart:^(UIButton *startBtn) {
//
//            [startBtn setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
//            [startBtn setBackgroundImage:[UIImage imageNamed:@"start_iorn.png"] forState:(UIControlStateNormal)];
//        }];
//        dsv.isPlay = NO;
//    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return numOfSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(NSMutableArray *)[modelForRowsArr objectForKey:[NSNumber numberWithInteger:section]] count];

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * string = [NSString stringWithFormat:@"%@",(NSString *)[(NSMutableArray *)[modelForRowsArr objectForKey:[NSNumber numberWithInteger:indexPath.section]] objectAtIndex:indexPath.row]] ;
    CGFloat height = [self getHeightOfText: [string stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
    if (indexPath.row==0 || isUserInsert == YES) {
        return height + 50.f;
    }
    return  height + 15.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell;

    CommentModel * cmtModel = (CommentModel *)[(NSMutableArray *)[modelForRowsArr objectForKey:[NSNumber numberWithInteger:indexPath.section]] objectAtIndex:indexPath.row];
    if (indexPath.row == 0 || isUserInsert == YES) {
        CommentCell * commentCell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
        if (!commentCell) {
            commentCell = [[CommentCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"comment"];
        }
        if (![cmtModel.com_user_name isEqual:[NSNull null]]) {
            commentCell.nameLabel.text = cmtModel.com_user_name;
        }
        
        [commentCell.photoBtn setBackgroundImage:[UIImage imageNamed:@"dog.jpg"] forState:(UIControlStateNormal)];
        commentCell.commentTextLabel.text =  [NSString stringWithFormat:@"%@",(NSString *)cmtModel.com_content];
        commentCell.commentTextLabel.numberOfLines = 0;
        commentCell.commentTimeLabel.text = cmtModel.com_time;
        isUserInsert = NO;
      
        return  commentCell;
    }else {
        AnswerCell * answerCell = [tableView dequeueReusableCellWithIdentifier:@"AnswerCell"];
        if (!answerCell) {
            answerCell = [[AnswerCell alloc] init];
        }
        NSMutableAttributedString  * commemnt_string =  [answerCell getTextWithFirstName:cmtModel.replyed_user_name secened:cmtModel.com_user_name text:[NSString stringWithFormat:@"%@",cmtModel.com_content]];
        [answerCell.answerText setAttributedText:commemnt_string];
        return answerCell;
    }
    return cell;
}
-(CGFloat)getHeightOfText:(NSString *)string{
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:11.f],NSFontAttributeName,NSParagraphStyleAttributeName,NSParagraphStyle.copy ,nil];
    CGRect frame  = [string boundingRectWithSize:CGSizeMake(TABLE_WIDTH, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil];
    return frame.size.height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    CommentModel * cmtModel = (CommentModel *)[(NSMutableArray *)[modelForRowsArr objectForKey:[NSNumber numberWithInteger:indexPath.section]] objectAtIndex:indexPath.row];

    [self showCommentViewControllerWithIndexPath:indexPath tableView:tableView commentType:CommentTypeReply];
}
#define PLACE_HOLDER @"添加一个评论...."
-(void)showCommentViewControllerWithIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView commentType:(CommentType)commentType{
    if (!([app.token isEqualToString:@""] || app.token == nil)) {
        NSMutableArray * arr =  [modelForRowsArr objectForKey:[NSNumber numberWithInteger:indexPath.section]];
        ctfc.commentModel = [arr objectAtIndex:indexPath.row];
        ctfc.CTDelegate = self;
        ctfc.currentTable = tableView;
        ctfc.indexPath = indexPath;
        ctfc.navigationItem.rightBarButtonItem.enabled = NO;
        ctfc.commentType = commentType;
        if (commentType == CommentTypeAddComment) {
            ctfc.placeholderLabel.text = PLACE_HOLDER;
        }else{
            
            ctfc.repleyedName = ctfc.commentModel.com_user_name;
        }

        UINavigationController * na = [[UINavigationController alloc] initWithRootViewController:ctfc ];
        na.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:na animated:YES completion:^{
            
        }];
    }else{
        ProgressHUD * phud = [[ProgressHUD alloc] init];
        UIWindow * window = [[UIApplication sharedApplication] keyWindow];
        window.backgroundColor = [UIColor blackColor];
        [phud HUDWithOnlyLabel:window withText:@"请先登录哦"];

    }
}

-(void)commentWithCommentModel:(CommentModel *)cmtModel commentText:(NSString *)commentText commentType:(CommentType)commentType {
    if (commentType == CommentTypeAddComment) {
        [self send_commentWithMusicID:[NSString stringWithFormat:@"%ld",self.music_model.m_id] content:commentText];
    }
    else if (commentType == CommentTypeReply){
        NSDictionary * dic = @{@"id": [NSString stringWithFormat:@"%ld", self.music_model.m_id],@"com_token":cmtModel.com_user_token,@"rep_token":app.usermodel.token,@"root":cmtModel.com_root_id,@"parent":cmtModel.com_id,@"content":commentText};
        
        [self reply_comment:dic];
    }
  /*
    if (isUserInsert != YES) {
        CommentModel * model = [[CommentModel alloc] init];
        
        NSIndexPath * index = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
        [(NSMutableArray *)[modelForRowsArr objectForKey:[NSNumber numberWithInteger:indexPath.section]] insertObject:commentText atIndex:index.row];
        [tableView insertRowsAtIndexPaths:@[index] withRowAnimation:(UITableViewRowAnimationBottom)];
    }else if (isUserInsert == YES){
//        CommentModel * model = [[CommentModel alloc] init];
//        model.com_music_id = [NSString stringWithFormat:@"%ld",self.music_model.m_id];
//        model.com_user_name = app.usermodel.name;
        NSMutableArray * arrOfSection = [[NSMutableArray alloc] init];
        [arrOfSection insertObject:commentText atIndex:indexPath.row];
        [modelForRowsArr setObject:arrOfSection forKey:[NSNumber numberWithInteger:[tableView numberOfSections]]];
        [tableView insertSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:(UITableViewRowAnimationBottom)];
    }
*/
}

#pragma mark - request

/*
 http://114.215.89.198/dzq_api/index.php/descuss/show?id=35
 */
-(void)getCommentWithMusicID:(NSInteger)M_id indexPath:(NSIndexPath *)indexPath {
    NSString * url = [NSString stringWithFormat:@"http://114.215.89.198/dzq_api/index.php/descuss/show?"];
    AFHTTPSessionManager* mge = [AFHTTPSessionManager manager];
    [mge GET:url parameters:@{@"id":[NSString stringWithFormat:@"%ld",M_id]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       modelForRowsArr =  [CommentModel getCommentModelsWithDic:(NSDictionary *)responseObject];
        NSIndexSet * set = [[NSIndexSet alloc] initWithIndex:indexPath.section];
        [self.tableView reloadSections:set withRowAnimation:(UITableViewRowAnimationAutomatic)];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure!");
    }];
}

-(void)getCommentWithMusicID:(NSInteger)M_id {
    NSString * url = [NSString stringWithFormat:@"http://114.215.89.198/dzq_api/index.php/descuss/show?"];
    AFHTTPSessionManager* mge = [AFHTTPSessionManager manager];
    [mge GET:url parameters:@{@"id":[NSString stringWithFormat:@"%ld",M_id]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@----",(NSDictionary *)responseObject);
        modelForRowsArr =  [CommentModel getCommentModelsWithDic:(NSDictionary *)responseObject];
        NSLog(@"------%@------",(NSDictionary *)responseObject);
        NSLog(@"%@",modelForRowsArr);
        numOfSection += ONCE_LOAD;
        if (numOfSection > modelForRowsArr.count) {
            numOfSection = modelForRowsArr.count;
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure!");
    }];
}
-(void)send_commentWithMusicID:(NSString *)music_id content:(NSString *)content{
    AFHTTPSessionManager * mge = [AFHTTPSessionManager manager];
    NSDictionary * pragram = @{@"id":music_id,@"com_token":app.usermodel.token,@"content":content};
    NSLog(@"%@",pragram);
    [mge POST:@"http://114.215.89.198/dzq_api/index.php/Home/descuss/send_comment?" parameters:pragram progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * rslt = (NSDictionary *)responseObject;
        if ([[rslt objectForKey:@"msg"] isEqualToString:@"success"]) {

            [self getCommentWithMusicID:self.music_model.m_id];
        }else{
            ProgressHUD * phud = [[ProgressHUD alloc] init];
            [phud HUDWithOnlyLabel:[UIApplication sharedApplication].keyWindow withText:@"发送失败，请重试！"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",task);
        
    }];
}
-(void)reply_comment:(NSDictionary *)info{
    AFHTTPSessionManager * mge = [AFHTTPSessionManager manager];
    [mge POST:@"http://114.215.89.198/dzq_api/index.php/Home/descuss/reply_comment?" parameters:info progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",(NSDictionary *)responseObject);
        NSDictionary * rslt = (NSDictionary *)responseObject;
        if ([[rslt objectForKey:@"msg"] isEqualToString:@"success"]) {
            [self getCommentWithMusicID:self.music_model.m_id indexPath:ctfc.indexPath];
        }else{
            ProgressHUD * phud = [[ProgressHUD alloc] init];
            [phud HUDWithOnlyLabel:[UIApplication sharedApplication].keyWindow withText:@"回复失败，请重试！"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
-(void)delete_comment:(NSDictionary *)info{
    AFHTTPSessionManager * mge = [AFHTTPSessionManager manager];
    [mge POST:@"http://114.215.89.198/dzq_api/index.php/Home/descuss/del_info?" parameters:info progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        NSLog(@"%@",(NSDictionary *)responseObject);
        NSDictionary * rslt = (NSDictionary *)responseObject;
        if ([[rslt objectForKey:@"msg"] isEqualToString:@"success"]) {
            [delete dismissViewControllerAnimated:YES completion:^{
                if (ctfc.indexPath.row == 0) {
                    [self getCommentWithMusicID:self.music_model.m_id];
                }else {
                    [self getCommentWithMusicID:self.music_model.m_id indexPath:ctfc.indexPath];
                }
            }];
        }else{
            ProgressHUD * phud = [[ProgressHUD alloc] init];
            [phud HUDWithOnlyLabel:[UIApplication sharedApplication].keyWindow withText:@"删除失败，请重试！"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
@end
