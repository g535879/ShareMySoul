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
#import "HomePageMainViewController.h"
#import "UserInfoViewController.h"
#import "SlideViewController.h"
#import <MBProgressHUD.h>

@interface LogInViewController ()<TencentSessionDelegate>{
    
    UIButton * _QQBtn; //qq登陆按钮
    UIButton * _touristBtn; // 游客登陆
    
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
    
    //布局
    [self creataLayout];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - 布局
- (void)creataLayout {
    
    CGFloat head_width = screen_Width / 4.0f;
    
    //qq登陆按钮
    _QQBtn = [MyCustomView createButtonWithFrame:CGRectMake(screen_Width / 2.0f - head_width / 2.0f,screen_Width / 2.0f - head_width / 2.0f,head_width,head_width) target:self SEL:@selector(loginBtnClick:) backgroundImage:imageStar(@"qq_btn.png")];
    [_QQBtn setBackgroundColor:[UIColor blackColor]];
    [_QQBtn setBackgroundImage:imageStar(@"qq_btns.png") forState:UIControlStateHighlighted];
    _QQBtn.layer.cornerRadius = head_width / 2.0;
    _QQBtn.tag = 100 + 1;
    [self.view addSubview:_QQBtn];
    
    //游客登陆按钮
    _touristBtn = [MyCustomView createButtonWithFrame:CGRectMake(screen_Width / 2 - screen_Width / 6.0 , screen_Height - 60 * scale_screen, screen_Width / 3.0 , 40 * scale_screen) target:self SEL:@selector(loginBtnClick:) backgroundImage:nil title:@"游客登陆" forwardImage:nil];
    _touristBtn.tag = 100 + 2;
    [_touristBtn setBackgroundColor:[UIColor blackColor]];
    _touristBtn.layer.cornerRadius = 3;
    [_touristBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_touristBtn];
    

    
}

#pragma mark - initLogin
- (void)initLogin {
    
    self.tencntOAuth = [[TencentOAuth alloc] initWithAppId:TENCNT_APP_ID andDelegate:self];
    
    //权限列表设置
    self.permissions = @[@"get_user_info",@"get_simple_userinfo",@"add_t"];
    
    //登陆
    [self.tencntOAuth authorize:self.permissions inSafari:NO];

}

#pragma mark - 登陆按钮点击
- (void)loginBtnClick:(UIButton *)btn {
    
    switch (btn.tag - 100) {
            //qq
        case 1:
            [self initLogin];
            break;
        case 2:
        {
            [self pushHomePage];

        }
            break;
        default:
            break;
    }
    
}

//跳转至主界面
- (void)pushHomePage {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UINavigationController * mainVC = [[UINavigationController alloc] initWithRootViewController:[[HomePageMainViewController alloc] init]];
    
    
    UserInfoViewController * uVC = [[UserInfoViewController alloc] init];
    
    SlideViewController * svc = [[SlideViewController alloc] initWithFrame:self.view.bounds LeftVC:uVC andMainVC:mainVC];
    //跳转到主界面
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    window.rootViewController = svc;
}

//没有登录
- (void)tencentDidNotLogin:(BOOL)cancelled {
    
    
    [self pushHomePage];
}

#pragma mark - tencntDelegate


//登陆完成
- (void)tencentDidLogin {
    
    //加载框
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (self.tencntOAuth.accessToken && 0 != [self.tencntOAuth.accessToken length]) {
        
        //记录用户openId ,token,以及过期时间
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
    
    [self pushHomePage];
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
            //获取最新数据并保存
            [self getNewUserData];
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
        
        //跳转至主界面
        [self pushHomePage];
        
    }];
}


//保存用户到缓存
- (void)saveUserIncacheWithModel:(id)model {

    UserInfoModel * uModel = [[UserInfoModel alloc] initWithDictionary:[model toDictionary] error:nil];
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:uModel];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"user"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //发送通知更新用户界面
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_USERINFO object:nil];
    NSLog(@"数据缓存本地成功");
    
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
