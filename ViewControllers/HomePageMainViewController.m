//
//  HomePageMainViewController.m
//  ShareMySoul
//
//  Created by 古玉彬 on 15/11/30.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "HomePageMainViewController.h"

@interface HomePageMainViewController ()

@end

@implementation HomePageMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏相关
    [self setNavigation];
    
    self.view.backgroundColor = [UIColor orangeColor];
    
}

#pragma mark -  导航栏相关
- (void)setNavigation {
    
    //显示导航栏
    self.navigationController.navigationBar.hidden = NO;
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
