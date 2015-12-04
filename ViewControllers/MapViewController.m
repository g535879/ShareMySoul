//
//  MapViewController.m
//  ShareMySoul
//
//  Created by 伏董 on 15/12/3.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //配置用户 Key
    [MAMapServices sharedServices].apiKey = GEO_API_KEY;
    
    //AMapLocationManager使用前需要配置AMapLocationServices Key
    [AMapLocationServices sharedServices].apiKey = GEO_API_KEY;
    
    [self.view addSubview:[self createMapViewWithFrame:CGRectMake(0, 0, screen_Width, screen_Height-64)]];
    
    UIButton *trafficButton = [UIButton buttonWithType:UIButtonTypeCustom];
    trafficButton.frame = CGRectMake(screen_Height - 400, screen_Width-120, 120, 120);
    [trafficButton setTitle:@"交通" forState:UIControlStateNormal];
    [trafficButton addTarget:self action:@selector(trafficButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:trafficButton];
    
}

#pragma mark -创建地图视图
- (MAMapView *)createMapViewWithFrame:(CGRect)frame{
    
    
    _mapView = [[MAMapView alloc] initWithFrame:frame];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    
    //地图类型
    //mv.mapType = (MAMapTypeSatellite | MAMapTypeStandard);
    
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    _mapView.showTraffic = NO;
    
    _locationManager = [[AMapLocationManager alloc] init];
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    
    
    return _mapView;

}

- (void)trafficButtonClicked:(UIButton *)button{
    
    _mapView.showTraffic = YES;

}


#pragma mark -AMapLocationManager代理协议
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location{

    NSLog(@"dingweiwancheng");
    [_locationManager stopUpdatingLocation];

}
//#pragma mark -创建系统annotation
//- (void)createSystemAnnotation{
//
//    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
//    pointAnnotation.coordinate = CLLocationCoordinate2DMake(39.98, 116.48);
//
//    [_mapView addAnnotation:pointAnnotation];
//}



@end
