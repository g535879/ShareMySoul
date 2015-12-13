//
//  MsgMoreInfoTableViewCell.h
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/11.
//  Copyright © 2015年 gf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsgMoreInfoTableViewCell : UITableViewCell
/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
/**
 *  昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *nickName;
/**
 *  分享照片
 */
@property (weak, nonatomic) IBOutlet UIImageView *shareImage;
/**
 *  消息内容
 */
@property (weak, nonatomic) IBOutlet UILabel *content;
/**
 *  位置
 */
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
/**
 *  更新时间
 */
@property (weak, nonatomic) IBOutlet UILabel *updateTimeLabel;

//赋值
- (void)setModel:(MessageModel *)model;
//单元格高度
- (CGFloat)heightOfCell;
@end
