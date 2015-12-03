//
//  TestBmobViewController.m
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/3.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "TestBmobViewController.h"
#import "MessageModel.h"

@interface TestBmobViewController ()

@end

@implementation TestBmobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加一条数据
    MessageModel * mModel = [[MessageModel alloc] init];
    mModel.message = @"我是余佳222222";
    mModel.sex = @"女";

    [BmobHelper insertDataWithModel:mModel withName:@"UserMessage" withBlock:^(BOOL isSuccess, NSError *error) {
        
        if (error) {
            NSLog(@"%@",error);
        }
        else{
            NSLog(@"ok");
        }
    }];
    
    
    //测试获取数据
    [BmobHelper queryDataWithClassName:@"UserMessage" andWithReturnModelClass:[MessageModel class] withParam:(NSDictionary<NSString *,NSObject *> *)nil withLimited:0 withArray:^(NSArray *responseArray, NSError *error) {
        
        if (!error) {

        }
        else{
            NSLog(@"%@",error);
        }

    }];
    
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
