//
//  DetailScroView.h
//  dzq
//
//  Created by 飞飞 on 16/3/25.
//  Copyright © 2016年 chentianyu. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "AnswerCell.h"
#import "CommentCell.h"

/*
@protocol DetailScroViewDelegate <NSObject>

@required
-(void)clickBtnToCollectionOrCancelWithCurrent:(NSString*)state  musicID:(NSString *)ID;
-(void)share;               //分享
-(UIImage *)addMusicPhoto;  //音乐图片
-(UIImage *)addTablature;   //琴谱图片
@end

*/

typedef void (^getImagePhoto)(UIImageView * imgV);
typedef void (^ChangeCocllectionImg)(UIButton * btn);

@interface DetailScroView : UIView <UIScrollViewDelegate>


@property(nonatomic ,retain) UILabel * author_name; //作者名字
@property(nonatomic ,retain) UILabel * views;       //浏览量
@property(nonatomic ,retain) UILabel * collections; //收藏量
@property(nonatomic ,retain) UILabel * music_name;  //曲子名字
@property(nonatomic ,assign) CocllectionStatus cocllectionStatus; //当前的状态
@property(nonatomic ,retain) NSString * IDOfMusic;
@property(nonatomic ,assign) BOOL isPlay;

//@property(nonatomic ,weak) id<DetailScroViewDelegate> delegate_DS;


-(void)setMUsicPhotoByBlock:(getImagePhoto)setImg;
-(void)ChangeBtnImgByBlockStart:(ChangeCocllectionImg)setImg;
-(void)ChangeBtnImgByBlock:(ChangeCocllectionImg)setImg;
- (instancetype)initWithFrame:(CGRect)frame
                   authorName:(NSString *)author_name
                        views:(NSString *)viewsNum
                   collection:(NSString *)collectionNum
                    introduce:(NSString *)introduce;
-(void)setMusic_img_Image:(NSString *)imageURL;
- (void)set_tablature_img:(NSString *)imageURL;

@end
