//
//  CicleView.m
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/6.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "CicleView.h"

@interface CicleView () {
    
    CGRect _bounds;
    CGFloat _viewWidth;
    CGFloat _viewHeight;
    CALayer *_headLayer;//头像图层
}

@end
@implementation CicleView


- (instancetype)initWithFrame:(CGRect)frame withShadownColor:(UIColor *)shadowColor withBorderColor:(UIColor *)borderColor andImage:(UIImage *)bgImage {

    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        _viewWidth = self.bounds.size.width-2;
        _viewHeight = self.bounds.size.height-2;
        _bounds = CGRectMake(0, 0, _viewWidth, _viewHeight);
        CGPoint position = CGPointMake(_viewWidth/2,_viewHeight/2);
        CGFloat cornerRadius = _viewWidth / 2;
        CGFloat borderWidth = 2;
        
        //阴影图层
        CALayer *shadowLayer = [[CALayer alloc] init];
        shadowLayer.bounds = _bounds;
        shadowLayer.position = position;
        shadowLayer.cornerRadius = cornerRadius;
        shadowLayer.shadowColor = [UIColor blackColor].CGColor;
        shadowLayer.shadowOffset = CGSizeMake(2, 1);
        shadowLayer.shadowOpacity = 1;
        shadowLayer.borderColor  = [UIColor blueColor].CGColor;
        shadowLayer.borderWidth = borderWidth;
        [self.layer addSublayer:shadowLayer];
        
        //图片图层
        
        //图片图层
        _headLayer = [[CALayer alloc] init];
        _headLayer.bounds = _bounds;
        _headLayer.borderWidth = borderWidth;
        _headLayer.position = position;
        _headLayer.cornerRadius = cornerRadius;
        _headLayer.borderColor = borderColor.CGColor;
        _headLayer.masksToBounds = YES; //剪切图层。为了正确地显示图层中的图片
        //图层剪贴无法和阴影一起使用。因为masksToBounds 的目的就是剪切外边框，而阴影效果刚好在外边框
        //直接放图片到content
    
        [self.layer addSublayer:_headLayer];
        self.layer.cornerRadius = _viewWidth / 2.0f;
    }
    
    return self;
}

- (void)setHeadImage:(UIImage *)headImage {
    
    if (headImage) {
        [_headLayer setContents:(id)headImage.CGImage];
    }
    else{
        [_headLayer setContents:(id)[UIImage imageNamed:default_head_image].CGImage];
    }
    
}

@end
