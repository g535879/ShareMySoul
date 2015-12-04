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
    
    
    
}

#pragma mark -创建地图视图
- (MAMapView *)createMapViewWithFrame:(CGRect)frame{
    
    
    _mapView = [[MAMapView alloc] initWithFrame:frame];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    

    _locationManager = [[CLLocationManager alloc] init];
    
    [_locationManager requestWhenInUseAuthorization];
    _locationManager.delegate = self;
    //定位精度
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //定位频率
    _locationManager.distanceFilter = 100.0;
    
    //启动跟踪定位
    [_locationManager startUpdatingLocation];
    
    return _mapView;
    
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
