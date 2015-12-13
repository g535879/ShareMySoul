//
//  MapViewController.m
//  ShareMySoul
//
//  Created by 伏董 on 15/12/3.
//  Copyright © 2015年 gf. All rights reserved.
//
#import "ShowPicsViewController.h"
#import "CustomAnnotation.h"
#import "MapViewController.h"
#import "CommentView.h"
@interface MapViewController ()<commentDelegate>{
    
    //大头针数组
    NSMutableArray * _annotationArray;
    //图片数据源
    NSMutableArray * _picsArray;
    //图片展示类
    ShowPicsViewController * _svc;
    //保存当前点击的view
    MapAnnotationView * _currentClickView;
    
    //底部消息发送view
    CommentView * _commentView;
    
    //键盘是否弹起
    BOOL isKeyBoardUp;
    
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
    
    //图片展示view
    _svc = [ShowPicsViewController new];
    [self.view addSubview:_svc.view];
    _svc.view.hidden = YES;
    [self addChildViewController:_svc];
    
    //监听键盘变化
    //监听键盘弹起事件
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardUp:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //监听键盘回收事件
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardDown:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
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
    _mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
    [self createMeButton];
    
    
    //消息发送按钮
    _commentView = [[CommentView alloc] initWithFrame:CGRectMake(0, screen_Height - 49 - 64, screen_Width, 49)];
    _commentView.delegate = self;
    [_mapView addSubview:_commentView];
    return _mapView;
}


#pragma mark -创建定位到当前的位置按钮
- (void)createMeButton{
    

    _meButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _meButton.frame = CGRectMake(_mapView.frame.size.width - 40 * scale_screen -20 , _mapView.logoCenter.y - _mapView.compassSize.height - (_mapView.logoSize.height / 2) - 49, _mapView.compassSize.width, _mapView.compassSize.height);

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


#pragma mark - 自定义用户圈圈
-(MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay {
    
    // 自定义定位精度对应的MACircleView
    if (overlay == mapView.userLocationAccuracyCircle)
    {
        MACircleView *accuracyCircleView = [[MACircleView alloc] initWithCircle:(MACircle *)overlay];
        
        accuracyCircleView.lineWidth    = 2.f;
        accuracyCircleView.strokeColor  = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.0];
        accuracyCircleView.fillColor    = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.0];
        return accuracyCircleView;
    }
    return nil;
}

#pragma mark -创建地图大头针标注
- (void)createMapPointAnnotationWithCLLocationCoordinate2D:(CLLocationCoordinate2D)coordinate2D {
    
    CustomAnnotation * annotation = [[CustomAnnotation alloc] init];
    
    annotation.coordinate = coordinate2D;
    
    
    [_mapView addAnnotation:annotation];

}

#pragma mark

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    
    if (updatingLocation) {
        _userLocation = [userLocation.location copy];
        [UserManage defaultUser].coordinate = _userLocation.coordinate;
        _mapView.userTrackingMode = MAUserTrackingModeNone;
    }
}

#pragma mark - 点击地图
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    //回收键盘
    [self.view endEditing:YES];
//    [self sendMsg:@"哈哈哈测试"];
//    [UserManage defaultUser].coordinate = coordinate;
}

#pragma mark - 地图区域加载完成
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {


    //获取当前区域消息列表
    [self newMesInfo];

    
}

#pragma mark - 标注取消点击
-(void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view{


    if ([view.annotation isKindOfClass:[CustomAnnotation class]]) {
        
        MapAnnotationView * anView = (MapAnnotationView *)view;
//        [anView toggleCallout];
        

    }
    
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
    
    if ([view.annotation isKindOfClass:[CustomAnnotation class]]) {
        
        MapAnnotationView * anView = (MapAnnotationView *)view;
        //保存状态
        _currentClickView = anView;
        
        //弹出图片滚动视图
        [self calloutViewTap];
        
      //  [anView toggleCallout];
        
//        //关闭其他气泡
//        for (id ann in _mapView.annotations) {
//            
//            if ([ann isKindOfClass:[CustomAnnotation class]]) {
//                
//                MapAnnotationView * mav = (MapAnnotationView *)[(CustomAnnotation *)ann annotationView];
//                
//                if (mav.calloutViewSelected && mav != view) {
//                    //关闭气泡
////                    [mav hiddenCallout];
//                }
//            }
//            
//        }
        
    }
    
    
}


#pragma mark -大头针标注
-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{

    if ([annotation isKindOfClass:[CustomAnnotation class]]) {
        
        static NSString *userLocationID = @"locationID";
        MapAnnotationView *annotationView = (MapAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:userLocationID];
        
        if (!annotationView) {
            
            annotationView = [[MapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:userLocationID];
        }
        CustomAnnotation * customAnnotation = (CustomAnnotation *)annotation;
        customAnnotation.annotationView = annotationView;
        
//        annotationView.image = imageNameRenderStr(@"mobile-phone22");
        annotationView.msgModel = [self modelBylocation:annotation.coordinate];

        [NetManager loadImageWithUrl:[NSURL URLWithString:annotationView.msgModel.author.head_image] clearCache:NO block:^(UIImage *image, NSError *error) {
            annotationView.image = [MyCustomView circleImage:image withParam:20];
        }];
                
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
    
}

#pragma mark - 气泡点击事件
- (void)calloutViewTap{

    //加载数据
    
    [BmobHelper messageWithCurrentLocation:[UserManage defaultUser].coordinate maxDistance:10 withBlock:^(NSArray *responseArray, NSError *error) {
        if (responseArray) {
            [_svc.picsArray removeAllObjects];
            for (MessageModel * model in responseArray) {
                if ([model.pic isKindOfClass:[NSString class]]) {
                    [_svc.picsArray addObject:model.pic];
                }
            }
            
            if (_svc.picsArray.count) {
                //显示图片展示view
                [self.view bringSubviewToFront:_svc.view];
                [_svc reloadData];
                _svc.view.hidden = NO;
            }
            
        }
        else{
            NSLog(@"%@",error);
        }
    }];

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
    
    //删除其他点
    [_mapView removeAnnotations:_mapView.annotations];

    

    for (MessageModel * m in array) {
        
        BOOL isExist = NO;
        
        for (MessageModel * mm in updateArray) {
            //点存在
            if ([self isExist:m m2:mm]) {
                isExist = YES;
                break;
            }
        }
        if (!isExist) {
            [updateArray addObject:m];
        }
        
    }
    
    //保存当前数据源
    _annotationArray = updateArray;
    
    //创建大头针
    for (MessageModel * model in updateArray) {
        
        if (model.pic) {
            //图片数组赋值
            [_picsArray addObject:model.pic];
        }
        [self createMapPointAnnotationWithCLLocationCoordinate2D:CLLocationCoordinate2DMake(model.location.latitude, model.location.longitude)];

    }
    
}

#pragma mark - 发送消息按钮点击代理事件
- (void)commonClick:(NSString *)msgStr {
    [self.view endEditing:YES];
    [self sendMsg:msgStr];
}

#pragma mark -  发送消息
- (void)sendMsg:(NSString *)msgStr {
    
    //当前用户
    UserManage * manager = [UserManage defaultUser];
    
    //获取反地理编码
    CLLocation * clLocation = [[CLLocation alloc] initWithLatitude:_userLocation.coordinate.latitude longitude:_userLocation.coordinate.longitude];
    CLGeocoder * revGeo = [[CLGeocoder alloc] init];
    [revGeo reverseGeocodeLocation:clLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {

        if (!error && [placemarks count] > 0)
        {
            NSDictionary *dict = [[placemarks objectAtIndex:0] addressDictionary];
            [manager setAddressWithDic:dict];
            MessageModel * sendMsg = [[MessageModel alloc] init];
            sendMsg.author = manager.currentUser;
            sendMsg.device = manager.deviceModel;
            sendMsg.currentAddress = manager.currentAddress;
            [sendMsg setGeoPoint:manager.coordinate];
            sendMsg.content = msgStr;
            //加载框
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //发送消息
            [BmobHelper sendMessageWithMessageModel:sendMsg withBlock:^(BOOL isSuccess, NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (error) {
                    NSLog(@"%@",error);
                }
                else{
                    //获取当前区域消息列表
                    [self newMesInfo];
                }
            }];
        }
        else
        {
            NSLog(@"ERROR: %@", error);
        }
    
    }];
}

#pragma mark - 键盘事件


//键盘弹起
- (void)keyBoardUp:(NSNotification *)notification {

    if (isKeyBoardUp) {
        return;
    }
    isKeyBoardUp = YES;
    CGFloat offsetY = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    CGRect commentViewFrame = _commentView.frame;
    commentViewFrame.origin.y -= offsetY;
    _commentView.frame = commentViewFrame;
}

//键盘回收
- (void)keyBoardDown:(NSNotification *)notiificaiton {
    
    if (!isKeyBoardUp) {
        return;
    }
    isKeyBoardUp = NO;
    
    CGFloat offsetY = [[notiificaiton.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    CGRect commentViewFrame = _commentView.frame;
    commentViewFrame.origin.y += offsetY;
    _commentView.frame = commentViewFrame;
}


#pragma mark -  获取当前消息列表
- (void)newMesInfo {
    
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

#pragma mark - 判断点是否重复
- (BOOL)isExist:(MessageModel *)m1 m2:(MessageModel *)m2 {
    
    float ala = [[NSString stringWithFormat:@"%.3f",m1.location.latitude] floatValue];
    float mla = [[NSString stringWithFormat:@"%.3f",m2.location.latitude] floatValue];
    float along = [[NSString stringWithFormat:@"%.3f",m1.location.longitude] floatValue];
    float mlong = [[NSString stringWithFormat:@"%.3f",m2.location.longitude] floatValue];
    
    //重复的点
    if (ala == mla && along == mlong && m1 != m2) {
        return YES;
    }
    return NO;

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
