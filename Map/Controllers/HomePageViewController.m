//
//  HomePageViewController.m
//  ShareMySoul
//
//  Created by 古玉彬 on 15/11/30.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "HomePageViewController.h"
#import "UserInfoModel.h"
#import "MapViewController.h"

@interface HomePageViewController ()

@property (nonatomic,copy) NSArray *coordinateArray;
@property (nonatomic,copy) NSArray *titleArray;
@property (nonatomic,copy) NSArray *subtitleArray;


@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:[self createMapViewWithFrame:CGRectMake(0, 0, screen_Width, screen_Height-64)]];
    

}





@end
