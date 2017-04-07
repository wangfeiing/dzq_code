//
//  UIColor+Hex.m
//  dzq
//
//  Created by chentianyu on 16/3/25.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)


+(UIColor *)colorWithHexString:(NSString *)hexString
{
    
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    NSString *aStr = [hexString substringWithRange:range];//透明度
    
    //红色
    range.location = 2;
    NSString *rStr = [hexString substringWithRange:range];
    
    //绿色
    range.location = 4;
    NSString *gStr = [hexString substringWithRange:range];
    
    //蓝色
    range.location = 6;
    NSString *bStr = [hexString substringWithRange:range];
    
    unsigned int r,g,b,a;
    [[NSScanner scannerWithString:rStr] scanHexInt:&r];
    [[NSScanner scannerWithString:gStr] scanHexInt:&g];
    [[NSScanner scannerWithString:bStr] scanHexInt:&b];
    [[NSScanner scannerWithString:aStr] scanHexInt:&a];
    
    
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:(float)a/255.0f];
}
@end
