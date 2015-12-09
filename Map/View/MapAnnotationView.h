//
//  MapAnnotationView.h
//  ShareMySoul
//
//  Created by 伏董 on 15/12/8.
//  Copyright © 2015年 gf. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "MapCalloutView.h"
#import "UserInfoModel.h"
@interface MapAnnotationView : MAAnnotationView


@property (nonatomic,strong) MapCalloutView *calloutView;

/**
 *  数据模型
 */
@property (nonatomic,strong) MessageModel * msgModel;

@end
