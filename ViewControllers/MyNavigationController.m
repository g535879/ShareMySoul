//
//  MyNavigationController.m
//  ShareMySoul
//
//  Created by 古玉彬 on 15/11/30.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "MyNavigationController.h"
#import "HomePageMainViewController.h"
#import "NearbyViewController.h"

/**
 分栏控制器背景button宏定义
 */
#define BACKBTN_WIDTH  100.0f
#define BACKBTN_HETGHT 30.0f
@interface MyNavigationController ()

@property (nonatomic,strong) UIView *moveView;
@property (nonatomic,strong) UIButton *leftButton;
@property (nonatomic,strong) UIButton *rightButton;
@property (nonatomic,strong) UIView *frameView;


@end

@implementation MyNavigationController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

    
    
    [self createNavigationTitleView];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.    
    
}

#pragma mark -创建Navigation中的titleView
- (void)createNavigationTitleView{
    
    //创建背景视图
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_Width, 64.0f)];
    backView.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    
    self.frameView = [[UIView alloc] initWithFrame:CGRectMake((screen_Width - 2*BACKBTN_WIDTH) / 2, 27.0f, BACKBTN_WIDTH*2, BACKBTN_HETGHT)];
    self.frameView .backgroundColor = [UIColor colorWithRed:0.20f green:0.25f blue:0.30f alpha:1.00f];
    self.frameView .layer.cornerRadius = 15;
    [backView addSubview:self.frameView ];
    
    //创建移动view
    self.moveView = [[UIView alloc] initWithFrame:CGRectMake(1, 1,BACKBTN_WIDTH, BACKBTN_HETGHT - 2)];
    
    self.moveView.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    self.moveView.layer.cornerRadius = 15;
    [self.frameView  addSubview:self.moveView];
    
    //创建button
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton.frame = CGRectMake(1, 1,BACKBTN_WIDTH, BACKBTN_HETGHT - 2);
    [self.leftButton setTitleColor:self.frameView.backgroundColor forState:UIControlStateNormal];
    [self.leftButton setTitle:@"主页" forState:UIControlStateNormal];
    self.leftButton.backgroundColor = [UIColor clearColor];
    [self.leftButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.leftButton.tag = 10;
    [self.frameView addSubview:self.leftButton];
    
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.frame = CGRectMake(BACKBTN_WIDTH - 1, 1,BACKBTN_WIDTH, BACKBTN_HETGHT - 2);
    [self.rightButton setTitleColor:self.moveView.backgroundColor forState:UIControlStateNormal];
    [self.rightButton setTitle:@"我的" forState:UIControlStateNormal];
    self.rightButton.backgroundColor = [UIColor clearColor];
    [self.rightButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.tag = 20;
    [self.frameView addSubview:self.rightButton];
    
    [self.view addSubview:backView];
}

- (void)buttonClicked:(UIButton *)button{
    
    [UIView animateWithDuration:1.0 animations:^{

        if (button.tag == 10) {
            [self.leftButton setTitleColor:self.frameView.backgroundColor forState:UIControlStateNormal];
            [self.rightButton setTitleColor:self.moveView.backgroundColor forState:UIControlStateNormal];
        }else{
            [self.leftButton setTitleColor:self.moveView.backgroundColor forState:UIControlStateNormal];
            [self.rightButton setTitleColor:self.frameView.backgroundColor forState:UIControlStateNormal];
        }

        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5 animations:^{
            self.moveView.frame = CGRectMake(button.frame.origin.x, self.moveView.frame.origin.y, self.moveView.frame.size.width, self.moveView.frame.size.height);
        }];
    }];
    
}


@end
