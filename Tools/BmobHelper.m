//
//  BmobHelper.m
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/2.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "BmobHelper.h"

static BmobHelper * _singleton;

@implementation BmobHelper

+ (instancetype)sharedInstance {
    
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        _singleton = [[super alloc] init];
    });
    
    return _singleton;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        _singleton = [super allocWithZone:zone];
    });
    
    return _singleton;
}
@end
