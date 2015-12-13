//
//  MapAnnotationView.m
//  ShareMySoul
//
//  Created by 伏董 on 15/12/8.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "MapAnnotationView.h"
#define kCalloutWidth 60
#define kCalloutHeight 60

@interface MapAnnotationView ()

/**
 *  气泡选中状态
 */
@property (nonatomic,assign) BOOL calloutViewSelected;

/**
 *  气泡
 */
@property (nonatomic,strong) UIButton *calloutView;

@end
@implementation MapAnnotationView


- (instancetype)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
//        self.calloutView = [[MapCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
//        self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.0f + self.calloutOffset.x , -CGRectGetHeight(self.calloutView.bounds) / 2.0f +  self.calloutOffset.y);
//        [self addSubview:self.calloutView];
//        self.calloutView.hidden = YES;
        
        self.calloutView = [UIButton buttonWithType:UIButtonTypeCustom];
        self.calloutView.frame = CGRectMake(40, -45, kCalloutWidth, kCalloutHeight);
        [self.calloutView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.calloutView setBackgroundImage:[UIImage imageNamed:@"white_chatBuble"] forState:UIControlStateNormal];
//        self.calloutView.hidden = YES;
        
        [self addSubview:self.calloutView];
    }
    
    return self;
}


- (void)toggleCallout {
    


    if (!self.calloutViewSelected) {
        [self showCallout];
    }
    
    self.calloutView.hidden = self.calloutViewSelected;
    self.calloutViewSelected = !self.calloutViewSelected;
    
    
    
}

- (void)setMsgModel:(MessageModel *)msgModel {
    _msgModel = msgModel;
    [self.calloutView setTitle:self.msgModel.content forState:UIControlStateNormal];
}
- (void)showCallout {
    
    if (self.msgModel) {
        
        //self.calloutView.title = self.msgModel.author.nickname;
       // self.calloutView.subtitle = self.msgModel.content;
        
    }

}

//关闭气泡
- (void)hiddenCallout {
    
    self.calloutView.hidden = YES;
    self.calloutViewSelected = NO;
}
@end
