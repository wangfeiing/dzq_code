//
//  SLHeaderScrollView.h
//  ;
//
//  Created by chentianyu on 16/2/18.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ScrollViewBlock)(NSInteger index);

@interface SLHeaderScrollView : UIView<UIScrollViewDelegate>
{
    ScrollViewBlock scrollBlock;
}

@property(nonatomic,strong)NSArray *dataArray;

-(void)setCenterIndex:(ScrollViewBlock)block;
@end
