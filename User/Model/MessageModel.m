//
//  MessageModel.m
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/3.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel


- (void)setGeoPoint:(CLLocationCoordinate2D )geoLocation {
    
    if (!self.location) {
        self.location = [[BmobGeoPoint alloc] init];
    }
    
    self.location.latitude = geoLocation.latitude;
    self.location.longitude = geoLocation.longitude;
}

+ (BOOL)propertyIsIgnored:(NSString *)propertyName {
    
    NSArray * optionArray = @[@"author",@"location",@"comments"];
    
    if ([optionArray containsObject:propertyName]) {
        return YES;
    }
    return NO;
}

//- (NSString *)currentAddress {
//    
//    if ([_currentAddress isKindOfClass:[NSNull class]]) {
//        return nil;
//    }
//    return _currentAddress;
//}

- (id)valueForKey:(NSString *)key {
    return [super valueForKey:key];
}


@end
