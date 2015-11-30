//
//  HomePageViewController.m
//  ShareMySoul
//
//  Created by 古玉彬 on 15/11/30.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "HomePageViewController.h"
#import "DrawerView.h"

@interface HomePageViewController (){
    
    DrawerView * _drawView;  //抽屉视图
}

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //布局
    [self createLayout];
}
#pragma mark - 布局
- (void)createLayout {
    
    //抽屉视图
    _drawView = [[DrawerView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_drawView];
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
