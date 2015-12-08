//
//  CommentModel.h
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/8.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "BasicModel.h"
#import "MessageModel.h"
#import "UserInfoModel.h"

@interface CommentModel : BasicModel
/**
 *  评论人
 */
@property (nonatomic, strong) UserInfoModel * author;
/**
 *  评论的消息对象
 */
@property (nonatomic, strong) MessageModel * message;

/**
 *  评论的消息内容
 */
proStr(content);
@end
