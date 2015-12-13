//
//  MsgNoPicTableViewCell.m
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/11.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "MsgNoPicTableViewCell.h"

@implementation MsgNoPicTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MessageModel *)model {
    
    [self.headImageView setImage:nil];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.author.head_image] placeholderImage:imageStar(default_head_image)];
    self.nickNameLabel.text = model.author.nickname;
    self.locationLabel.text = model.currentAddress;
    self.content.text = model.content;
    self.updateLabel.text = (NSString *)model.updatedAt;
}


- (CGFloat)heightOfCell {
    
    CGSize textSize = [self.content.text boundingRectWithSize:CGSizeMake(self.frame.size.width-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} context:nil].size;
    
   
        return textSize.height + 150;
    
}

@end
