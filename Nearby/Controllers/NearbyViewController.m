//  NearbyViewController.m
//  ShareMySoul
//
//  Created by 古玉彬 on 15/11/30.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "NearbyViewController.h"
#import "MsgMoreInfoTableViewCell.h"
#import "MessageModel.h"
#import "MJRefresh.h"
#import "MsgNoPicTableViewCell.h"

@interface NearbyViewController ()<UITableViewDataSource,UITableViewDelegate>{
    //表格布局
    UITableView * _msgTableView;
    //数据源
    NSMutableArray * _dataArray;
}

@end

@implementation NearbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //布局
    [self configLayout];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.77f green:0.80f blue:0.81f alpha:1.00f]];
}


//布局
- (void)configLayout {
    _msgTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, screen_Width, screen_Height - 64) style:UITableViewStylePlain];
    _msgTableView.delegate = self;
    _msgTableView.dataSource = self;
    _msgTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_msgTableView];
    [_msgTableView setBackgroundColor:[UIColor clearColor]];
    //刷新
    [self setRefresh];
    //注册cell
    [_msgTableView registerNib:[UINib nibWithNibName:@"MsgMoreInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellId"];
    
    [_msgTableView registerNib:[UINib nibWithNibName:@"MsgNoPicTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellNoId"];
}

- (void)setRefresh {
    _msgTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    _msgTableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //加载数据
    if (!_dataArray) {
        _msgTableView.mj_header.state = MJRefreshStateRefreshing;
        [self loadData];
    }
    
}


#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellId = @"cellId";
    static NSString * cellNoId = @"cellNoId";
    MsgMoreInfoTableViewCell * cell;
    MessageModel * msgModel= _dataArray[indexPath.row];
    if ([msgModel.pic isKindOfClass:[NSNull class]]) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellNoId];
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    }
    
    if (msgModel) {
        [cell setModel:msgModel];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellId = @"cellId";
    static NSString * cellNoId = @"cellNoId";
    MsgMoreInfoTableViewCell * cell;
    MessageModel * msgModel= _dataArray[indexPath.row];
    if (!msgModel.pic.length) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellNoId];
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    }
    
    if (msgModel) {
        [cell setModel:msgModel];
    }
    
    return cell.heightOfCell;
}

- (void)loadData {
    
    [BmobHelper messageWithCurrentLocation:[UserManage defaultUser].coordinate maxDistance:100 withBlock:^(NSArray *responseArray, NSError *error) {
        if (responseArray) {
            _dataArray = [responseArray mutableCopy];
            
            //刷新数据
            [_msgTableView reloadData];
            
            [_msgTableView.mj_header endRefreshing];
            [_msgTableView.mj_footer endRefreshing];
        }
        else{
            NSLog(@"%@",error);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
