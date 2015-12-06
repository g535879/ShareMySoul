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

- (NSString *)figureurl_qq_2 {
    
    if (!_figureurl_qq_2) {
        return default_head_image;
    }
    return _figureurl_qq_2;
}
@end
