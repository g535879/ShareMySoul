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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 创建一个UIImageView控件
        _imageView = [[UIImageView alloc] init];
//        _imageView.frame = CGRectMake(0, 0, 154, 200);
        _imageView.frame = self.bounds;
        // 将UIImageView控件添加到该单元格中
        [self.contentView addSubview:_imageView];
        // 创建一个UILabel控件
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        self.label.backgroundColor = [UIColor clearColor];
        // 设置该控件的自动缩放属性
        self.label.autoresizingMask = UIViewAutoresizingFlexibleHeight
        |UIViewAutoresizingFlexibleWidth;
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.font = [UIFont boldSystemFontOfSize:50.0];
        // 设置该控件的文本颜色
        self.label.textColor = [UIColor redColor];
        // 将UILabel控件添加到该单元格中
        [self.contentView addSubview:self.label];
        // 设置边框
        // 设置圆角
        self.layer.cornerRadius = 8.0;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setUrlStr:(NSString *)urlStr {
    
    _urlStr = urlStr;
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_urlStr]];
}

@end
