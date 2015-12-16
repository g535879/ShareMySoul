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
 *  数据源
 */
@property (nonatomic,copy) NSMutableArray * msgModelArr;

//刷新数据
- (void)reloadData;
@end
