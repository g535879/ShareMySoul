//
//  CollectionViewCell.h
//  UICollectionViewAnimationDemo
//
//  Created by qianfeng on 15/8/27.
//  Copyright (c) 2015年 LiuYaNan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

// 定义一个UILabel，该控件的文本允许动态改变
@property (strong, nonatomic) UILabel * label;

/**
 *  图片url
 */
@property (nonatomic, copy) NSString * urlStr;
@end
