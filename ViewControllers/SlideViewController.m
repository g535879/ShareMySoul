//
//  SlideViewController.m
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/4.
//  Copyright © 2015年 gf. All rights reserved.
//
#import "SlideViewController.h"
#import "UserInfoViewController.h"
#import "MyFeelViewController.h"
#import  "TestBmobViewController.h"
#import "LogInViewController.h"

@interface SlideViewController ()<UIScrollViewDelegate,SlideViewDelegate>{
    
    UIScrollView * _bgScrollView; //背景滚动视图
    UserInfoViewController * _leftVC; //左侧视图控制器
    UIViewController * _mainVC; //右侧视图控制器
    UIView * clearViews; //遮罩层
    CGFloat _viewWidth;
    CGFloat _viewHeight;

}

@end

@implementation SlideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openSlide:) name:@"openSlideEnable" object:nil];
    

}


- (instancetype)initWithFrame:(CGRect)frame LeftVC:(UIViewController *)leftVC andMainVC:(UIViewController *)mainVC {

    if (self = [super init]) {
        
        _leftVC = (id)leftVC;
        _mainVC = mainVC;
        self.view.frame = frame;
        _viewWidth = frame.size.width;
        _viewHeight = frame.size.height;
        [self createLayout];
    }
    return self;
}

#pragma mark - 布局
- (void)createLayout {
    
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, _viewHeight)];
    [_bgScrollView setContentSize:CGSizeMake(_viewWidth * 2, _viewHeight)];
    _bgScrollView.bounces = NO;
    _bgScrollView.delegate = self;
    _bgScrollView.pagingEnabled = YES;
    _bgScrollView.showsHorizontalScrollIndicator = NO;
    _bgScrollView.contentOffset = CGPointMake(_viewWidth, 0);
    [self.view addSubview:_bgScrollView];
    
    CGRect rect = _mainVC.view.frame;
    rect.origin.x = _viewWidth;
    _mainVC.view.frame = rect;
    _mainVC.view.layer.shadowColor = [UIColor blackColor].CGColor;
    _mainVC.view.layer.shadowOpacity = 0.4;
    _mainVC.view.layer.shadowRadius = 7.0f;
    _mainVC.view.layer.masksToBounds = NO;
    [_bgScrollView addSubview:_leftVC.view];
    [_bgScrollView addSubview:_mainVC.view];
     _leftVC.delegate = self;
    [self addChildViewController:_leftVC];
    [self addChildViewController:_mainVC];
    
    //遮罩view
    clearViews = [[UIView alloc] initWithFrame:_mainVC.view.frame];
    [clearViews addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(svcTap:)]];
    clearViews.hidden = YES;
    [_bgScrollView addSubview:clearViews];
    
    
}

#pragma mark - scrollView delegate 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat  offsetX = scrollView.contentOffset.x;
    
    if (clearViews.hidden) {
        
        clearViews.hidden = NO;
        
    }
    
    //最大偏移量
    if (offsetX < _viewWidth / 4.0) {
        _bgScrollView.contentOffset = CGPointMake(_viewWidth / 4.0, 0);
    }
    
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x == _viewWidth) {
        clearViews.hidden = YES;
    }
    
}

#pragma mark - 点击手势
//关闭抽屉
- (void)svcTap:(UITapGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self closeSliderWindow];
    }
}


#pragma mark -  delegate event

- (void)leftBtnClick:(UIButton *)btn {
    
    if (![_mainVC isKindOfClass:[UINavigationController class]]) {
        return;
    }
    
    UINavigationController * nc = (UINavigationController *)_mainVC;
    
    switch (btn.tag - 500) {
            //我的心情
        case 1:
        {

            [nc pushViewController:[[MyFeelViewController alloc] init] animated:NO];
        }
            break;
        //登陆
        case 2:
        {
            [nc pushViewController:[[LogInViewController alloc] init] animated:YES];
        }
            break;
        //测试 bmob
        case 3:
        {
            [nc pushViewController:[[TestBmobViewController alloc] init] animated:YES];
        }
        default:
            break;
    }
    
    //关闭可拖动状态
    _bgScrollView.scrollEnabled = NO;
    //关闭抽屉
    [self closeSliderWindow];
}


//关闭抽屉
- (void)closeSliderWindow {
    
    _bgScrollView.pagingEnabled = NO;
    [UIView animateWithDuration:0.4 animations:^{
        _bgScrollView.contentOffset = CGPointMake(_viewWidth, 0);
    } completion:^(BOOL finished) {
        clearViews.hidden = YES;
        _bgScrollView.pagingEnabled = YES;
    }];
}


#pragma mark - 通知中心监听rightVC
- (void)openSlide:(NSNotification *)notification {
    
    if ([notification.name  isEqualToString: @"openSlideEnable"]) {
        
        _bgScrollView.scrollEnabled = YES;
    }
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
