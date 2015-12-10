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

@protocol MapAnnotationViewDelegate <NSObject>

/**
 *  cllout点击事件
 *
 *  @param model 数据模型
 */
- (void)calloutViewTap:(MessageModel *)model;

@end
@interface MapAnnotationView : MAAnnotationView

@property (nonatomic,strong) MapCalloutView *calloutView;

/**
 *  数据模型
 */
@property (nonatomic,strong) MessageModel * msgModel;

@property (nonatomic,weak) id<MapAnnotationViewDelegate> delegate;
@end
