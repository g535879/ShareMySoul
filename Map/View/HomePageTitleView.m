//
//  HomePageTitleView.m
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/1.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "HomePageTitleView.h"

/**
 分栏控制器背景button宏定义
 */
#define BACKBTN_WIDTH  100.0f
#define BACKBTN_HETGHT 30.0f

/**
 *  运动方向枚举
 */
typedef NS_ENUM(NSInteger,SWIPDIR){
    /**
     *  向左
     */
    SWIPDIRLEFT = 0,
    /**
     *  向右
     */
    SWIPDIRRIGHT
};

@interface HomePageTitleView (){
    
    //控件宽度
    CGFloat _viewWidth;
}

@property (nonatomic,strong) UIView *moveView;
@property (nonatomic,strong) UIButton *leftButton;
@property (nonatomic,strong) UIButton *rightButton;
@property (nonatomic,strong) UIView *frameView;

@end
@implementation HomePageTitleView

- (instancetype)initWithFrame:(CGRect)frame andBlock:(void (^)(UIButton *))callBack {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _viewWidth = frame.size.width;
        
        [self viewConfig];
        
        self.titleBtnClick = callBack;
    }
    return self;
}

#pragma mark - 初始化布局

- (void)viewConfig {
    
    //创建背景视图
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, 64.0f)];
    backView.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    
    self.frameView = [[UIView alloc] initWithFrame:CGRectMake((_viewWidth - 2*BACKBTN_WIDTH) / 2, 27.0f, BACKBTN_WIDTH*2, BACKBTN_HETGHT)];
    self.frameView .backgroundColor = [UIColor colorWithRed:0.20f green:0.25f blue:0.30f alpha:1.00f];
    self.frameView.layer.cornerRadius = 15;
    [backView addSubview:self.frameView];
    
    //创建移动view
    self.moveView = [[UIView alloc] initWithFrame:CGRectMake(1, 1,BACKBTN_WIDTH, BACKBTN_HETGHT - 2)];
    
    self.moveView.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    self.moveView.layer.cornerRadius = 15;
    [self.frameView  addSubview:self.moveView];
    
    //创建button
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton.frame = CGRectMake(1, 1,BACKBTN_WIDTH, BACKBTN_HETGHT - 2);
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.leftButton setTitle:@"我是主页" forState:UIControlStateNormal];
    self.leftButton.backgroundColor = [UIColor clearColor];
    [self.leftButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.leftButton.tag = 10;
    [self.frameView addSubview:self.leftButton];
    
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.frame = CGRectMake(BACKBTN_WIDTH - 1, 1,BACKBTN_WIDTH, BACKBTN_HETGHT - 2);
    [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightButton setTitle:@"我我的的" forState:UIControlStateNormal];
    self.rightButton.backgroundColor = [UIColor clearColor];
    [self.rightButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.tag = 20;
    [self.frameView addSubview:self.rightButton];
    
    [self addSubview:backView];
}


#pragma mark -点击事件

- (void)buttonClicked:(UIButton *)button{
    
    
    // 延迟
    CGFloat delay = 0.2f;
    
    //同一按钮
    if (self.moveView.frame.origin.x == button.frame.origin.x) {
        return;
    }
    
    //滚动方向
    SWIPDIR dir;
    //另一个按钮
    UIButton * anotherBtn;
    
    //后面的颜色
    UIColor * backwardColor = [UIColor blackColor];
    //前面的颜色
    UIColor * forwardColor;
    
    //另一个button字体后面的颜色
    UIColor * anoBackWardColor = [UIColor whiteColor];
    //另一个button字体前面的颜色
    UIColor * anoForwardColor;
    
    //根据延迟和文字判断文字颜色改变时间
    if (button.tag == 10) { //左侧按钮
        dir = SWIPDIRLEFT;
        anotherBtn = [self viewWithTag:20];
        //特殊处理。需要前景色配合

        forwardColor = [UIColor whiteColor];
        anoForwardColor = [UIColor blackColor];
    }
    else{
        dir = SWIPDIRRIGHT;
        anotherBtn = [self viewWithTag:10];
        
    }
    
    //当前点击按钮变色
    [self calFontColor:button withDelay:delay withDir:dir withTextBackColor:backwardColor forwardColor:forwardColor];

    //另一个按钮变色
    [self calFontColor:anotherBtn withDelay:delay withDir:dir withTextBackColor:anoBackWardColor forwardColor:anoForwardColor];
    
    //移动滑块
    [UIView animateWithDuration:delay animations:^{
        
        self.moveView.frame = CGRectMake(button.frame.origin.x, self.moveView.frame.origin.y, self.moveView.frame.size.width, self.moveView.frame.size.height);

        
    } completion:^(BOOL finished) {
        
        if (self.titleBtnClick) {
            
            self.titleBtnClick(button);
        }
       
    }];

}

//根据延迟和字体属性相关判断调用改变字体颜色
- (void)calFontColor:(UIButton *)btn withDelay:(CGFloat )delay withDir:(SWIPDIR)dir withTextBackColor:(UIColor *)backColor forwardColor:(UIColor *)forwardColor {
    
    //属性字体
    NSMutableAttributedString * strTitle = [[NSMutableAttributedString alloc] initWithString:btn.currentTitle];
    
    NSInteger titleCount = strTitle.length;
    
    //字体总大小
    CGSize  fontSize = [btn.currentTitle sizeWithAttributes:@{NSFontAttributeName:btn.titleLabel.font}];
    
    //单个字体宽度
    CGFloat singleFontSize = fontSize.width / titleCount * 1.0;
    
    //文字距离button最左侧的距离
    CGFloat paddingFont = (btn.frame.size.width - fontSize.width ) / 2.0;
    
    //获取控件运动速度(s/像素)
    CGFloat speend = delay / btn.frame.size.width;
    
    //获取开始运动的时间
    CGFloat startTime = speend * paddingFont;
    
    //根据文字多少和大小来判断何时改变颜色
    
    for (int i = 0; i < strTitle.length; i++) {
        
        
        //延迟调用
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (startTime + speend * singleFontSize * i) * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            
            NSInteger currentIdx = i;
            NSMutableAttributedString * currentStrTitle = [strTitle mutableCopy]; //关键

            
            NSInteger fromIdx; //从第几个字开始滑动
            if (dir == SWIPDIRLEFT) { //向左滑动
             
                fromIdx = strTitle.length - 1 - i;
                
                currentIdx = strTitle.length - fromIdx - 1;
                
                //往左滑动修改滑块左侧的颜色
                [currentStrTitle addAttribute:NSForegroundColorAttributeName value:forwardColor range:NSMakeRange(0, fromIdx)];
            }
            else{
                fromIdx = 0;
            }
            [currentStrTitle addAttribute:NSForegroundColorAttributeName value:backColor range:NSMakeRange(fromIdx, currentIdx+1)];
            [btn setAttributedTitle:currentStrTitle forState:UIControlStateNormal];
        });
    }
}

@end
