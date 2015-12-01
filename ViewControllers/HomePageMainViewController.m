//
//  HomePageMainViewController.m
//  ShareMySoul
//
//  Created by 古玉彬 on 15/11/30.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "HomePageMainViewController.h"
#import "HomePageViewController.h"
#import "NearbyViewController.h"
/**
 分栏控制器背景button宏定义
 */
#define BACKBTN_WIDTH  100.0f
#define BACKBTN_HETGHT 30.0f

@interface HomePageMainViewController ()

@property (nonatomic,strong) UIView *moveView;
@property (nonatomic,strong) UIButton *leftButton;
@property (nonatomic,strong) UIButton *rightButton;
@property (nonatomic,strong) UIView *frameView;

@property (nonatomic,strong) UIViewController *currentViewController;
@property (nonatomic,strong) HomePageViewController *homePageVC;
@property (nonatomic,strong) NearbyViewController *nearByVC;

@end

@implementation HomePageMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTitleView];
    [self createViewManagement];
}

#pragma mark -  导航栏相关
- (void)setNavigation {
    
    //显示导航栏
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark -创建Navigation中的titleView
- (void)createTitleView{
    
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
    
    [self.view addSubview:backView];
}
#pragma mark -点击事件
- (void)buttonClicked:(UIButton *)button{
    
    if((self.currentViewController == _homePageVC && button.tag == 10) || (self.currentViewController == _nearByVC && button.tag == 20)){
        return ;
    }else{
        if (button.tag == 10) {
            [self replaceController:self.currentViewController newController:_homePageVC];
        }else{
            [self replaceController:self.currentViewController newController:_nearByVC];
        }
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.moveView.frame = CGRectMake(button.frame.origin.x, self.moveView.frame.origin.y, self.moveView.frame.size.width, self.moveView.frame.size.height);
        
    }];
}

#pragma mark -创建视图管理
- (void)createViewManagement{

    _homePageVC = [[HomePageViewController alloc] init];
    _homePageVC.view.frame = CGRectMake(0, 64, screen_Width, screen_Height);
    [self addChildViewController:_homePageVC];
    
    _nearByVC = [[NearbyViewController alloc] init];
    _nearByVC.view.frame = CGRectMake(0, 64, screen_Width, screen_Height );
    [self addChildViewController:_nearByVC];
    
    [self.view addSubview:_homePageVC.view];
    self.currentViewController = self.homePageVC;
}

#pragma mark -视图切换方法
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController{
    
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:2.0 options:UIViewAnimationOptionCurveLinear animations:nil completion:^(BOOL finished) {
        
        if (finished) {
            [newController didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            self.currentViewController = newController;
            
        }else{
            
            self.currentViewController = oldController;
        }
    }];
    
}

@end
