//
//  HomePageTitleView.m
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/1.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "HomePageTitleView.h"

/**
 分栏控制器背景button宏定义
 */
#define BACKBTN_WIDTH  100.0f
#define BACKBTN_HETGHT 30.0f

@interface HomePageTitleView (){
    
    //控件宽度
    CGFloat _viewWidth;
}

@property (nonatomic,strong) UIView *moveView;
@property (nonatomic,strong) UIButton *leftButton;
@property (nonatomic,strong) UIButton *rightButton;
@property (nonatomic,strong) UIView *frameView;

@end
@implementation HomePageTitleView

- (instancetype)initWithFrame:(CGRect)frame andBlock:(void (^)(UIButton *))callBack {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _viewWidth = frame.size.width;
        
        [self viewConfig];
        
        self.titleBtnClick = callBack;
    }
    return self;
}

#pragma mark - 初始化布局

- (void)viewConfig {
    
    //创建背景视图
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, 64.0f)];
    backView.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    
    self.frameView = [[UIView alloc] initWithFrame:CGRectMake((_viewWidth - 2*BACKBTN_WIDTH) / 2, 27.0f, BACKBTN_WIDTH*2, BACKBTN_HETGHT)];
    self.frameView .backgroundColor = [UIColor colorWithRed:0.20f green:0.25f blue:0.30f alpha:1.00f];
    self.frameView.layer.cornerRadius = 15;
    [backView addSubview:self.frameView];
    
    //创建移动view
    self.moveView = [[UIView alloc] initWithFrame:CGRectMake(1, 1,BACKBTN_WIDTH, BACKBTN_HETGHT - 2)];
    
    self.moveView.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    self.moveView.layer.cornerRadius = 15;
    [self.frameView  addSubview:self.moveView];
    
    //创建button
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton.frame = CGRectMake(1, 1,BACKBTN_WIDTH, BACKBTN_HETGHT - 2);
    [self.leftButton setTitleColor:[UIColor colorWithRed:0.95f green:0.78f blue:0.56f alpha:1.00f] forState:UIControlStateNormal];
    [self.leftButton setTitle:@"主页" forState:UIControlStateNormal];
    self.leftButton.backgroundColor = [UIColor clearColor];
    [self.leftButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.leftButton.tag = 10;
    [self.frameView addSubview:self.leftButton];
    
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.frame = CGRectMake(BACKBTN_WIDTH - 1, 1,BACKBTN_WIDTH, BACKBTN_HETGHT - 2);
    [self.rightButton setTitleColor:[UIColor colorWithRed:0.95f green:0.78f blue:0.56f alpha:1.00f] forState:UIControlStateNormal];
    [self.rightButton setTitle:@"我的" forState:UIControlStateNormal];
    self.rightButton.backgroundColor = [UIColor clearColor];
    [self.rightButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.tag = 20;
    [self.frameView addSubview:self.rightButton];
    
    [self addSubview:backView];
}


#pragma mark -点击事件

- (void)buttonClicked:(UIButton *)button{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.moveView.frame = CGRectMake(button.frame.origin.x, self.moveView.frame.origin.y, self.moveView.frame.size.width, self.moveView.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        if (self.titleBtnClick) {
            
            self.titleBtnClick(button);
        }
       
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
