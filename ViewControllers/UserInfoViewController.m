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
   
    
}

#pragma mark - initLayout
- (void)initLayout {
    
    //背景色
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    
    CGFloat headWidth = _viewWidth / 3.0;
    _headView = [[CicleView alloc] initWithFrame:CGRectMake(_viewMinX +  _viewWidth/2.0f - headWidth/2.0f, _viewWidth/2.0f - headWidth/2.0f, headWidth, headWidth) withShadownColor:[UIColor blackColor] withBorderColor:[UIColor blackColor] andImage:imageNameRenderStr(default_head_image)];
    _headView.tag = 500 + 0;
    [self.view addSubview:_headView];
    
    //用户昵称
    _nickNameLabel = [MyCustomView createLabelWithFrame:CGRectMake(_viewMinX, CGRectGetMaxY(_headView.frame)+10, _viewWidth, 40 * scale_screen) textString:@"gugugu" withFont:20 * scale_screen textColor:sys_color(blackColor)];
    [_nickNameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_nickNameLabel];
    
    
    //登陆按钮
    UIButton * logInBtn = [MyCustomView createButtonWithFrame:CGRectMake(_viewMinX, CGRectGetMaxY(_nickNameLabel.frame) + 30, _viewWidth, _nickNameLabel.frame.size.height) target:self SEL:@selector(btnClick:) tag:500 + 1 title:@"登陆" backgroundColor:sys_color(orangeColor)];
    [self.view addSubview:logInBtn];
    
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
//    UIButton * logInBtn = [UIButton buttonWithType: UIButtonTypeCustom];
//    logInBtn.frame = CGRectMake(_viewMinX, 160, _viewWidth, 40);
//    [logInBtn setTitle:@"登陆" forState:UIControlStateNormal];
//    logInBtn.tag = 500 + 2;
//    [logInBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [logInBtn setBackgroundColor:[UIColor orangeColor]];
//    [self.view addSubview:logInBtn];
//    
//    
//    UIButton * bmobBtn = [UIButton buttonWithType: UIButtonTypeCustom];
//    bmobBtn.frame = CGRectMake(_viewMinX, 220, _viewWidth, 40);
//    [bmobBtn setTitle:@"bmob测试" forState:UIControlStateNormal];
//    bmobBtn.tag = 500 + 3;
//    [bmobBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [bmobBtn setBackgroundColor:[UIColor orangeColor]];
//    [self.view addSubview:bmobBtn];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //检测用户是否登陆
    NSData * userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    
    if (userData) {

        UserInfoModel * model = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        NSLog(@"%@",model);
        //加载图片
      [NetManager loadImageWithUrl:[NSURL URLWithString:model.figureurl_qq_2] clearCache:NO block:^(UIImage *image, NSError *error) {
          [_headView setHeadImage:image];
      }];
        //用户昵称
        _nickNameLabel.text = model.nickname;
    }
    else{
        NSLog(@"用户没有登陆");
    }
}


#pragma mark - delegate events 

- (void)btnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(leftBtnClick:)]) {
        [self.delegate leftBtnClick:btn];
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
