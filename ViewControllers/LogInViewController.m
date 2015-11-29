//
//  LogInViewController.m
//  ShareMySoul
//
//  Created by 古玉彬 on 15/11/29.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "LogInViewController.h"


@interface LogInViewController ()<MAMapViewDelegate>{
    MAMapView *_mapView;
}
@end

@implementation LogInViewController

-(void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //配置用户 Key
    [MAMapServices sharedServices].apiKey = GEO_API_KEY;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
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
