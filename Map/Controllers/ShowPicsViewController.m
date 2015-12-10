//
//  ViewController.m
//  UICollectionViewAnimationDemo
//
//  Created by qianfeng on 15/8/27.
//  Copyright (c) 2015年 LiuYaNan. All rights reserved.
//

#import "ShowPicsViewController.h"

#import "CollecctionViewFlowLayout.h"
#import "CollectionViewCell.h"


@interface ShowPicsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate> {
    UICollectionView * collectionView;
}

@end

@implementation ShowPicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
    // 创建自定义FlowLayout布局管理器对象
    CollecctionViewFlowLayout* flowLayout = [[CollecctionViewFlowLayout alloc] init];
    collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screen_Width, screen_Height) collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
//    [self.view addSubview:collectionView];
    [collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    //背景色
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *visual = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visual.frame = self.view.bounds;
    [visual setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:visual];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:self.bgImage]];
    [visual addSubview:collectionView];
    [collectionView setBackgroundColor:[UIColor clearColor]];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
     [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)setBgImage:(UIImage *)bgImage {
    _bgImage = bgImage;
    if (bgImage) {
        
    }
}

- (void)blur{
    
//    CGImageRef
//    CIContext *context = [CIContext contextWithOptions:nil];
//    
//    CIImage *imageToBlur = [[CIImage alloc]initWithImage:self.bgImage];
//    
//    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:kCIInputImageKey,imageToBlur ,nil];
//    
//    _outputCIImage = [filter outputImage];
//    
//    UIImage *img = [UIImage imageWithCGImage:[context createCGImage:_outputCIImage fromRect:_outputCIImage.extent]];
//    
//    return img;
    
    
    
}




- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

// 该方法直接返回20，表明该控件包含20个单元格
- (NSInteger)collectionView:(UICollectionView *)view
     numberOfItemsInSection:(NSInteger)section;
{
    return self.picsArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    // 从可重用单元格队列中获取单元格
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.urlStr = self.picsArray[indexPath.row];
    
//    cell.label.text = [NSString stringWithFormat:@"%ld", indexPath.item];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
