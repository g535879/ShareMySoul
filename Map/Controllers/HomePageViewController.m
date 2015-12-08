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
    
    CLLocationCoordinate2D coor1 = CLLocationCoordinate2DMake(43, 116);
    CLLocationCoordinate2D coor2 = CLLocationCoordinate2DMake(46, 118);
    CLLocationCoordinate2D coor3 = CLLocationCoordinate2DMake(49, 120);
    
    
    UserInfoModel *model = [[UserInfoModel alloc] init];
    model.figureurl_qq_2 = @"download.jpg";
    model.nickname = @"nihao";
    model.sex = @"男";
    
    

    _titleArray = [NSArray arrayWithObjects:@"one",@"two",@"three", nil];
    _subtitleArray = [NSArray arrayWithObjects:@"buzhidao",@"yebuzhidao",@"haibuzhidao", nil];

    
    [self createMapPointAnnotationWithCLLocationCoordinate2D:coor1 withUserModel:model];
    
    [self createMapPointAnnotationWithCLLocationCoordinate2D:coor2 withUserModel:model];
    
}





@end
