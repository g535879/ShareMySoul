//
//  HomePageTitleView.h
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/1.
//  Copyright © 2015年 gf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageTitleView : UIView
/**
 *  button点击回调block
 */
@property (copy, nonatomic) void (^titleBtnClick)(UIButton * btn);

/**
 *  初始化构造方法
 *
 *  @param frame    frame
 *  @param callBack 回调block
 *
 *  @return self
 */
- (instancetype)initWithFrame:(CGRect)frame andBlock:(void(^)(UIButton *))callBack;
@end
