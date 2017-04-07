//
//  UIImage+ResizeImage.h
//  dzq
//
//  Created by chentianyu on 16/3/30.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ResizeImage)


+(UIImage *)resizeImage:(UIImage *)originImage toSize:(CGSize)size;
@end
