//
//  CollectionViewCell.h
//  UICollectionViewAnimationDemo
//
//  Created by qianfeng on 15/8/27.
//  Copyright (c) 2015年 LiuYaNan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell
/**
 *  分享图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *shareImageView;
/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
/**
 *  内容
 */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
/**
 *  位置
 */
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

/**
 *  时间
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

//赋值
- (void)setModel:(MessageModel *)model;

@end
