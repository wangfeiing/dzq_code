//
//  SLHeaderLayout.m
//  dzq
//
//  Created by chentianyu on 16/2/19.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "SLHeaderLayout.h"

@implementation SLHeaderLayout



- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}



- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *arrayAttrs = [super layoutAttributesForElementsInRect:rect];
    
    CGFloat centerX = self.collectionView.contentOffset.x  + self.collectionView.bounds.size.width*0.5;//中心点的值
    
    for (UICollectionViewLayoutAttributes *attr in arrayAttrs) {    //距离中心点，由近及远进行缩小
        //中心点和attr的距离
        CGFloat distance = ABS(attr.center.x-centerX);
        
        //距离约大，缩放约小
        CGFloat factor = 0.0009;
        CGFloat scale = 1/(1+distance*factor);
        
        //缩放
        attr.transform = CGAffineTransformMakeScale(1, scale);
    }
    
    return arrayAttrs;
}


//自动对齐到网格
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    //参数2：velocity:速度。点/每秒
    
    //计算中心点在整个集合视图中的值
    CGFloat centerX = proposedContentOffset.x + self.collectionView.bounds.size.width * 0.5;
    //self.collectionView.contentOffset是不带惯性的停留到的位置
    //计算可视区域
    CGFloat visiableX = proposedContentOffset.x;
    CGFloat visibleY  = proposedContentOffset.y;
    CGFloat visibleW = self.collectionView.bounds.size.width;
    CGFloat visibleH = self.collectionView.bounds.size.height;
    CGRect visibleRect = CGRectMake(visiableX, visibleY, visibleW, visibleH);
    
    NSArray *arrayAttrs = [self layoutAttributesForElementsInRect:visibleRect];
    
    //计算出最小的偏移
    int min_idx = 0;
    UICollectionViewLayoutAttributes *min_attr = arrayAttrs[min_idx];
    //循环比较出最小的
    for (int i = 1; i < arrayAttrs.count; i++) {
        //计算两个距离
        //1.min_attr和中心店的距离
        CGFloat distancel = ABS(min_attr.center.x -centerX);
        
        //当前循环的attr对象和centerX的距离
        UICollectionViewLayoutAttributes *obj = arrayAttrs[i];
        CGFloat distance2 =ABS(obj.center.x-centerX);
        
        if (distance2<distancel) {
            min_idx = i;
            min_attr = obj;
        }
        
    }
    
    //计算出最小的偏移值
    CGFloat offsetX = min_attr.center.x - centerX;
    return CGPointMake(proposedContentOffset.x+offsetX, proposedContentOffset.y);
    
    
}
@end
