//
//  UserInfoViewController.m
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/4.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "UserInfoViewController.h"
#import "MyFeelViewController.h"

@interface UserInfoViewController (){
    //我的心情按钮
    UIButton * _myInfoMsg;
}

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _myInfoMsg = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect rect = self.view.frame;
    _myInfoMsg.frame = CGRectMake(rect.size.width / 4.0, 100, rect.size.width * 3 / 4.0, 40);
    _myInfoMsg.tag = 500 + 1;
    _myInfoMsg.backgroundColor = [UIColor orangeColor];
    [_myInfoMsg setTitle:@"我的心情" forState:UIControlStateNormal];
    [_myInfoMsg setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_myInfoMsg setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_myInfoMsg addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_myInfoMsg];
    
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    
    UIButton * logInBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    logInBtn.frame = CGRectMake(rect.size.width / 4.0, 160, rect.size.width * 3 / 4.0, 40);
    [logInBtn setTitle:@"登陆" forState:UIControlStateNormal];
    logInBtn.tag = 500 + 2;
    [logInBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [logInBtn setBackgroundColor:[UIColor orangeColor]];
    [self.view addSubview:logInBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"userInfo view appear");
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
