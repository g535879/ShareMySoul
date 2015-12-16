//
//  SendMsgViewController.m
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/14.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "SendMsgViewController.h"


@interface SendMsgViewController ()<UITextViewDelegate> {
    //取消按钮
    UIButton * _cancelBtn;
    //发送按钮
    UIButton * _sendBtn;
    //文本框
    UITextView * _editTextView;
    
    //背景滚动视图
    UIScrollView * _bgScrollView;
    
    //图片视图
    UIImageView * _shareImageView;
    
    //底部位置视图
    UIView * _locationView;
    
    //位置标签
    UILabel * _locationLabel;
    
    //键盘是否抬起
    BOOL isKeyBoardUp;
}

@end
@implementation SendMsgViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //顶部视图
    [self createTitleView];
    
    
    //获取地理位置
    [self getLocation];
    //监听键盘变化
    //监听键盘弹起事件
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardUp:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //监听键盘回收事件
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardDown:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    
}

- (void)createTitleView {
    
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, screen_Width, screen_Height - 64)];
    _bgScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_bgScrollView];
    _bgScrollView.contentSize = CGSizeMake(screen_Width, screen_Height-60);
    
    UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_Width, 64)];
    [titleView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:titleView];
    
    //取消按钮
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cancelBtn sizeToFit];
    _cancelBtn.tag = 100 + 0;
    [_cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    CGRect rect = _cancelBtn.frame;
    rect.origin.x = 7.5;
    rect.origin.y = 64 - rect.size.height - 5;
    _cancelBtn.frame = rect;
    [titleView addSubview:_cancelBtn];
    
    //发布按钮
    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendBtn setTitle:@"发布" forState:UIControlStateNormal];
    [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sendBtn sizeToFit];
    [_sendBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    _sendBtn.enabled = NO;
    CGRect sendRect = _sendBtn.frame;
    sendRect.origin.x = screen_Width - sendRect.size.width - 7.5;
    sendRect.origin.y = _cancelBtn.frame.origin.y;
    _sendBtn.frame = sendRect;
    _sendBtn.tag = 100 + 1;
    [_sendBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:_sendBtn];
    
    //文本框
    _editTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, screen_Width - 10, 200)];
    [_editTextView setBackgroundColor:[UIColor colorWithRed:0.86f green:0.86f blue:0.86f alpha:1.00f]];
    _editTextView.delegate = self;
    _editTextView.layer.cornerRadius = 10;
    _editTextView.layer.masksToBounds = YES;
    [_editTextView setFont:[UIFont systemFontOfSize:15.0f]];
    [_bgScrollView addSubview:_editTextView];
    
    //图片视图
    _shareImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(_editTextView.frame)+ 5, screen_Width - 10, 400)];
    _shareImageView.layer.cornerRadius = 10;
    _shareImageView.layer.masksToBounds = YES;
    _shareImageView.userInteractionEnabled = YES;
    [_shareImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap:)]];
    [_shareImageView setImage:self.image];
    [_bgScrollView addSubview:_shareImageView];
    
    
    //地理位置view
     _locationView = [[UIView alloc] initWithFrame:CGRectMake(5, screen_Height - 30, screen_Width - 10, 30)];
    //位置图标
    [_locationView setBackgroundColor:[UIColor whiteColor]];
    [_locationView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap:)]];
    UIImageView * locationICon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _locationView.layer.cornerRadius = 4;
    _locationView.layer.masksToBounds = YES;
    [locationICon setImage:[UIImage imageNamed:@"location"]];
    [_locationView addSubview:locationICon];
    
    //位置标签
    _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, screen_Width - 30 - 10, 30)];
    [_locationLabel setText:@"正在定位."];
    [_locationLabel setAdjustsFontSizeToFitWidth:YES];
    [_locationView addSubview:_locationLabel];
    
    //计算contentSize
    
    if (CGRectGetMaxY(_shareImageView.frame) > screen_Height) {
        _bgScrollView.contentSize = CGSizeMake(screen_Width, CGRectGetMaxY(_shareImageView.frame) + 30);
    }
    
    [self.view addSubview:_locationView];
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}


//状态栏白色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - titleView btnClick
-(void)btnClick:(UIButton *)btn {
    switch (btn.tag - 100) {
        case 0:
        {
            [self dismiss];
        }
            break;
        case 1:
        {
            //发布
            [self sendMsg];
        }
            break;
        default:
            break;
    }
}

#pragma mark - textView delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView.text.length == 1 && text.length == 0) {
        _sendBtn.enabled = NO;
    }
    else{
        _sendBtn.enabled = YES;
    }
    
    return YES;
}


#pragma mark - 点击图片手势
- (void)imageViewTap:(UITapGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self.view endEditing:YES];
    }
    
}

//关闭窗口
- (void)dismiss {
    
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 键盘事件
//键盘弹起
- (void)keyBoardUp:(NSNotification *)notification {
    
    if (isKeyBoardUp) {
        return;
    }
    isKeyBoardUp = YES;
    CGFloat offsetY = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    CGRect commentViewFrame = _locationView.frame;
    commentViewFrame.origin.y -= offsetY;
    _locationView.frame = commentViewFrame;
}

//键盘回收
- (void)keyBoardDown:(NSNotification *)notiificaiton {
    
    if (!isKeyBoardUp) {
        return;
    }
    isKeyBoardUp = NO;
    
    CGFloat offsetY = [[notiificaiton.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    CGRect commentViewFrame = _locationView.frame;
    commentViewFrame.origin.y += offsetY;
    _locationView.frame = commentViewFrame;
}

#pragma mark - 发送消息
- (void)sendMsg {
    
     //加载框
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //发送到服务器
    [BmobHelper uploadFileWithFileData:self.image block:^(NSString *url, NSError *error) {
        if (!error) {
            //当前用户
            UserManage * manager = [UserManage defaultUser];
            
            MessageModel * sendMsg = [[MessageModel alloc] init];
            sendMsg.author = manager.currentUser;
            sendMsg.device = manager.deviceModel;
            sendMsg.currentAddress = manager.currentAddress;
            [sendMsg setGeoPoint:manager.coordinate];
            sendMsg.content = _editTextView.text;
            sendMsg.pic = url;
            
            //保存消息
            [BmobHelper sendMessageWithMessageModel:sendMsg withBlock:^(BOOL isSuccess, NSError *error) {
                if (error) {
                    NSLog(@"%@",error);
                }
                
                //加载框
                [MBProgressHUD hideHUDForView :self.view animated:YES];
                [self dismiss];
            }];
        }
        else{
            NSLog(@"%@",error);
            //加载框
            [self dismiss];
            [MBProgressHUD hideHUDForView :self.view animated:YES];
        }
    }];
   
}

- (void)getLocation {
    //当前用户
    UserManage * manager = [UserManage defaultUser];
    
    //获取反地理编码
    CLLocation * clLocation = [[CLLocation alloc] initWithLatitude:manager.coordinate.latitude longitude:manager.coordinate.longitude];
    CLGeocoder * revGeo = [[CLGeocoder alloc] init];

    [revGeo reverseGeocodeLocation:clLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (!error && [placemarks count] > 0)
        {
            NSDictionary *dict = [[placemarks objectAtIndex:0] addressDictionary];
            [manager setAddressWithDic:dict];
            
            //赋值到标签显示
            [_locationLabel setText:manager.currentAddress];
            
        }
        
        else
        {
            NSLog(@"ERROR: %@", error);
        }
        
    }];
}
    

@end
