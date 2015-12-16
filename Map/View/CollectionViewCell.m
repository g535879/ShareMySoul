//
//  CollectionViewCell.m
//  UICollectionViewAnimationDemo
//
//  Created by qianfeng on 15/8/27.
//  Copyright (c) 2015年 LiuYaNan. All rights reserved.
//

#import "CollectionViewCell.h"

@interface CollectionViewCell () {
    
    UIImageView *_imageView;
}

@end
@implementation CollectionViewCell


- (void)awakeFromNib {
    
    self.headImageView.layer.cornerRadius = 19 * scale_screen;
    self.headImageView.layer.masksToBounds = YES;
    
    [self.locationLabel setAdjustsFontSizeToFitWidth:YES];
    [self.timeLabel setAdjustsFontSizeToFitWidth:YES];
}

- (void)setModel:(MessageModel *)model {
    
    model.pic = @"http://file.bmob.cn/M02/E7/96/oYYBAFZoJRGAWo73AABHuiUubKA234.jpg";
    
    [self.headImageView setImage:nil];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.author.head_image] placeholderImage:imageStar(default_head_image)];
    [self.shareImageView sd_setImageWithURL:[NSURL URLWithString:model.pic]];
    self.locationLabel.text = model.currentAddress;
//    self.contentLabel.text = model.content;
//    self.timeLabel.text = (NSString *)model.updatedAt;
}

@end
