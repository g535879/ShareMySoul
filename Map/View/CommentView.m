//
//  CommentView.m
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/30.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import "CommentView.h"

#define SPACE 10 * scale_screen

@interface CommentView()<UITextFieldDelegate>{
    UITextField * _textField;
}

@end
@implementation CommentView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self viewConfig];
    }
    
    return self;
}

#pragma mark - viewConfig

- (void)viewConfig {
    
    [self setBackgroundColor:[UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f]];
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(SPACE, SPACE, self.bounds.size.width - 90, self.frame.size.height - 20)];
    _textField.delegate = self;
    _textField.placeholder = @"跟附近人打个招呼把吧...";
    _textField.layer.cornerRadius = 5;
    [_textField setBackgroundColor:[UIColor whiteColor]];
    [_textField setFont:[UIFont systemFontOfSize:13.0f * scale_screen]];
    [_textField setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:_textField];
    
    UIButton * cbtn = [MyCustomView createButtonWithFrame:CGRectMake(CGRectGetMaxX(_textField.frame) + SPACE, _textField.frame.origin.y, 60, _textField.frame.size.height) target:self SEL:@selector(commentBtnClick:) backgroundImage:nil];
    [cbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cbtn setBackgroundColor:[UIColor blueColor]];
    cbtn.layer.cornerRadius = 5;
    cbtn.layer.borderWidth = 1;
    [cbtn setTitle:@"发送" forState:UIControlStateNormal];
    cbtn.layer.borderColor = [UIColor blackColor].CGColor;
    cbtn.layer.masksToBounds = YES;
    
    [self addSubview:cbtn];
}

#pragma mark - btn click events
- (void)commentBtnClick:(UIButton *)btn {
    
    
    if (_textField.text.length) {
        
        if ([self.delegate respondsToSelector:@selector(commonClick:)]) {
            [self.delegate commonClick:_textField.text];
            
            _textField.text = @"";
        }
    }
    
}

#pragma mark - textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
