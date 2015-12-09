//
//  MapAnnotationView.m
//  ShareMySoul
//
//  Created by 伏董 on 15/12/8.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "MapAnnotationView.h"
#define kCalloutWidth 200.0 
#define kCalloutHeight 70.0

@implementation MapAnnotationView

//重写此方法，用来实现点击calloutview判断为点击该annotationview
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    
    BOOL inside = [super pointInside:point withEvent:event];
    if (!inside && self.selected) {
        
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
        
    }

    return inside;
}


- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

//选中时将数据传递给calloutView
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{


    if (selected) {
        
        if (self.calloutView == nil) {
            self.calloutView = [[MapCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.0f + self.calloutOffset.x , -CGRectGetHeight(self.calloutView.bounds) / 2.0f +  self.calloutOffset.y);
        }
        
        CLLocationCoordinate2D location = self.annotation.coordinate;
                
        [BmobHelper messageWithCurrentLocation:location maxDistance:1 withBlock:^(NSArray *responseArray, NSError *error) {
            
            for (MessageModel *model in responseArray) {
                
                if (model.location.latitude == location.latitude && model.location.longitude == location.   longitude) {
                    
                    UserInfoModel *userModel = model.author;
                    
                    self.calloutView.imageurl = [NSURL URLWithString:userModel.head_image];
                    self.calloutView.title = userModel.nickname;
                    self.calloutView.subtitle = model.content;
                    //self.layer.cornerRadius = 10;
                    //self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userModel.head_image]]];
                }
                
            }
            
        }];
        self.image = [UIImage imageNamed:@"mobile-phone22"];
        self.canShowCallout = YES;
        [self addSubview:self.calloutView];
        
    }else{
        
        [self.calloutView removeFromSuperview];
    }

}


@end
