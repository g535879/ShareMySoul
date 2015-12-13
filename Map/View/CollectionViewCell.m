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


- (void)setModel:(MessageModel *)model {
    
//    [self.headImageView setImage:nil];
//    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.author.head_image] placeholderImage:imageStar(default_head_image)];
//    self.nickName.text = model.author.nickname;
//    [self.shareImage sd_setImageWithURL:[NSURL URLWithString:model.pic]];
//    self.locationLabel.text = model.currentAddress;
//    self.content.text = model.content;
//    self.updateTimeLabel.text = (NSString *)model.updatedAt;
}

@end
