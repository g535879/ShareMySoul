//
//  ShowPicsViewController.h
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/9.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "BasicViewController.h"

@interface ShowPicsViewController : BasicViewController
/**
 *  图片url数据源
 */
@property (nonatomic,copy) NSArray * picsArray;

/**
 *  背景图片
 */
@property (nonatomic, strong) UIImage * bgImage;
@end
