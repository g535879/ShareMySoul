//
//  UserInfoViewController.m
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/4.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "UserInfoViewController.h"
#import "MyFeelViewController.h"
#import "CicleView.h"

@interface UserInfoViewController (){
    //我的心情按钮
    UIButton * _myInfoMsg;
    CGFloat  _viewWidth; //控件最大宽度
    CGFloat  _viewMinX; //控件最小开始
    CicleView * _headView;//头像
    UILabel * _nickNameLabel;//昵称
    UIButton * _loginBtn; //登陆按钮
    UIButton * _myFeelBtn; //我的心情按钮
    
    
}

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rect = self.view.frame;
    _viewWidth = rect.size.width * 3 / 4.0;
    _viewMinX = rect.size.width / 4.0;
    
    //初始化布局
    [self initLayout];
   
    //通知中心监听用户登陆变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoChanged:) name:UPDATE_USERINFO object:nil];
}

#pragma mark - initLayout
- (void)initLayout {
    
    //背景色
//    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    
    CGFloat headWidth = _viewWidth / 3.0;
    _headView = [[CicleView alloc] initWithFrame:CGRectMake(_viewMinX +  _viewWidth/2.0f - headWidth/2.0f, _viewWidth/2.0f - headWidth/2.0f, headWidth, headWidth) withShadownColor:[UIColor blackColor] withBorderColor:[UIColor blackColor] andImage:imageNameRenderStr(default_head_image)];
    _headView.tag = 500 + 0;
    [self.view addSubview:_headView];
    
    //用户昵称
    _nickNameLabel = [MyCustomView createLabelWithFrame:CGRectMake(_viewMinX, CGRectGetMaxY(_headView.frame)+10, _viewWidth, 40 * scale_screen) textString:@"游客" withFont:30 * scale_screen textColor:sys_color(blackColor)];
    [_nickNameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_nickNameLabel];
    
    
    //登陆按钮
   _loginBtn = [MyCustomView createButtonWithFrame:CGRectMake(_viewMinX, CGRectGetMaxY(_nickNameLabel.frame) + 30, _viewWidth, _nickNameLabel.frame.size.height) target:self SEL:@selector(btnClick:) tag:500 + 1 title:@"登陆" backgroundColor:sys_color(orangeColor)];
    [self.view addSubview:_loginBtn];
    
    
    //我的心情按钮
    
    _myFeelBtn = [MyCustomView createButtonWithFrame:CGRectMake(_viewMinX, CGRectGetMaxY(_loginBtn.frame) + 30, _viewWidth, _loginBtn.frame.size.height) target:self SEL:@selector(btnClick:) tag:500 + 2 title:@"我的心情" backgroundColor:sys_color(orangeColor)];
    [self.view addSubview:_myFeelBtn];
    
//    _myInfoMsg = [UIButton buttonWithType:UIButtonTypeCustom];
//    _myInfoMsg.frame = CGRectMake(_viewMinX, 100, _viewWidth, 40);
//    _myInfoMsg.tag = 500 + 1;
//    _myInfoMsg.backgroundColor = [UIColor orangeColor];
//    [_myInfoMsg setTitle:@"我的心情" forState:UIControlStateNormal];
//    [_myInfoMsg setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//    [_myInfoMsg setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_myInfoMsg addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_myInfoMsg];
//
//    
//    
    UIButton * bmobBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    bmobBtn.frame = CGRectMake(_viewMinX, 220, _viewWidth, 40);
    [bmobBtn setTitle:@"bmob测试" forState:UIControlStateNormal];
    bmobBtn.tag = 500 + 3;
    [bmobBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bmobBtn setBackgroundColor:[UIColor orangeColor]];
    [self.view addSubview:bmobBtn];
    
}

#pragma mark - 加载用户数据


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //显示缓存数据
    [self updateUserInfoCleanCache:NO];
}


#pragma mark - delegate events 

- (void)btnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(leftBtnClick:)]) {
        [self.delegate leftBtnClick:btn];
    }
}


#pragma mark - 更新用户数据
- (void)updateUserInfoCleanCache:(BOOL)cleanCache {
    
    //检测用户是否登陆
    NSData * userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    
    if (userData) {
        
        UserInfoModel * model = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        //加载图片
        [NetManager loadImageWithUrl:[NSURL URLWithString:model.head_image] clearCache:cleanCache block:^(UIImage *image, NSError *error) {
            [_headView setHeadImage:image];
        }];
        //用户昵称
        _nickNameLabel.text = model.nickname;
        
        [_loginBtn setTitle:@"切换用户" forState:UIControlStateNormal];
    }
    else{
        [_loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
        NSLog(@"用户没有登陆");
    }
}


#pragma mark - 通知中心事件监听
- (void)userInfoChanged:(NSNotification *)notification {
    
    if ([notification.name isEqualToString:UPDATE_USERINFO]) {
        [self updateUserInfoCleanCache:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
