//
//  DetailScroView.m
//  dzq
//
//  Created by 飞飞 on 16/3/25.
//  Copyright © 2016年 chentianyu. All rights reserved.
//


#define IMGURL_MATCH @"<*[img][^\\>]*[src] *= *[\\"\\']{0,1}([^\\"\\'\\ >]*)""
#import "DetailScroView.h"


@implementation DetailScroView
{
    UIImageView * views_img;
    UIImageView * collections_img;
    UIImageView * music_img;
    UIWebView * tablature_img;
    
    UILabel * intro_title;
    UILabel * intro_string;
    UILabel * title_for;
    
    UIButton * start_play;
    UIButton * collectionClick;
//    UIButton * shareClick;
    UIButton * add_comment;
    
    UIView * X_line;
    UIView * X1_line;
    
    
    
}

- (instancetype)initWithFrame:(CGRect)frame
                   authorName:(NSString *)author_name
                        views:(NSString *)viewsNum
                   collection:(NSString *)collectionNum
                    introduce:(NSString *)introduce
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setScrollViewWithAuthorName:author_name
                                   views:viewsNum
                              collection:collectionNum
                               introduce:introduce];
        
    }
    return self;
}
-(void)setScrollViewWithAuthorName:(NSString *)author_name
                            views:(NSString *)viewsNum
                       collection:(NSString *)collectionNum
                        introduce:(NSString *)introduce
{
    __weak typeof(self) weakSelf = self;
    
    //音乐的照片
    music_img = [[UIImageView alloc] init];
    [music_img setBackgroundColor:[UIColor greenColor]];
    [music_img setImage:[UIImage imageNamed:@"music_photo.png"]];
    [self addSubview:music_img];
    [music_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(179, 129));
        make.top.equalTo(weakSelf.mas_top).with.offset(50);
        make.left.equalTo(weakSelf.mas_left).with.offset(75);
    }];
    
    //开始按钮
    start_play = [[UIButton alloc] init];
    [start_play.layer setCornerRadius:25];
    [start_play.layer setBorderWidth:1.5f];
    [start_play.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [start_play setBackgroundImage:[UIImage imageNamed:@"start_iorn.png"] forState:(UIControlStateNormal)];
    [start_play addTarget:self action:@selector(startPlayMusicBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self addSubview:start_play];
    [start_play mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.center.equalTo(music_img);
    }];
    
    self.isPlay = NO;
    
    //简介标题
    intro_title = [[UILabel alloc] init];
    intro_title.text = @"简介：";
    intro_title.font = [UIFont systemFontOfSize:13.0f];
    
    [self addSubview:intro_title];
    [intro_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 17));
        make.left.equalTo(music_img.mas_right).with.offset(45);
        make.top.equalTo(music_img.mas_top).with.offset(17);
        
    }];
    
    //简介具体内容
    intro_string = [[UILabel alloc] init];
    intro_string.font = [UIFont systemFontOfSize:13.0f];
    intro_string.text = introduce;
    //    CGSize size = [introduce sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(556, 150) lineBreakMode:(NSLineBreakByWordWrapping)];
    CGSize size = [introduce boundingRectWithSize:CGSizeMake(556, 150) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    intro_string.numberOfLines = 0;
    intro_string.lineBreakMode = NSLineBreakByWordWrapping;
    intro_string.textColor = [UIColor grayColor];
    [self addSubview: intro_string];
    [intro_string mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(558, size.height));
        make.left.equalTo(intro_title.mas_left).with.offset(0);
        make.top.equalTo(intro_title.mas_bottom).with.offset(2);
    }];

    
    //作者名字
    _author_name = [[UILabel alloc] init];
    NSMutableAttributedString * str =  [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"音乐人/%@",author_name]];
    NSRange range = NSMakeRange([[str string] rangeOfString:@"/"].location+1, str.string.length-[[str string] rangeOfString:@"/"].location-1);
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    [_author_name setAttributedText:str];
    _author_name.font = [UIFont systemFontOfSize:12.0f];
    [self addSubview:_author_name];
    [_author_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(94, 12));
        make.centerY.equalTo(intro_title);
        make.left.equalTo(music_img.mas_right).with.offset(270);
    }];
    //浏览量图标
    views_img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"view_icon_"]];
    [self addSubview:views_img];
    [views_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 12));
        make.left.equalTo(_author_name.mas_right).with.offset(20);
        make.centerY.equalTo(_author_name);
    }];
    //浏览量
    _views = [[UILabel alloc] init];
    _views.text = viewsNum;
    _views.textColor = [UIColor grayColor];
    _views.font = [UIFont systemFontOfSize:12];
    [self addSubview:_views];
    [_views mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(86, 12));
        make.left.equalTo(views_img.mas_right).with.offset(0);
        make.centerY.equalTo(views_img);
        
    }];
    
    //收藏图标
    collections_img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cllection_icon_"]];
    
    [self addSubview:collections_img];
    [collections_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.left.equalTo(_views.mas_right).with.offset(0);
        make.centerY.equalTo(views_img);
        
    }];
    //收藏
    _collections = [[UILabel alloc] init];
    _collections.text = collectionNum;
    _collections.textColor = [UIColor grayColor];
    _collections.font = [UIFont systemFontOfSize:12];
    [self addSubview:_collections];
    [_collections mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 12));
        make.left.equalTo(collections_img.mas_right).with.offset(0);
        make.centerY.equalTo(collections_img);
        
    }];
    
    //红色竖线
    X_line = [[UIView alloc] init];
    X_line.backgroundColor = [UIColor redColor];
    [self addSubview:X_line];
    [X_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(5, 26));
        make.left.equalTo(weakSelf.mas_left).with.offset(63);
        make.top.equalTo(weakSelf.mas_top).with.offset(190);
    }];
    //标语
    title_for = [[UILabel alloc] init];
    title_for.text = @"钢琴谱在线预览";
    title_for.textColor = [UIColor redColor];
    title_for.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:title_for];
    [title_for mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(103, 21));
        make.left.equalTo(X_line.mas_right).with.offset(1);
        make.centerY.equalTo(X_line);
    }];
    //琴谱
    tablature_img = [[UIWebView alloc] init];
//    tablature_img.image = [UIImage imageNamed:@"yedegangqin.png"];
    tablature_img.scrollView.scrollEnabled = NO;
    tablature_img.userInteractionEnabled = NO;
    [self addSubview:tablature_img];
    [tablature_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TABLE_WIDTH, 800));
        make.left.equalTo(weakSelf.mas_left).with.offset(77);
        make.top.equalTo(title_for.mas_bottom).with.offset(12);
    }];

    X1_line = [[UIView alloc] init];
    [X1_line setBackgroundColor:[UIColor redColor]];
    [self addSubview:X1_line];
    [X1_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(5, 26));
        make.top.equalTo(tablature_img.mas_bottom).with.offset(20);
        make.centerX.equalTo(X_line);
    }];
    
    title_for = [[UILabel alloc] init];
    title_for.text = @"评论";
    title_for.textColor = [UIColor redColor];
    title_for.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:title_for];
    [title_for mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(103, 21));
        make.left.equalTo(X1_line.mas_right).with.offset(1);
        make.centerY.equalTo(X1_line);
    }];
    
     add_comment = [[UIButton alloc] init];
    [add_comment setBackgroundColor:[UIColor greenColor]];
    [add_comment setTitle:@"ADD COMMENT" forState:(UIControlStateNormal)];
    [self addSubview:add_comment];
    [add_comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(160, 30));
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(tablature_img.mas_bottom).with.offset(120);
    }];
    [add_comment addTarget:self action:@selector(addCommentClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [collectionClick addTarget:self action:@selector(clickCollectionWithCurrentCocllectionStatus:) forControlEvents:(UIControlEventTouchUpInside)];
}
-(void)setMUsicPhotoByBlock:(getImagePhoto)setImg{
    setImg(music_img);
}
-(void)clickCollectionWithCurrentCocllectionStatus:(id)sender{
    
    NSLog(@"%@",sender);
    NSNotification * n = [[NSNotification alloc] initWithName:@"collectionBtn" object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:n];
    
    UIButton * btn = (UIButton *)sender;
    NSLog(@"%@--------",btn.titleLabel.text);
    
    if ([btn.titleLabel.text  isEqual: @"取消收藏"] ) {
        _cocllectionStatus = CocllectionStatusAlready;
    }
    else if ([btn.titleLabel.text isEqual:@"收藏"]){
        _cocllectionStatus = CocllectionStatusWithout;
    }

}
-(void)addCommentClick:(id)sender{
    NSNotification * notifi = [[NSNotification alloc] initWithName:@"clickAddComment" object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notifi];
}

-(void)ChangeBtnImgByBlock:(ChangeCocllectionImg)setImg{
        setImg(collectionClick);
}

-(void)ChangeBtnImgByBlockStart:(ChangeCocllectionImg)setImg{
    setImg(start_play);
}

-(void)startPlayMusicBtn:(UIButton *)sender{
    NSNotification * n = [[NSNotification alloc] initWithName:@"startPlayMusic" object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:n];
}
-(void)setMusic_img_Image:(NSString *)imageURL{
    NSURL * url = [NSURL URLWithString:imageURL];
    NSData * imgData = [NSData dataWithContentsOfURL:url];
    if (imgData) {
         music_img.image = [UIImage imageWithData:imgData];
    }
}
- (void)set_tablature_img:(NSString *)imageHTML{
    
    NSString * rslt;
    NSRange range = [imageHTML rangeOfString:IMAGEDOMAIN options:(NSRegularExpressionSearch)];
    if (range.location != NSNotFound) {
        rslt = [imageHTML substringWithRange:range];
        NSLog(@"%@",rslt);
    }
    imageHTML = [imageHTML stringByReplacingOccurrencesOfString:rslt withString:@""];
     [tablature_img loadHTMLString:imageHTML baseURL:nil];
}

@end
