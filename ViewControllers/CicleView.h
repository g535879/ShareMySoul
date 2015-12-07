//
//  CicleView.h
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/6.
//  Copyright © 2015年 gf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CicleView : UIView

/**
 *  根据图层阴影色和图片返回图层
 *
 *  @param frame       frame
 *  @param shadowColor 阴影颜色
 *  @param borderColor 边框颜色
 *  @param bgImage       背景图片
 *
 *  @return 图片
 */
- (instancetype)initWithFrame:(CGRect)frame
             withShadownColor:(UIColor *)shadowColor
              withBorderColor:(UIColor *)borderColor
                     andImage:(UIImage *)bgImage;
@end
