//
//  MyCustomView.h
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/23.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  工厂设计模式
 
    迭代封装
 
    当我们封装的控件不能满足我们
 
    我们需要在之前的基础上 进行一次更深入的封装
 
 */
@interface MyCustomView : NSObject


/**
    生成label
 */
+ (UILabel *)createLabelWithFrame:(CGRect)frame
                       textString:(NSString *)text
                         withFont:(float)fontSize
                        textColor:(UIColor *)color;

/**
 *  生成自定义按钮按钮
 *
 *  @param frame  rect
 *  @param target 接受对象
 *  @param method 方法
 *  @param image  背景图
 *
 *  @return button
 */


+(UIButton *)createButtonWithFrame:(CGRect)frame
                            target:(id)target
                               SEL:(SEL)method
                   backgroundImage:(UIImage *)image;

/**
 *  生成自定义按钮
 *
 *  @param frame  rect
 *  @param target 接受对象
 *  @param method 方法
 *  @param image  背景图
 *  @param title        标题
 *  @param forwardImage 前景图
 *
 *  @return button
 */
+(UIButton *)createButtonWithFrame:(CGRect)frame
                            target:(id)target
                               SEL:(SEL)method
                   backgroundImage:(UIImage *)image
                             title:(NSString *)title
                      forwardImage:(UIImage *)forwardImage;
/**
 *  自定义按钮
 *
 *  @param frame   rect
 *  @param target  接受对象
 *  @param method  方法
 *  @param title   标题
 *  @param tag     tag
 *  @param bgColor 背景色
 *
 *  @return button
 */

+ (UIButton *)createButtonWithFrame:(CGRect)frame
                            target:(id)target
                               SEL:(SEL)method
                                tag:(NSInteger)tag
                             title:(NSString *)title
                   backgroundColor:(UIColor *)bgColor;
@end
