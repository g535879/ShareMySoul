//
//  HomePageViewController.m
//  ShareMySoul
//
//  Created by 古玉彬 on 15/11/30.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "HomePageViewController.h"

@interface HomePageViewController ()<MAMapViewDelegate,CLLocationManagerDelegate>{
    //地图视图
    MAMapView *_mapView;
    //位置信息
    CLLocationManager *_locationManager;
}


@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //配置用户 Key
    [MAMapServices sharedServices].apiKey = GEO_API_KEY;
    
    [self createMapView];
}


#pragma mark -创建地图视图
- (void)createMapView{
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    [self.view addSubview:_mapView];
    
    
    _locationManager = [[CLLocationManager alloc] init];
    
    [_locationManager requestWhenInUseAuthorization];
    _locationManager.delegate = self;
    //定位精度
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //定位频率
    _locationManager.distanceFilter = 100.0;
    
    //启动跟踪定位
    [_locationManager startUpdatingLocation];
    
}

//#pragma mark -创建系统annotation
//- (void)createSystemAnnotation{
//    
//    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
//    pointAnnotation.coordinate = CLLocationCoordinate2DMake(39.98, 116.48);
//    
//    [_mapView addAnnotation:pointAnnotation];
//}

#pragma mark -CLLocationManager代理协议
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{

    CLLocation *location = [locations firstObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSLog(@"经度：%f 纬度：%f 海拔：%f 航向：%f 行走速度：%f",coordinate.longitude,location.altitude,location.altitude,location.course,location.speed);
    //[_locationManager stopUpdatingLocation];

}




@end
