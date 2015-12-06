//
//  RegisterModel.h
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/6.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "UserInfoModel.h"

@interface RegisterModel : UserInfoModel

/**
 *  用户名
 */
proStr(username);
/**
 *  身份识别码
 */
proStr(openid);
/**
 *  密码
 */
proStr(password);

@end
