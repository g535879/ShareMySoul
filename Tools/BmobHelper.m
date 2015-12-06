//
//  BmobHelper.m
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/2.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "BmobHelper.h"
#import "UserInfoModel.h"

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
+(void)insertDataWithModel:(id)dataModel
                  withName:(NSString *)tableName
                 withBlock:(ResultBlock)callBackBlock {
    
    BmobObject * bmobObj = [BmobObject objectWithClassName:tableName];
    [bmobObj saveAllWithDictionary:[self removeSystemInfo:[dataModel toDictionary]]];
    [bmobObj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        
        //回调相关信息
        if (callBackBlock) {
            
            callBackBlock(isSuccessful,error);
        }
    }];
}

#pragma mark - delete

+ (void)deleteDataWithClassName:(NSString *)className
                       objectId:(NSString *)objectId
                      withBlock:(ResultBlock)callBackBlock{
    
    BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:className objectId:objectId];
    [bmobObject deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        
        if (callBackBlock) {
            
            callBackBlock(isSuccessful,error);
        }
    }];
}

#pragma mark - update

+ (void)updateDataWithClassName:(NSString *)className
                      WithModel:(id)dataModel
                      withBlock:(ResultBlock)callBackBlock {
    
    BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:className  objectId:[dataModel objectId]];
    
    [bmobObject saveAllWithDictionary:[self removeSystemInfo:[dataModel toDictionary]]];
    [bmobObject updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        
        if (callBackBlock) {
            
            callBackBlock(isSuccessful,error);
        }
    }];
}

#pragma mark - query
+(void)queryDataWithClassName:(NSString *)className
      andWithReturnModelClass:(Class)modelClass
                    withParam:(NSDictionary<NSString *,NSObject *> *)param
                  withLimited:(NSInteger)limited
                    withArray:(ResultArray) responseArray{
    
    NSMutableArray * resultArray = [@[] mutableCopy];
    
    BmobQuery * queryObj = [BmobQuery queryWithClassName:className];
    
    //条件参数
    if (param) {
        
        for (NSString * key in param) {
            
            [queryObj whereKey:key equalTo:param[key]];
        }
    }
    
    //默认按照更新时间降序排列
    [queryObj orderByDescending:@"updatedAt"];
    
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

+(void)SelectDataWithClassName:(NSString *)className
       andWithReturnModelClass:(Class)modelClass
                     withParam:(NSDictionary<NSString *,NSObject *> *)param
               withReponseData:(ResultData)responseData {
    
    [self queryDataWithClassName:className
         andWithReturnModelClass:modelClass
                       withParam:param withLimited:1
                       withArray:^(NSArray *responseArray, NSError *error) {
                           
        if (error) {
            responseData(nil,error);
        }
        else{
            responseData([responseArray firstObject],nil);
        }
    }];
}

//+ (void)saveUserWithModel:(UserInfoModel *)userModel withBlock:(ResultBlock)callBackBlock {
//    BmobUser * bUser = [[BmobUser alloc] init];
//    
//    [bUser saveAllWithDictionary:[self removeSystemInfo:[userModel toDictionary]]];
//    [bUser setUsername:userModel.nickname];
//    [bUser setPassword:nil];
//    [bUser saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
//        
//        //回调相关信息
//        if (callBackBlock) {
//            
//            callBackBlock(isSuccessful,error);
//        }
//    }];
//}

#pragma mark - 删除objectId，updatedAt，createdAt这些系统属性

+ (NSDictionary *)removeSystemInfo:(NSDictionary *)dic {
    
    NSMutableDictionary * resultDic = [dic mutableCopy];
    
    [resultDic removeObjectForKey:@"objectId"];
    [resultDic removeObjectForKey:@"updatedAt"];
    [resultDic removeObjectForKey:@"createdAt"];
    
    return resultDic;
}

@end
