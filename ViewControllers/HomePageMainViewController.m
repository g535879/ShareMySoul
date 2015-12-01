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
#import "HomePageTitleView.h"

@interface HomePageMainViewController ()

/**
 *  顶部分栏控制器视图
 */
@property (nonatomic, strong) HomePageTitleView * topTitleView;

@property (nonatomic,weak) UIViewController *currentViewController;
@property (nonatomic,strong) HomePageViewController *homePageVC;
@property (nonatomic,strong) NearbyViewController *nearByVC;
@end

@implementation HomePageMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTitleView];
    [self createViewManagement];
}



#pragma mark -创建Navigation中的titleView
- (void)createTitleView{
    
    self.topTitleView = [[HomePageTitleView alloc] initWithFrame:CGRectMake(0, 0, screen_Width, 64) andBlock:^(UIButton *button) {
        
        if((self.currentViewController == _homePageVC && button.tag == 10) || (self.currentViewController == _nearByVC && button.tag == 20)){
            return ;
        }else{
            if (button.tag == 10) {
                
                [self replaceController:self.currentViewController newController:_homePageVC];
            }else{
                [self replaceController:self.currentViewController newController:_nearByVC];
            }
        }
    }];
   
    [self.view addSubview:self.topTitleView];
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
