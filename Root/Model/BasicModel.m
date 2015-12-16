//
//  BasicModel.m
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/3.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "BasicModel.h"

@implementation BasicModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (id)valueForKey:(NSString *)key {
    
    id value = [super valueForKey:key];
    if ([value isKindOfClass:[NSNull class]] ) {
        return nil;
    }
    return value;
}

@end
