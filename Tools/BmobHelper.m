//
//  BmobHelper.m
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/2.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "BmobHelper.h"
#import "MessageModel.h"

static BmobHelper * _singleton;

@implementation BmobHelper

+ (instancetype)sharedInstance {
    
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        _singleton = [[super alloc] init];
    });
    
    return _singleton;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {

    static dispatch_once_t token;
    dispatch_once(&token, ^{
        _singleton = [super allocWithZone:zone];
    });
    
    return _singleton;
}

#pragma mark - insert
+(void)insertDataWithModel:(id)dataModel withName:(NSString *)tableName withBlock:(ResultBlock)callBackBlock {

    BmobObject * bmobObj = [BmobObject objectWithClassName:tableName];
    
    [bmobObj saveAllWithDictionary:[self removeSystemInfo:[dataModel toDictionary]]];
    [bmobObj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        
        //回调相关信息
        if (callBackBlock) {
            
            callBackBlock(isSuccessful,error);
        }
    }];
}

#pragma mark - query
+(void)queryDataWithClassName:(NSString *)className andWithReturnModelClass:(Class)modelClass withParam:(NSDictionary<NSString *,NSObject *> *)param withLimited:(NSInteger)limited withArray:(ResultArray)
    responseArray{
    
    NSMutableArray * resultArray = [@[] mutableCopy];
    
    BmobQuery * queryObj = [BmobQuery queryWithClassName:className];
    //条件
    if (param) {
        for (NSString * key in param) {
//            [queryObj whereKey:<#(NSString *)#> con]
        }
    }
    
    //记录数
    if (limited) {
        
        [queryObj setLimit:limited];
    }
    
    [queryObj findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (!error) {
            
            for (BmobObject * obj in array) {
                
                JSONModel * model = [[modelClass class] new];
                
                if ([model respondsToSelector:@selector(toDictionary)]) {
                    
                    NSDictionary * modelPropertyTitleDic = [model toDictionary];
                    
                    for (NSString * key in modelPropertyTitleDic.allKeys) {
                        id value = [obj objectForKey:key];
                        [model setValue:value forKey:key];
                    }
                    [resultArray addObject:model];
                }
               
            }
        }
        if (responseArray) {
            
            responseArray(resultArray,error);
        }
        
    }];
}

#pragma mark - 删除objectId，updatedAt，createdAt这些系统属性

+ (NSDictionary *)removeSystemInfo:(NSDictionary *)dic {

    NSMutableDictionary * resultDic = [dic mutableCopy];
    
    [resultDic removeObjectForKey:@"objectId"];
    [resultDic removeObjectForKey:@"updatedAt"];
    [resultDic removeObjectForKey:@"createdAt"];
    
    return resultDic;
}

+ (void)testDataWithString:(NSString *)str, ... {
    va_list varList;
    id arg;
    if (str) {
        va_start(varList,str);
        
        while (arg = va_arg(varList, id)) {
            NSLog(@"%@",arg);
        }
        va_end(varList);
    }
}
@end
