//
//  LogInViewController.m
//  ShareMySoul
//
//  Created by 古玉彬 on 15/11/29.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "LogInViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "UserInfoModel.h"
#import "MessageModel.h"

@interface LogInViewController ()<TencentSessionDelegate>{
    
    UILabel *resultLable;
    UILabel *tokenLable;
    UserInfoModel * _uModel; //用户模型
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
    
    //用户建模
    _uModel = [[UserInfoModel alloc] init];
}

#pragma mark - initLogin
- (void)initLogin {
    
    self.tencntOAuth = [[TencentOAuth alloc] initWithAppId:TENCNT_APP_ID andDelegate:self];
    
    //权限列表设置
    self.permissions = @[@"get_user_info",@"get_simple_userinfo",@"add_t"];
    
    //登陆
    [self.tencntOAuth authorize:self.permissions inSafari:NO];

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
        
        //得到的qq授权信息，请按照例子来生成NSDictionary
        NSDictionary *responseDictionary = @{@"access_token": self.tencntOAuth.accessToken,@"uid":self.tencntOAuth.openId,@"expirationDate":self.tencntOAuth.expirationDate};
        //通过授权信息注册登录
        [BmobUser loginInBackgroundWithAuthorDictionary:responseDictionary
                                               platform:BmobSNSPlatformQQ
                                                  block:^(BmobUser *user, NSError *error) {
                                                      NSLog(@"error%@",[error description]);
                                                  }];
        
        //身份id
        _uModel.openid = [self.tencntOAuth openId];
        //获取用户个人信息
        [self.tencntOAuth getUserInfo];
    }else{

#warning  提示用户登陆失败
        NSLog(@"登陆不成功,没有获取accessToken");
    }
}

//网络错误登陆失败
- (void)tencentDidNotNetWork {
    NSLog(@"无网络连接");
}


//用户信息
- (void)getUserInfoResponse:(APIResponse *)response {
    
    
    _uModel.nickname = response.jsonResponse[@"nickname"];
    _uModel.figureurl_qq_2 = response.jsonResponse[@"figureurl_qq_2"];
    
//    //保存数据到后台
    [BmobHelper saveUserWithModel:_uModel withBlock:^(BOOL isSuccess, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }
        else {
            NSLog(@"保存成功");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - touch event

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
