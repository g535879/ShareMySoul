//
//  BasicModel.h
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/3.
//  Copyright © 2015年 gf. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#define proStr(str) @property (nonatomic, copy) NSString * (str)

#define proArr(arr) @property (nonatomic, copy) NSArray * (arr)

#define proInteger(i) @property (nonatomic, assign) NSInteger (i)

#define proMuArr(muArr) @property (nonatomic, strong) NSMutableArray * (muArr)

#define proDate(date) @property (nonatomic, copy) NSDate * (date)

@interface BasicModel : JSONModel

/**
 *  数据ID
 */
proStr(objectId);

/**
 *  数据建立时间
 */
proDate(createdAt);

/**
 *  更新建立时间
 */
proDate(updatedAt);

@end
