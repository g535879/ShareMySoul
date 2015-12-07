//
//  BasicViewController.m
//  ShareMySoul
//
//  Created by 古玉彬 on 15/11/29.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "BasicViewController.h"

@interface BasicViewController ()



@end

@implementation BasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏相关
    [self setNavigationRefer];
}

#pragma mark - 导航栏相关
-  (void)setNavigationRefer {
    
    //隐藏导航栏
    if (self.navigationController) {
        
        self.navigationController.navigationBar.hidden = YES;
    }
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
}




@end
