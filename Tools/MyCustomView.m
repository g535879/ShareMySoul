//
//  MyCustomView.m
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/23.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import "MyCustomView.h"
#import <QuartzCore/QuartzCore.h>
@implementation MyCustomView

+ (UILabel *)createLabelWithFrame:(CGRect)frame
                       textString:(NSString *)text
                         withFont:(float)fontSize
                        textColor:(UIColor *)color {
    
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.text =text;
    label.textColor =color;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont boldSystemFontOfSize:fontSize];
    label.numberOfLines = 0;
    return label;
}


+ (UIButton *)createButtonWithFrame:(CGRect)frame
                             target:(id)target
                                SEL:(SEL)method
                    backgroundImage:(UIImage *)image {
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    
    if (image) {
        [btn setBackgroundImage:image forState:UIControlStateNormal];
    }
    
    [btn addTarget:target action:method forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}


+ (UIButton *)createButtonWithFrame:(CGRect)frame
                             target:(id)target
                                SEL:(SEL)method
                    backgroundImage:(UIImage *)image
                              title:(NSString *)title
                       forwardImage:(UIImage *)forwardImage {
    
    UIButton * btn = [MyCustomView createButtonWithFrame:frame target:target SEL:method backgroundImage:image];
    
    if (forwardImage) {
            [btn setImage:forwardImage forState:UIControlStateNormal];
    }
    
    if (title) {
        
        [btn setTitle:title forState:UIControlStateNormal];
    }
    
    return btn;
}

+ (UIButton *)createButtonWithFrame:(CGRect)frame
                             target:(id)target
                                SEL:(SEL)method
                                tag:(NSInteger)tag
                              title:(NSString *)title
                    backgroundColor:(UIColor *)bgColor {
    
    UIButton *btn = [MyCustomView createButtonWithFrame:frame
                                                 target:target
                                                    SEL:method
                                        backgroundImage:nil
                                                  title:title
                                           forwardImage:nil];
    [btn setBackgroundColor:bgColor];
    btn.tag = tag;
    
    return btn;
    
}
+ (UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset {
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}
@end
