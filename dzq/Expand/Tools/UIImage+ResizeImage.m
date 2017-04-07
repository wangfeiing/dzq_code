//
//  UIImage+ResizeImage.m
//  dzq
//
//  Created by chentianyu on 16/3/30.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "UIImage+ResizeImage.h"

@implementation UIImage (ResizeImage)

+(UIImage *)resizeImage:(UIImage *)originImage toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
    [originImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *resizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizeImage;
}
@end
