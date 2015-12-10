//
//  CollecctionViewFlowLayout.m
//  UICollectionViewAnimationDemo
//
//  Created by qianfeng on 15/8/27.
//  Copyright (c) 2015年 LiuYaNan. All rights reserved.
//

#import "CollecctionViewFlowLayout.h"
// 缩放比例
#define ZOOM_SCALE 0.5
// 距离中心点可活动的范围
#define ACTIVE_DISTANCE 200

@implementation CollecctionViewFlowLayout

-(id)init
{
    self = [super init];
    if (self)
    {
        // 设置每个单元格的大小
        self.itemSize = CGSizeMake(screen_Width * 3 / 7.0f,3 * (screen_Width * 3 / 7.0f) / 2.0F);
        // 设置该控件的滚动方向
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        // 设置各分区上、下、左、右保留的空白区的大小
        self.sectionInset = UIEdgeInsetsMake((screen_Height - self.itemSize.height * (1 + ZOOM_SCALE)) / 4.0, 50.0, (screen_Height - self.itemSize.height * (1 + ZOOM_SCALE)) / 4.0, 50);
        // 设置两行最小的行间距
        self.minimumLineSpacing = 50;
        // 设置两个单元格之间的间距
        self.minimumInteritemSpacing = 500;
    }
    return self;
}
// 该方法的返回值决定当UICollectionView的bounds改变时，是否需要重新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    // 返回YES表示需要重新布局
    return YES;
}
// 该方法的返回值控制指定CGRect区域内各单元格的大小、位置等布局属性
-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* original = [super layoutAttributesForElementsInRect:rect];
    NSArray * array = [[NSArray alloc] initWithArray:original copyItems:YES];
    // 定义一个CGRect，用于记录该UICollectionView的可视区域
    CGRect visibleRect;
    // 设置visibleRect的原点等于contentView的偏移
    visibleRect.origin = self.collectionView.contentOffset;
    // 设置visibleRect的大小与contentView的大小相同
    visibleRect.size = self.collectionView.bounds.size;
    
    // array中存的都是一些布局的属性  在array中找到这些属性  这里主要是找位置
    for (UICollectionViewLayoutAttributes* attributes in array) {
        // 这个方法是这个单元格的位置是否在 指定位置内 即是否在可视范围内
        if (CGRectIntersectsRect(attributes.frame, rect))
        {
            // 用可视区域的中心减去当前单元控件的中心，得到该单元格与中心的距离
            CGFloat distance = CGRectGetMidX(visibleRect)
            - attributes.center.x;
            // 如果该单元格与中心的距离小于指定值，就对该控件进行放大
            if (ABS(distance) < ACTIVE_DISTANCE)
            {
                // 计算放大比例：该单元格与中心的距离越大，放大比例越小
                CGFloat zoom = 1 + ZOOM_SCALE *
                (1 - ABS(distance / ACTIVE_DISTANCE));
                // 设置对单元格在X方向、Y方向上放大zoom倍
                attributes.transform3D = CATransform3DMakeScale(
                                                                zoom, zoom, 1.0);
                attributes.zIndex = 1;
            }
        }
    }
    return array;
}
@end
