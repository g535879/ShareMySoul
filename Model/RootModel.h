//
//  RootModel.h
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/6.
//  Copyright © 2015年 gf. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#define proStr(str) @property (nonatomic, copy) NSString * (str)

#define proArr(arr) @property (nonatomic, copy) NSArray * (arr)

#define proInteger(i) @property (nonatomic, assign) NSInteger (i)

#define proMuArr(muArr) @property (nonatomic, strong) NSMutableArray * (muArr)

#define proDate(date) @property (nonatomic, copy) NSDate * (date)

@interface RootModel : JSONModel

@end
