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

/**
 *  数据模型
 */
@property (nonatomic,strong) MessageModel * msgModel;
/**
 *  气泡选中状态
 */
@property (nonatomic,assign,readonly) BOOL calloutViewSelected;

/**
 *  显示或者隐藏气泡
 */
- (void)toggleCallout;

/**
 *  关闭气泡
 */
- (void)hiddenCallout;
@end
