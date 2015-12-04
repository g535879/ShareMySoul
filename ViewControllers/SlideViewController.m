//
//  SlideViewController.m
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/4.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "SlideViewController.h"

@interface SlideViewController ()<UIScrollViewDelegate>{
    
    UIScrollView * _bgScrollView; //背景滚动视图
    UIViewController * _leftVC; //左侧视图控制器
    UIViewController * _mainVC; //右侧视图控制器
    UIView * clearViews; //遮罩层
    CGFloat _viewWidth;
    CGFloat _viewHeight;

}

@end

@implementation SlideViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}


- (instancetype)initWithFrame:(CGRect)frame LeftVC:(UIViewController *)leftVC andMainVC:(UIViewController *)mainVC {

    if (self = [super init]) {
        
        _leftVC = leftVC;
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
    _bgScrollView.contentOffset = CGPointMake(_viewWidth, 0);
    [self.view addSubview:_bgScrollView];
    
    CGRect rect = _mainVC.view.frame;
    rect.origin.x = _viewWidth;
    _mainVC.view.frame = rect;
    [_bgScrollView addSubview:_mainVC.view];
    [_bgScrollView addSubview:_leftVC.view];
    
    if ([_leftVC isKindOfClass:[UINavigationController class]]) {
        [self addChildViewController:_leftVC];
    }
    if ([_mainVC isKindOfClass:[UINavigationController class]]) {
        [self addChildViewController:_mainVC];
    }
    
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
        scrollView.contentOffset = CGPointMake(_viewWidth / 4.0, 0);
    }
    
    
}

#pragma mark - 点击手势
//关闭抽屉
- (void)svcTap:(UITapGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.3 animations:^{
            _bgScrollView.contentOffset = CGPointMake(_viewWidth, 0);
        } completion:^(BOOL finished) {
            clearViews.hidden = YES;
        }];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x == _viewWidth) {
        clearViews.hidden = YES;
    }
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
