//
//  FriendTableViewCell.m
//  ShareMySoul
//
//  Created by 古玉彬 on 16/2/2.
//  Copyright © 2016年 gf. All rights reserved.
//

#import "FriendTableViewCell.h"

@interface FriendTableViewCell ()
/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

/**
 *  用户名
 */
@property (weak, nonatomic) IBOutlet UILabel *userName;
@end
@implementation FriendTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(UserInfoModel *)model {
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:[UIImage imageNamed:@"default_head_image"]];
    self.userName.text = model.nickname;
}

@end
