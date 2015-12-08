//
//  AppDelegate.m
//  ShareMySoul
//
//  Created by 古玉彬 on 15/11/29.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "AppDelegate.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WelcomePageViewController.h"
#import "UserInfoModel.h"
#import "LogInViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
//    //高德地图key
//    [MAMapServices sharedServices].apiKey = GEO_API_KEY;
//    //高德地图定位
//    [AMapLocationServices sharedServices].apiKey = GEO_API_KEY;
//    //高德地图搜索服务
//    [AMapSearchServices sharedServices].apiKey = GEO_API_KEY;
    //bmob key
    [Bmob registerWithAppKey:BMOB_APP_KEY];
    
    UINavigationController * nvc;
    //判断是否有本地用户数据
    if ([self initUserInfo]) {
        
        //进入欢迎页面
        nvc = [[UINavigationController alloc] initWithRootViewController:[[WelcomePageViewController alloc] init]];
        
        
    }else {
        
        //跳转登陆界面
        nvc = [[UINavigationController alloc] initWithRootViewController:[[LogInViewController alloc] init]];
        
    }
    
    self.window.rootViewController = nvc;
    
    return YES;
}

#pragma mark - 加载用户数据
- (BOOL)initUserInfo {
    
    //检测用户是否登陆
    NSData * userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    
    if (userData) {
        
        //用户模型
        UserInfoModel * model = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        
        //全局单例对象
        UserManage * manager = [UserManage defaultUser];
        manager.currentUser = model;
        
        return YES;
    }
    
    else{
        NSLog(@"用户没有登陆");
        return NO;
    }
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [TencentOAuth HandleOpenURL:url];
}

//handleOpenURL:
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [TencentOAuth HandleOpenURL:url];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
