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
#import "RegisterModel.h"

@interface LogInViewController ()<TencentSessionDelegate>{
    
    UILabel *resultLable;
    UILabel *tokenLable;

    RegisterModel * _regModel; //用户注册模型
    NSString *_uId;//身份识别码
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
//        NSLog(@"token:%@",self.tencntOAuth.accessToken);
        //身份id
        _uId = [self.tencntOAuth openId];
        
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
    
    
    //注册用户建模
    _regModel = [[RegisterModel alloc] init];
    _regModel.nickname = response.jsonResponse[@"nickname"];
    _regModel.figureurl_qq_2 = response.jsonResponse[@"figureurl_qq_2"];
    _regModel.sex = response.jsonResponse[@"gender"];
    _regModel.openid = _uId;
    
    //查询是否已经存在
    [BmobHelper SelectDataWithClassName:USER_DB andWithReturnModelClass:[RegisterModel class] withParam:@{@"openid":_uId} withReponseData:^(id dataModel, NSError *error) {
        if (!dataModel) {

            //不存在。新建用户
            [BmobHelper insertDataWithModel:_regModel withName:USER_DB withBlock:^(BOOL isSuccess, NSError *error) {
                if (isSuccess) {
                    NSLog(@"添加用户成功");
                    
                    //获取最新数据保存到本地
                    [self getNewUserData];
                }
                else{
                    NSLog(@"添加用户失败");
                }
            }];
        }
        else{
            //获取id
            _regModel.objectId = [dataModel objectId];
//            更新用户信息
            [BmobHelper updateDataWithClassName:USER_DB WithModel:_regModel withBlock:^(BOOL isSuccess, NSError *error) {
                
                if (isSuccess) {
                    NSLog(@"更新用户成功");
                    //获取最新数据并保存
                    [self getNewUserData];
                }
                else{
                    NSLog(@"更新用户失败:%@",error);
                }
            }];
        }
    }];
}

//获取最新数据缓存到本地
- (void)getNewUserData {
    
    // 获取最新数据
    [BmobHelper SelectDataWithClassName:USER_DB andWithReturnModelClass:[RegisterModel class] withParam:@{@"openid":_uId} withReponseData:^(id dataModel, NSError *error) {
        
        if (dataModel) {
            //保存用户数据到缓存
            [self saveUserIncacheWithModel:dataModel];
        }
    }];
}


//保存用户到缓存
- (void)saveUserIncacheWithModel:(id)model {

    UserInfoModel * uModel = [[UserInfoModel alloc] initWithDictionary:[model toDictionary] error:nil];
    [uModel setFigureurl_qq_2:nil];
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:uModel];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"user"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"数据缓存本地成功");
    
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
