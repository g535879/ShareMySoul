//
//  MapViewController.h
//  ShareMySoul
//
//  Created by 伏董 on 15/12/3.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "BasicViewController.h"
#import "MapAnnotationView.h"



@interface MapViewController : BasicViewController<MAMapViewDelegate,AMapSearchDelegate,CLLocationManagerDelegate>{
    //地图视图
    MAMapView *_mapView;
    //当前位置信息
    CLLocation *_userLocation;
    //地图搜素
    AMapSearchAPI *_search;    
}

@property (nonatomic,strong) UIButton *meButton;


/**
 *  创建地图
 *
 *  @param frame frame
 *
 *  @return
 */
- (MAMapView *)createMapViewWithFrame:(CGRect)frame;



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
 *  @param coordinate coordinate description
 */
//- (void)ReGeocodeWithWithLatitude:(CLLocationCoordinate2D)coordinate;


/**
 *  创建大头针标注
 *
 *  @param coordinate2D coordinate2D description
 */
- (void)createMapPointAnnotationWithCLLocationCoordinate2D:(CLLocationCoordinate2D)coordinate2D;



@end
