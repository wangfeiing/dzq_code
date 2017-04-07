//
//  StaffType.h
//  dzq
//
//  Created by 梁伟 on 16/3/23.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#ifndef StaffType_h
#define StaffType_h

/* 谱表类型 */
/*
typedef NS_ENUM(NSUInteger, StaffType){
    StaffTypeTreble = 0,  // 高音谱表
    StaffTypeBass,        // 低音谱表
    StaffTypeGrand,      // 大谱表
};
 */

/* 调号类型 */
/*
typedef NS_ENUM(NSUInteger, ToneMarkType){
    ToneMarkType_C = 0,   // C
    ToneMarkType_G,       // G
    ToneMarkType_D,       // D
    ToneMarkType_A,       // A
    ToneMarkType_E,       // E
    ToneMarkType_B,       // B
    ToneMarkType_Fx,      // F#
    ToneMarkType_Cx,      // C#
    ToneMarkType_Cb,      // Cb
    ToneMarkType_Gb,      // Gb
    ToneMarkType_Db,      // Db
    ToneMarkType_Ab,      // Ab
    ToneMarkType_Eb,      // Eb
    ToneMarkType_Bb,      // Bb
    ToneMarkType_F,       // F
};
 */

/* 复音类型 */
typedef NS_ENUM(NSUInteger, PolyphoneType){
    PolyphoneTypeMonophone = 0,     // 单音
    PolyphoneTypeDiphone,       // 双音
    PolyphoneTypeTriphone,      // 三音
    PolyphoneTypeGuadTone,      // 四音
};



// 音域类型 C1 - C6
typedef NS_ENUM(NSInteger, RangeType){
    RangeTypeC1 = 0,
    RangeTypeC2 = 1,
    RangeTypeC3 = 2,
    RangeTypeC4 = 3,
    RangeTypeC5 = 4,
    RangeTypeC6 = 5
};

#endif /* StaffType_h */
