//
//  MapViewController.h
//  ShareMySoul
//
//  Created by 伏董 on 15/12/3.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "BasicViewController.h"

@interface MapViewController : BasicViewController<MAMapViewDelegate,CLLocationManagerDelegate>{
    //地图视图
    MAMapView *_mapView;
    //位置信息
    CLLocationManager *_locationManager;
    
}

- (MAMapView *)createMapViewWithFrame:(CGRect)frame;


@end
