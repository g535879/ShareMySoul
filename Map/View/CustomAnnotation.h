//
//  CustomAnnotation.h
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/10.
//  Copyright © 2015年 gf. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface CustomAnnotation : MAPointAnnotation
/**
 *  自定义view
 */
@property (nonatomic,weak)MAAnnotationView * annotationView;
@end
