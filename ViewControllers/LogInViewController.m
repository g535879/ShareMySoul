//
//  LogInViewController.m
//  ShareMySoul
//
//  Created by 古玉彬 on 15/11/29.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "LogInViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>

@interface LogInViewController ()<TencentSessionDelegate>{
    
    UILabel *resultLable;
    UILabel *tokenLable;
}

@property (strong, nonatomic) TencentOAuth * tencntOAuth;

/**
 *  权限
 */
@property (copy, nonatomic) NSArray * permissions;
@end


@implementation LogInViewController

-(void) viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    
    [self initLogin];
    
        
}

#pragma mark - initLogin
- (void)initLogin {
    
    self.tencntOAuth = [[TencentOAuth alloc] initWithAppId:TENCNT_APP_ID andDelegate:self];
    
    //权限列表设置
    self.permissions = @[@"get_user_info",@"get_simple_userinfo",@"add_t"];
    
    //登陆
    [self.tencntOAuth authorize:self.permissions inSafari:NO];
    //sdffsdfsd f
}

//没有登录
- (void)tencentDidNotLogin:(BOOL)cancelled {
    
}

#pragma mark - tencntDelegate

//登陆完成
- (void)tencentDidLogin {
    
    self.title = @"登陆完成";
    if (self.tencntOAuth.accessToken && 0 != [self.tencntOAuth.accessToken length]) {
        
        //记录用户openId ,token,以及过期时间
        NSLog(@"token:%@",self.tencntOAuth.accessToken);
        //获取用户个人信息
        [self.tencntOAuth getUserInfo];
    }else{
        NSLog(@"登陆不成功,没有获取accessToken");
    }
}

//网络错误登陆失败
- (void)tencentDidNotNetWork {
    NSLog(@"无网络连接");
}


//用户信息
- (void)getUserInfoResponse:(APIResponse *)response {
    NSLog(@"UserInfo:%@",response.jsonResponse);
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
