//
//  UserInfoViewController.h
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/4.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "BasicViewController.h"

@protocol SlideViewDelegate <NSObject>

//关闭抽屉
- (void)leftBtnClick:(UIButton *)btn;

@end

@interface UserInfoViewController : BasicViewController
@property (nonatomic, weak) id<SlideViewDelegate> delegate;

@end
