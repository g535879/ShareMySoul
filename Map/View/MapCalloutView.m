//
//  MapCalloutView.m
//  ShareMySoul
//
//  Created by 伏董 on 15/12/8.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "MapCalloutView.h"

#define kArrorHeight 10

#define kPortraitMargin 5 
#define kPortraitWidth 70 
#define kPortraitHeight 50
#define kTitleWidth 120 
#define kTitleHeight 20

@interface MapCalloutView()


@property (nonatomic,strong) UIImageView *portraitView;

@property (nonatomic,strong) UILabel *subtitleLabel;

@property (nonatomic,strong) UILabel *titleLabel;

@end



@implementation MapCalloutView


- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self initSubViews];
    }

    return self;
}


- (void)initSubViews{
    
    self.portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(kPortraitMargin, kPortraitMargin, kPortraitWidth, kPortraitHeight)];
    self.portraitView.backgroundColor = [UIColor blackColor];
   // [self addSubview:self.portraitView];
    
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPortraitMargin*2 + kPortraitWidth, kPortraitMargin, kTitleWidth, kTitleHeight)];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.titleLabel.textColor = [UIColor whiteColor];

    [self addSubview:self.titleLabel];

    self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPortraitMargin * 2 + kPortraitWidth, kPortraitMargin * 2 + kTitleHeight, kTitleWidth, kTitleHeight)];
    self.subtitleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    self.subtitleLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:self.subtitleLabel];
}


- (void)setTitle:(NSString *)title{

    self.titleLabel.text = title;
}

- (void)setSubtitle:(NSString *)subtitle{

    self.subtitleLabel.text = subtitle;
}

- (void)setImageurl:(NSURL *)imageurl{

    [self.portraitView sd_setImageWithURL:imageurl];

}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 1.0f;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
}

- (void)drawInContext:(CGContextRef)context{
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.8].CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
}


- (void)getDrawPath:(CGContextRef)context{

    CGRect rrect = self.bounds;
    CGFloat redius = 6.0f;
    CGFloat minx = CGRectGetMinX(rrect);
    
    CGFloat midx = CGRectGetMidX(rrect);
    CGFloat maxx = CGRectGetMaxX(rrect);
    
    CGFloat miny = CGRectGetMinY(rrect);
    CGFloat maxy = CGRectGetMaxY(rrect) - kArrorHeight;
    
    CGContextMoveToPoint(context, midx + kArrorHeight, maxy);
    CGContextAddLineToPoint(context, midx, maxy + kArrorHeight);
    CGContextAddLineToPoint(context, midx - kArrorHeight, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, redius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, redius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, redius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, redius);
    CGContextClosePath(context);
}



@end
