//
//  UIColor+Hex.h
//  dzq
//
//  Created by chentianyu on 16/3/25.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <UIKit/UIKit.h>
//用于将十六进制转换rgba的格式

@interface UIColor (Hex)

+(UIColor *)colorWithHexString:(NSString *)hexString;
@end
