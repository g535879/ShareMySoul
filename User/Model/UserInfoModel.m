//
//  UserInfoModel.m
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/5.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    NSArray * optionArray = @[@"createdAt",@"updatedAt"];
    
    if ([optionArray containsObject:propertyName]) {
        
        return YES;
    }
    return NO;
}

- (NSString *)head_image {
    
    if (!_head_image) {
        
        return default_head_image;
    }
    return _head_image;
}

- (NSString *)nickname {
    
    if (!_nickname) {
        
        _nickname = @"游客";
    }
    return _nickname;
}

@end
