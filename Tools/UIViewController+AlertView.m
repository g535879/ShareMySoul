//
//  UIViewController+AlertView.m
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/24.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import "UIViewController+AlertView.h"

@implementation UIViewController (AlertView)

#pragma mark - 显示网络状态弹窗
- (void)showMyAlertView:(NSString *)str {
    __block UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)- 140, ((screen_Height-64-49)/2.0)-20, 280, 40)];
    label.text = str;
    label.backgroundColor = [UIColor blackColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = 2.0f;
    label.layer.masksToBounds = YES;
    label.alpha = 0;
    [self.view addSubview:label];
    
    
    [UIView animateWithDuration:0.5f animations:^{
        
        label.alpha = 1;
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.5 animations:^{
            label.alpha = 0;
            
        }completion:^(BOOL finished) {
            
            [label removeFromSuperview];
            label = nil;
        }];
    }];
}

@end
