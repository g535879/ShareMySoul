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
#import "MsgMoreInfoTableViewCell.h"

@interface ShowPicsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate> {
    UICollectionView * _collectionView;
}

@end

@implementation ShowPicsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    

    // 创建自定义FlowLayout布局管理器对象
    CollecctionViewFlowLayout* flowLayout = [[CollecctionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screen_Width, screen_Height) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    
    [_collectionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(collectionViewTouch:)]];
    
//    [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"ImageShareCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"MsgMoreInfoTableViewCell" bundle:nil] forCellWithReuseIdentifier:@"cellId"];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:_collectionView];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
}


#pragma mark -  collectionview点击事件
- (void)collectionViewTouch:(UITapGestureRecognizer *)getsture {
    self.view.hidden = YES;
    NSLog(@"tap");
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark - getter
- (NSMutableArray *)picsArray {
    if (!_picsArray) {
        _picsArray = [@[] mutableCopy];
    }
    return _picsArray;
}

- (NSInteger)collectionView:(UICollectionView *)view
     numberOfItemsInSection:(NSInteger)section;
{
    return self.picsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    // 从可重用单元格队列中获取单元格
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];

    [cell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subCellTapTouch:)]];
    return cell;
}

- (void)subCellTapTouch:(UITapGestureRecognizer *)gesture {
    NSLog(@"cell touch ");
}

#pragma mark - 刷新数据
- (void)reloadData {
    
    [_collectionView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
