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
@property (nonatomic,copy) CLLocationManager *locationManger;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //配置用户 Key
    [MAMapServices sharedServices].apiKey = GEO_API_KEY;
    
    [AMapSearchServices sharedServices].apiKey = GEO_API_KEY;

}

#pragma mark -创建地图视图
- (MAMapView *)createMapViewWithFrame:(CGRect)frame{
    
    _mapView = [[MAMapView alloc] initWithFrame:frame];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeNone;
    _mapView.showTraffic = NO;
    //是否显示楼块
    _mapView.showsBuildings = NO;
    //是否显示室内地图
    _mapView.showsIndoorMap = NO;
    //是否可以旋转
    _mapView.rotateEnabled = NO;
    _mapView.touchPOIEnabled = NO;
    _mapView.rotateCameraEnabled = NO;
    //天空模式
    _mapView.skyModelEnable = NO;
    //缩放级别
    [_mapView setZoomLevel:17.5 animated:YES];
    

    [self createMeButton];
    
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
    
    if (_mapView.userTrackingMode != MAUserTrackingModeFollow) {

        [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
        
        
        [BmobHelper messageWithCurrentLocation:_userLocation.coordinate maxDistance:1.0f withBlock:^(NSArray *responseArray, NSError *error) {
            
            
            for (MessageModel *model in responseArray) {
                
                [self createMapPointAnnotationWithCLLocationCoordinate2D:CLLocationCoordinate2DMake(model.location.latitude, model.location.longitude) withUserModel:model];
                NSLog(@"haha");
            }

        }];
    }
    
}



#pragma mark -创建地图大头针标注
- (void)createMapPointAnnotationWithCLLocationCoordinate2D:(CLLocationCoordinate2D)coordinate2D withUserModel:(UserInfoModel *)model{
    
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    
    annotation.coordinate = coordinate2D;
    
    [_mapView addAnnotation:annotation];
    
}

#pragma mark

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    
    if (updatingLocation) {
        _userLocation = [userLocation.location copy];
        CLGeocoder * revGeo = [[CLGeocoder alloc] init];
        CLLocation * clLocation = [[CLLocation alloc] initWithLatitude:_userLocation.coordinate.latitude longitude:_userLocation.coordinate.longitude];
        [revGeo reverseGeocodeLocation:clLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (!error && [placemarks count] > 0)
            {
                NSDictionary *dict = [[placemarks objectAtIndex:0] addressDictionary];
//                NSLog(@"street address: %@",[dict objectForKey :@"Street"]);
                NSLog(@"%@",dict);
            }
            else
            {
                NSLog(@"ERROR: %@", error); }

        }];

    }
}

#pragma mark -mapview中点击触发的方法
-(void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate{
    

    
}


-(void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view{

    view.selected = NO;
    
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
    
    if ([view.annotation isKindOfClass:[MAPointAnnotation class]]) {
        
        view.selected = YES;
        
    }
    
    
}


#pragma mark -大头针标注
-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{

    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        
        static NSString *userLocationID = @"locationID";
        MapAnnotationView *annotationView = (MapAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:userLocationID];
        
        if (!annotationView) {
            
            annotationView = [[MapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:userLocationID];
        }
        annotationView.image = imageNameRenderStr(@"mobile-phone22");

        annotationView.centerOffset = CGPointMake(0, -18);

        return  annotationView;
    }

    return nil;
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
        
        
        [self createMapPointAnnotationWithCLLocationCoordinate2D:CLLocationCoordinate2DMake(latitude, longitude) withTitle:_addressStr withSubTitle:nil];
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
    
}

@end
