//
//  HomePageViewController.m
//  ShareMySoul
//
//  Created by 古玉彬 on 15/11/30.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "HomePageViewController.h"
#import "MapViewController.h"
@interface HomePageViewController ()

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:[self createMapViewWithFrame:CGRectMake(0, 0, screen_Width, screen_Height-64)]];
    
    
    
    //[self geoCodeWithAddress:@"车站"];
    
    [self ReGeocodeWithWithLatitude:43 withLongitude:116];
    
}





@end
