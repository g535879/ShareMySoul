//
//  WelcomePageViewController.m
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/7.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "WelcomePageViewController.h"
#import "CicleView.h"
#import "HomePageMainViewController.h"
#import "UserInfoViewController.h"
#import "SlideViewController.h"
#import "AppDelegate.h"
#import "UserInfoModel.h"

@interface WelcomePageViewController (){
    
    CicleView * _headView; //头像
    UILabel * _nickNameLabel; //昵称
    UILabel * _welcomeLabel; //欢迎文字

}

@end

@implementation WelcomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    [self pushHomePage];
//    return;
    //布局
    [self initLayout];
    //加载用户数据
    [self initUserInfo];
    
}
#pragma mark -  布局
- (void)initLayout {
    
    //头像宽度
    CGFloat head_width = screen_Width / 4.0f;
    
    _headView = [[CicleView alloc] initWithFrame:CGRectMake(screen_Width / 2.0f - head_width / 2.0f,3 * (screen_Width / 2.0f - head_width / 2.0f) / 2.0+40 * scale_screen,head_width,head_width) withShadownColor:[UIColor blackColor] withBorderColor:[UIColor clearColor] andImage:imageStar(default_head_image)];
    _headView.hidden = YES;
    [self.view addSubview:_headView];

    //用户昵称
    _nickNameLabel = [MyCustomView createLabelWithFrame:CGRectMake(0,CGRectGetMaxY(_headView.frame) + 5 - 40 * scale_screen,screen_Width,20)textString:@"游客" withFont:20 * scale_screen textColor:sys_color(blackColor)];
    [_nickNameLabel setTextAlignment:NSTextAlignmentCenter];
    _nickNameLabel.hidden = YES;
    [self.view addSubview:_nickNameLabel];
    
    //欢迎回来文字
    _welcomeLabel = [MyCustomView createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(_nickNameLabel.frame) + 5, screen_Width, 20) textString:@"欢迎回来" withFont:20 * scale_screen textColor:sys_color(grayColor)];
    [_welcomeLabel setTextAlignment:NSTextAlignmentCenter];
    _welcomeLabel.alpha = 0;
    [self.view addSubview:_welcomeLabel];
    
}

- (void)initUserInfo {
    
    UserManage * manager = [UserManage defaultUser];
    
    //加载图片
    __weak typeof(self) weakSelf = self;
    [NetManager loadImageWithUrl:[NSURL URLWithString:manager.currentUser.head_image] clearCache:NO block:^(UIImage *image, NSError *error) {

        [_headView setHeadImage:image];
        
        _nickNameLabel.text = manager.currentUser.nickname;
        [weakSelf performSelector:@selector(showAnimation) withObject:nil afterDelay:0.5f];
        }];
}

#pragma  mark 展示动画
- (void)showAnimation {
    

    CGPoint headViewCenter = _headView.center;
    _headView.hidden = NO;
    [UIView animateWithDuration:1.0f animations:^{
        _headView.center = CGPointMake(headViewCenter.x, headViewCenter.y - 40 * scale_screen);
    } completion:^(BOOL finished) {
        _nickNameLabel.hidden = NO;
        [UIView animateWithDuration:1.5f animations:^{
            _welcomeLabel.alpha = 1;
            
        } completion:^(BOOL finished) {
            [NSThread sleepForTimeInterval:1.0f];
            
            //跳转登陆
            [self pushHomePage];
            }];
    }];
}

- (void)pushHomePage {
    UINavigationController * mainVC = [[UINavigationController alloc] initWithRootViewController:[[HomePageMainViewController alloc] init]];
    
    
    UserInfoViewController * uVC = [[UserInfoViewController alloc] init];
    
    SlideViewController * svc = [[SlideViewController alloc] initWithFrame:self.view.bounds LeftVC:uVC andMainVC:mainVC];
    
    //跳转到主界面
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    window.rootViewController = svc;

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
