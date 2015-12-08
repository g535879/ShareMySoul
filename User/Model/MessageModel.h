//
//  MessageModel.h
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/3.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "BasicModel.h"
#import "UserInfoModel.h"
#import "CommentModel.h"

@interface MessageModel : BasicModel

/**
 *  消息作者
 */
@property (nonatomic, strong) UserInfoModel * author;
/**
 *  评论
 */
@property (nonatomic, strong) CommentModel * comment;
/**
 *  坐标
 */
@property (nonatomic, strong) BmobGeoPoint * point;

/**
 *  消息内容
 */
proStr(content);

/**
 *  消息图片
 */
proMuArr(pics);

/**
 *  设备
 */
proStr(device);
@end
