//
//  MapViewController.m
//  ShareMySoul
//
//  Created by 伏董 on 15/12/3.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "MapViewController.h"
#import "MessageModel.h"

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
    //天空模式
    _mapView.skyModelEnable = NO;
    

    [self createMeButton];
    //[self createTrafficButton];
    
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
    }
    
    
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
- (void)createMapPointAnnotationWithCLLocationCoordinate2D:(CLLocationCoordinate2D)coordinate2D withTitle:(NSString *)title withSubTitle:(NSString *)subtitle{
    
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    
    annotation.coordinate = coordinate2D;
    
    annotation.title = title;
    
    annotation.subtitle = subtitle;
    
    [_mapView addAnnotation:annotation];
    
}

#pragma mark

#pragma mark -mapview中结束定位之后的当前位置信息
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    
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
    
//    MessageModel * message = [[MessageModel alloc] init];
//    message.author = [UserManage defaultUser].currentUser;
//    message.device = [UserManage defaultUser].deviceModel;
//    message.content = @"测试心情发送！～～～～～～～～～～～～～～";
//    message.pics = [@[@"abc",@"def"] mutableCopy];
//    [message setGeoPoint:coordinate];  //地理位置
//    
////    保存导数据
//    [BmobHelper sendMessageWithMessageModel:message withBlock:^(BOOL isSuccess, NSError *error) {
//        
//        if (isSuccess) {
//            
//            NSLog(@"状态发送成功");
//        }
//        else{
//            NSLog(@"%@",error);
//        }
//    }];

    
//    //获取数%@据
    [BmobHelper messageWithCurrentLocation:coordinate maxDistance:1.0f withBlock:^(NSArray *responseArray, NSError *error) {
        
        if (error) {
            NSLog(@"%@",error);
        }
        else{
            //messageModel数据
            NSLog(@"获取数据完成");
//            NSLog(@"%@",responseArray);
        }
    }];
    
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
        annotationView.image = imageNameRenderStr(@"mobile-phone22");
        annotationView.canShowCallout = YES;
        //annotationView.pinColor = MAPinAnnotationColorPurple;
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
