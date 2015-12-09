//
//  UserManage.m
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/7.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "UserManage.h"

@interface UserManage () {
    
}

@end

static UserManage * _manage = nil;

@implementation UserManage

+ (instancetype)defaultUser {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _manage = [[super alloc] init];
    });
    return _manage;
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _manage = [super allocWithZone:zone];
                   
    });
    return _manage;
}

- (NSString *)deviceModel {
    
    if (!_deviceModel) {
        _deviceModel = [UIDevice currentDevice].model;
    }
    return _deviceModel;
}

- (void)setAddressWithDic:(NSDictionary *)dic {
    
    NSString * state = dic[@"State"];
    NSString * Street = dic[@"Street"];
    NSString * SubLocality = dic[@"SubLocality"];
    _address = [NSString stringWithFormat:@"%@%@%@",state,SubLocality,Street];
}
@end
