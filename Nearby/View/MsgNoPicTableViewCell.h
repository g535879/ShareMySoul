//
//  MsgNoPicTableViewCell.h
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/11.
//  Copyright © 2015年 gf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsgNoPicTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateLabel;


//赋值
- (void)setModel:(MessageModel *)model;
//单元格高度
- (CGFloat)heightOfCell;

@end
