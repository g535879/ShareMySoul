//
//  DrawerView.m
//  ShareMySoul
//
//  Created by 古玉彬 on 15/11/30.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "DrawerView.h"

@interface DrawerView () {
    
    UIView * _leftView; //左侧视图
}

@end
@implementation DrawerView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        //布局
        [self createLayout];
    }
    return self;
}

#pragma mark - 布局
- (void)createLayout {
    
    [self addSubview:self.mainView];
    [self addSubview:_leftView];
}
@end
