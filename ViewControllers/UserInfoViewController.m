//
//  UserInfoViewController.m
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/4.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "UserInfoViewController.h"

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel * textLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
    textLabel.text = @"我是用户相关界面";
    textLabel.font = [UIFont systemFontOfSize:50];
//    [textLabel sizeToFit];
    [textLabel setNumberOfLines:7];
    [textLabel setTextColor:[UIColor whiteColor]];
    [textLabel setAdjustsFontSizeToFitWidth:YES];
    
    [self.view addSubview:textLabel];
    [self.view setBackgroundColor:[UIColor blackColor]];
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
