//
//  MapViewController.h
//  ShareMySoul
//
//  Created by 伏董 on 15/12/3.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "BasicViewController.h"




@interface MapViewController : BasicViewController<MAMapViewDelegate,AMapSearchDelegate,AMapLocationManagerDelegate>{
    //地图视图
    MAMapView *_mapView;
    //位置信息
    CLLocation *_userLocation;
    //地图搜素
    AMapSearchAPI *_search;
}

@property (nonatomic,strong) UIButton *meButton;

@property (nonatomic,strong) UIButton *trafficButton;

/**
 *  创建地图
 *
 *  @param frame frame
 *
 *  @return
 */
- (MAMapView *)createMapViewWithFrame:(CGRect)frame;



/**
 *  创建交通路况按钮
 *
 *  
 *
 *  @return
 */
- (void)createTrafficButton;


/**
 *  创建定位到当前位置按钮
 */
- (void)createMeButton;


/**
 *  正向地理编码
 *
 *  @param address 地点名称
 */
- (void)geoCodeWithAddress:(NSString *)address;



/**
 *  逆向地理编码
 *
 *  @param latitude  纬度
 *  @param longitude 经度
 */
- (void)ReGeocodeWithWithLatitude:(CLLocationDegrees)latitude withLongitude:(CLLocationDegrees)longitude;

/**
 *  创建大头针标注
 *
 *  @param latitude  latitude description
 *  @param longitude longitude description
 *  @param title     title
 *  @param subtitle  subtitle
 */
- (void)createMapPointAnnotationWithLatitude:(CLLocationDegrees)latitude withLongitude:(CLLocationDegrees)longitude withTitle:(NSString *)title withSubTitle:(NSString *)subtitle;


@end
