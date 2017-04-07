//
//  Header.h
//  dzq
//
//  Created by chentianyu on 16/1/25.
//  Copyright © 2016年 chentianyu. All rights reserved.
//


#import <CocoaLumberjack/DDLog.h>

#ifndef Header_h
#define Header_h


#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_OFF;
#endif

/*
    created by wangfei
 */
typedef enum{
    ChooseRangResultC2C3C4 = 0,
    ChooseRangResultC3C4C5 = 1,
    ChooseRangResultC4C5C6 = 2,
    ChooseRangResultC5C6C7 = 3
}ChooseRangResult;

typedef enum{
    ChooseComplexToneResultSingle = 0,
    ChooseComplexToneResultDouble = 1,
    ChooseComplexToneResultThree = 2,
    ChooseComplexToneResultFour = 3
}ChooseComplexToneResult;
typedef enum {
    CocllectionStatusWithout = 0,
    CocllectionStatusAlready = 1
}CocllectionStatus;
typedef enum {
    CommentTypeAddComment = 0,
    CommentTypeReply = 1
}CommentType;
typedef enum {
    RefreshOrientationTypeDown = 0,
    RefreshOrientationTypeUp = 1
}RefreshOrientationType;
static  int questionIndex = 0;
/*
 created by wangfei
 */

#endif /* Header_h */
