//
//  SlideViewController.h
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/4.
//  Copyright © 2015年 gf. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SlideViewController : UIViewController
/**
 *  抽屉构造方法
 *  @param frame             frame
 *  @param leftVC            左侧视图控制器
 *  @param mainVC            右侧视图控制器
 *
 *  @return self
 */
- (instancetype)initWithFrame:(CGRect) frame LeftVC:(UIViewController *)leftVC andMainVC:(UIViewController *)mainVC;


@end
