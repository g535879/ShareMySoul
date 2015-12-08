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

    [super setSelected:self animated:animated];

    if (self.selected == selected) {
        return;
    }

    if (selected) {
        
        if (self.calloutView == nil) {
            self.calloutView = [[MapCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.0f + self.calloutOffset.x , -CGRectGetHeight(self.calloutView.bounds) / 2.0f +  self.calloutOffset.y);
        }
        
        CLLocationCoordinate2D location = self.annotation.coordinate;
        
        self.calloutView.title = [NSString stringWithFormat:@"%f, %f",location.latitude,location.longitude];
        self.canShowCallout = YES;
        [self addSubview:self.calloutView];
        
    }else{
                [self.calloutView removeFromSuperview];
    }

}


@end
