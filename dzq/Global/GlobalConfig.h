//
//  GlobalConfig.h
//  dzq
//
//  Created by chentianyu on 16/5/7.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#ifndef GlobalConfig_h
#define GlobalConfig_h

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
//主题颜色
#define ThemeColor [UIColor colorWithRed:47.0/255 green:126.0/255 blue:84.0/255 alpha:1.0]


//dock的宽度和高度
#define DOCK_WIDTH   213/2
#define DOCK_HEIGHT  [[UIScreen mainScreen] bounds].size.height

#define DOCK_BACKGROUNDCOLOR        [UIColor colorWithRed:39.0/255 green:45.0/255 blue:61.0/255 alpha:1.0]
//#define DOCK_BACKGROUNDCOLOR [UIColor whiteColor];
#define TOTAL_COLOR     [UIColor colorWithRed:36.0/255 green:146.0/255 blue:85.0/255 alpha:1.0]
//dock中item的宽度和高度
#define DOCK_ITEM_WIDTH 100
#define DOCK_ITEM_HEIGHT 100
#define ONCE_LOAD          5
/*
 Created by wangfei-------->
 */


//ChooseRangResult shareRangeResult;
//ChooseComplexToneResult shareComplexToneResult;

#define BOARD_WIDTH 1432/2
#define BOARD_HEIGHT 319/2

#define KEY_Y 167/2
#define KEY_HEIGT 152/2

//#define KEY_W  (82/2)*(3/)
#define KEY_W      [UIScreen mainScreen].bounds.size.width/14
#define KEY_H  (360/2)

#define BLK_KEY_H 252/2
#define BLK_KEY_W [UIScreen mainScreen].bounds.size.width/21
#define CELL_WIDTH 650
#define TABLE_WIDTH 750
#define KEY_NAME_H 360/7
/*
 Created by wangfei-------->
 */
#define STATUS_HEIGTH [[UIApplication sharedApplication] statusBarFrame].size.height

//屏幕宽度和高度
#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT    [[UIScreen mainScreen] bounds].size.height


//====================================
//谱库中常量
#define SL_SeparatorLine_Color  [UIColor colorWithRed:170/255 green:170/255 blue:245/255 alpha:0.36f]
#define SL_Category_List_Text_Color [UIColor colorWithRed:0.39 green:0.39 blue:0.39 alpha:1]
#define SL_Category_List_Separator_Color [UIColor colorWithRed:243/255 green:243/255 blue:243/255 alpha:1]


//==========================
//教学/听音练习
#define Listen_Right_Origin 200
#define Listen_Button_Remind_Color [UIColor colorWithRed:38/255.0 green:129/255.0 blue:70/255.0 alpha:1.0f]

#define Listen_Remind_Color [UIColor colorWithRed:80/255.0 green:198/255.0 blue:134/255.0 alpha:1.0f]   //提示颜色

//==========================
//个人中心和设置
#define PC_SeparatorLine_Color [UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1.0f]
#define PC_Get_Code_Color [UIColor colorWithRed:105/255.0 green:179/255.0 blue:242/255.0f alpha:1.0];
#define PC_Modal_Background_Color [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0f];

#define PC_Item_Width (SCREEN_WIDTH-DOCK_WIDTH-20-3*10)/4
#define PC_Item_Height (SCREEN_WIDTH-DOCK_WIDTH-20-3*20)/4

//==========================

#define APIDOMAIN @"http://114.215.89.198/dzq_api/index.php/"

//登录
#define Public_User_Login   @"Public/user_login"
#define Public_user_regist    @"Public/user_regist"
#define Public_introduce    @"Public/introduce"

//用户模块
#define USER_user_info  @"user/user_info"
#define USER_get_passwd @"user/get_password"
#define USER_user_collect   @"user/get_collect"
#define USER_user_collectList   @"user/collect_list"
#define USER_user_practice  @"user/get_practice"
#define USER_avatar     @"user/avatar"
#define USER_feedback   @"user/feedback"
//#define USER_Change

//教学模块
#define TEACH_get_date  @"teach/get_data"

//曲谱
#define SCORE_music_type    @"score/music_type"
#define SCORE_recommend    @"score/recommend"
#define SCORE_type_music    @"score/type_music"
#define SCORE_music    @"score/music"
#define SCORE_collection    @"score/collection_status"

//图片地址
#define IMAGEDOMAIN @"http://114.215.89.198/dzq_api/Uploads/"

#endif /* GlobalConfig_h */
