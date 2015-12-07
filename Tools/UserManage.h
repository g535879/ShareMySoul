//
//  UserManage.h
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/7.
//  Copyright © 2015年 gf. All rights reserved.
//  用户相关单例类

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"

@interface UserManage : NSObject

+ (instancetype)defaultUser;

/**
 *  当前用户相关信息
 */
@property (nonatomic, strong) UserInfoModel * currentUser;

@end
