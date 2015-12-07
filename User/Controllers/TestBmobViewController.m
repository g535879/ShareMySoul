//
//  TestBmobViewController.m
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/3.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "TestBmobViewController.h"
#import "MessageModel.h"
#import "UserInfoModel.h"

@interface TestBmobViewController (){
    MessageModel * mModel;
}

@end

@implementation TestBmobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"bmob测试";
    
    //添加一条数据
    mModel = [[MessageModel alloc] init];
    mModel.message = @"我是余佳222222";
    mModel.sex = @"女";

    [self insert];
}

- (void)insert {
    
    UserInfoModel * userInfoModel = [[UserInfoModel alloc] init];
    userInfoModel.sex = @"男";
        [BmobHelper insertDataWithModel:userInfoModel withName:USER_DB withBlock:^(BOOL isSuccess, NSError *error) {
    
            if (error) {
                NSLog(@"%@",error);
            }
            else{
                NSLog(@"ok");
            }
        }];
}

- (void)query {
    
    //测试获取数据
        [BmobHelper queryDataWithClassName:@"UserMessage" andWithReturnModelClass:[MessageModel class] withParam:(NSDictionary<NSString *,NSObject *> *)nil withLimited:0 withArray:^(NSArray *responseArray, NSError *error) {
    
            if (!error) {
    
            }
            else{
                NSLog(@"%@",error);
            }
    
        }];
}

- (void)delete {
    
}

- (void)select {
    
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