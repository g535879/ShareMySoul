//
//  MapViewController.m
//  ShareMySoul
//
//  Created by 伏董 on 15/12/3.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()


@property (nonatomic,copy) NSString *addressStr;


@property (nonatomic,copy) AMapLocationManager *locationManager;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    
    //配置用户 Key
    [MAMapServices sharedServices].apiKey = GEO_API_KEY;
    
    [AMapLocationServices sharedServices].apiKey = GEO_API_KEY;
    
    [AMapSearchServices sharedServices].apiKey = GEO_API_KEY;

    
}

#pragma mark -创建地图视图
- (MAMapView *)createMapViewWithFrame:(CGRect)frame{
    
    _mapView = [[MAMapView alloc] initWithFrame:frame];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    _mapView.showTraffic = NO;
    _mapView.zoomLevel = 11.2;

    [self createMeButton];
    [self createTrafficButton];
    
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;

    return _mapView;
}



#pragma mark -创建定位到当前的位置按钮
- (void)createMeButton{
    
    _meButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _meButton.frame = CGRectMake(_mapView.logoCenter.x - (_mapView.logoSize.width / 2), _mapView.logoCenter.y - _mapView.compassSize.height - (_mapView.logoSize.height / 2), _mapView.compassSize.width, _mapView.compassSize.height);

    _meButton.backgroundColor = [UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
    _meButton.layer.cornerRadius = 5;
    [_meButton setBackgroundImage:imageNameRenderStr(@"me") forState:UIControlStateNormal];
    [_meButton addTarget:self action:@selector(meButtonclicked) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:_meButton];

}
//定位到当前位置点击事件
- (void)meButtonclicked{
    
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    
}


#pragma mark -创建交通状况按钮
- (void)createTrafficButton{
    
    _trafficButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _trafficButton.frame = CGRectMake(_mapView.compassOrigin.x, _mapView.compassOrigin.y + _mapView.compassSize.width + 10, _mapView.compassSize.width, _mapView.compassSize.height);
    _trafficButton.backgroundColor = [UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
    _trafficButton.layer.cornerRadius = 5;
    [_trafficButton setBackgroundImage:imageNameRenderStr(@"traffic") forState:UIControlStateNormal];
    [_trafficButton setBackgroundImage:imageNameRenderStr(@"trafficselect") forState:UIControlStateSelected];
    [_trafficButton addTarget:self action:@selector(trafficButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [_mapView addSubview:_trafficButton];
}

//交通状况点击事件
- (void)trafficButtonClicked:(UIButton *)button{
    
    button.selected = !button.selected;
    _mapView.showTraffic = !_mapView.showTraffic;
    
}

#pragma mark -创建地图大头针标注
- (void)createMapPointAnnotationWithLatitude:(CLLocationDegrees)latitude withLongitude:(CLLocationDegrees)longitude withTitle:(NSString *)title withSubTitle:(NSString *)subtitle{
    
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    
    annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    annotation.title = title;
    
    annotation.subtitle = subtitle;
    
    [_mapView addAnnotation:annotation];
    
}

#pragma mark

#pragma mark -mapview协议方法
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    
    _userLocation = [userLocation.location copy];

}

#pragma mark -mapview中点击触发的方法
-(void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate{


    
}

#pragma mark -点击annotationview触发的协议方法
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{

    if ([view.annotation isKindOfClass:[MAUserLocation class]]) {
        
        if (_userLocation) {
            
            AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
            request.location = [AMapGeoPoint locationWithLatitude:_userLocation.coordinate.latitude longitude:_userLocation.coordinate.longitude];
            
            [_search AMapReGoecodeSearch:request];
        }
    }
    
}




#pragma mark -大头针标注
-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{

    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *userLocationID = @"locationID";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:userLocationID];
        
        if (!annotationView) {
            
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:userLocationID];
        }

        annotationView.canShowCallout = YES;
        annotationView.draggable = YES;
        annotationView.pinColor = MAPinAnnotationColorPurple;
        annotationView.animatesDrop = YES;
        annotationView.centerOffset = CGPointMake(0, -18);
        
        return  annotationView;
    }
    
    return nil;
}


//取消选中annotation时将该annotation从视图中移除
- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view{

}




#pragma mark

#pragma mark -正向地理编码
- (void)geoCodeWithAddress:(NSString *)address{
    
    AMapGeocodeSearchRequest *request = [[AMapGeocodeSearchRequest alloc] init];
    request.address = address;
    
    self.addressStr = address;
    
    [_search AMapGeocodeSearch:request];
}

#pragma mark -反向地理编码
- (void)ReGeocodeWithWithLatitude:(CLLocationDegrees)latitude withLongitude:(CLLocationDegrees)longitude{
    
    AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:latitude  longitude:longitude];
    
    
    [_search AMapReGoecodeSearch:request];
    
}


#pragma mark -地理编码调用的协议方法
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response{
    
    if (response.geocodes.count == 0) {
        
#warning 添加弹窗
        
        return;
    }
    
    for (AMapGeocode *code in response.geocodes) {
        
        CLLocationDegrees longitude = code.location.longitude;
        CLLocationDegrees latitude = code.location.latitude;
        
        
        [self createMapPointAnnotationWithLatitude:latitude withLongitude:longitude withTitle:_addressStr withSubTitle:nil];
    }

}

#pragma mark -逆地理编码调用的协议方法
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    
    NSString *title = response.regeocode.addressComponent.city;
    NSString *subtitle = [NSString stringWithFormat:@"%@%@%@",response.regeocode.addressComponent.province,response.regeocode.addressComponent.district,response.regeocode.addressComponent.township];

    if (title.length == 0) {
        title = response.regeocode.addressComponent.province;
    }
    _mapView.userLocation.title = title;
    _mapView.userLocation.subtitle = subtitle;
    
    [self createMapPointAnnotationWithLatitude:request.location.latitude    withLongitude:request.location.longitude withTitle:title withSubTitle:subtitle];
    
}





@end
