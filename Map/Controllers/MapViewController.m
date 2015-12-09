//
//  MapViewController.m
//  ShareMySoul
//
//  Created by 伏董 on 15/12/3.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "MapViewController.h"
@interface MapViewController (){
    
    UIView * _bgView;
    //大头针数组
    NSMutableArray * _annotationArray;
}

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
    
    _bgView = [[UIView alloc] init];
}

#pragma mark -创建地图视图
- (MAMapView *)createMapViewWithFrame:(CGRect)frame{
    
    _mapView = [[MAMapView alloc] initWithFrame:frame];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    //缩放级别
    [_mapView setZoomLevel:17.5 animated:YES];
    _mapView.showsBuildings = NO;
    _mapView.showsIndoorMap = NO;
    _mapView.rotateEnabled = NO;
    _mapView.skyModelEnable = NO;
    

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
        
//        
       
    }
    
}



#pragma mark -创建地图大头针标注
- (void)createMapPointAnnotationWithCLLocationCoordinate2D:(CLLocationCoordinate2D)coordinate2D {
    
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    
    annotation.coordinate = coordinate2D;
    
    [_mapView addAnnotation:annotation];

}

#pragma mark

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    
    if (updatingLocation) {
        _userLocation = [userLocation.location copy];
        _mapView.userTrackingMode = MAUserTrackingModeNone;
    }
}

#pragma mark - 地图区域加载完成
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {


    //获取当前区域消息列表
    [BmobHelper messageWithCurrentLocation:_mapView.region withBlock:^(NSArray *responseArray, NSError *error) {
        if (responseArray) {
    
            //更新当前区域消息列表
            [self configAnnotationArray:responseArray];
        }
        else{
            NSLog(@"%@",error);
        }
    }];

    
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
        annotationView.msgModel = [self modelBylocation:annotation.coordinate];
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
    

    
//    for (AMapGeocode *code in response.geocodes) {
    
//        CLLocationDegrees longitude = code.location.longitude;
//        CLLocationDegrees latitude = code.location.latitude;
        
        
//        [self createMapPointAnnotationWithCLLocationCoordinate2D:CLLocationCoordinate2DMake(latitude, longitude) withTitle:_addressStr withSubTitle:nil];
//    }

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

//根据当前地理区域更新数组
- (void)configAnnotationArray:(NSArray<MessageModel *> *)array {
    
    if (!_annotationArray) {
        _annotationArray = [@[] mutableCopy];
    }
    
    NSMutableArray * updateArray = [@[] mutableCopy];
    
    //遍历当前已存在数组，加入新的点
    for (MessageModel * m in array) {
        
        BOOL isFind = NO;
        
        for (MessageModel *mm in _annotationArray) {
            //找到相同的元素
            if (mm.location.latitude == m.location.latitude && mm.location.longitude == m.location.longitude) {
                isFind = YES;
                break;
            }
        }
        //新的点。加入到数组，绘制到地图
        if (!isFind) {
            
            [updateArray addObject:m];
            [_annotationArray addObject:m];
        }
    }

    
    //创建大头针
    for (MessageModel * model in updateArray) {
        
        if (model.pics.count > 2) {
            NSLog(@"%@",model.pics);
        }
        [self createMapPointAnnotationWithCLLocationCoordinate2D:CLLocationCoordinate2DMake(model.location.latitude, model.location.longitude)];

    }
    
}


//根据坐标获取message模型
- (MessageModel *)modelBylocation:(CLLocationCoordinate2D )point {
    
    for (MessageModel * m in _annotationArray) {
        if (m.location.latitude == point.latitude && m.location.longitude == point.longitude) {
            return m;
        }
    }
    return nil;
}

@end
