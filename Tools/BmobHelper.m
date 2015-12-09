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

#pragma mark - 发送状态心情

+ (void)sendMessageWithMessageModel:(MessageModel *)msgModel withBlock:(ResultBlock )callBackBlock {
    
    BmobObject * msg = [BmobObject objectWithClassName:MSG_DB];
    [msg saveAllWithDictionary:[self removeSystemInfo:[msgModel toDictionary]]];
    [msg setObject:msgModel.location forKey:@"location"];
    
    //关联作者
    BmobObject * author = [BmobObject objectWithoutDatatWithClassName:USER_DB objectId:msgModel.author.objectId];
    
    [msg setObject:author forKey:@"author"];
    //保存
    [msg saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        
        if (callBackBlock) {
            
                callBackBlock(isSuccessful,error);
        }
    }];

}
#pragma mark - 根据id获取一条数据

+ (void)getObjectFromDBName:(NSString *)dbName
                 objectedId:(NSString *)objId
           returnModelClass:(Class)modelClass
                      block:(ResultData)response {
    
    
    BmobQuery * bqery = [BmobQuery queryWithClassName:dbName];
    [bqery getObjectInBackgroundWithId:objId block:^(BmobObject *object, NSError *error) {
        
        if (error) {
            
            response(object,error);
            
        }else{
            
            response([[self objectsWithModelClass:modelClass fromBmobObjtArray:@[object]] firstObject],nil);
        }
        
    }];
}

#pragma mark - 获取指定范围内的心情数据
+ (void)messageWithCurrentLocation:(CLLocationCoordinate2D)location maxDistance:(double)distance withBlock:(ResultArray)resonseArray {
    BmobGeoPoint * point = [[BmobGeoPoint alloc] initWithLongitude:location.longitude WithLatitude:location.latitude];
    BmobQuery * bquery = [BmobQuery queryWithClassName:MSG_DB];
    [bquery whereKey:@"location" nearGeoPoint:point withinKilometers:distance];
    [self messagewithBmob:bquery withBlock:^(NSArray *responseArray, NSError *error) {
        resonseArray(responseArray,error);
    }];
    
}
#pragma mark - 根据地理范围获取数据
+ (void)messageWithCurrentLocation:(MACoordinateRegion)region withBlock:(ResultArray)resonseArray {
    
    BmobQuery * bquery = [BmobQuery queryWithClassName:MSG_DB];
    CLLocationCoordinate2D center = region.center;
    MACoordinateSpan span = region.span;
    
    //经纬度范围。仅限。。仅限。。中国
    BmobGeoPoint * swPoint = [[BmobGeoPoint alloc] initWithLongitude:center.longitude - span.longitudeDelta/2.0f WithLatitude:center.latitude - span.latitudeDelta/2.0f];
    
    BmobGeoPoint * nePoint = [[BmobGeoPoint alloc] initWithLongitude:center.longitude + span.longitudeDelta / 2.0f WithLatitude:center.latitude + span.latitudeDelta / 2.0f];
    
    
    [bquery whereKey:@"location" withinGeoBoxFromSouthwest:swPoint toNortheast:nePoint];
    
    [self messagewithBmob:bquery withBlock:^(NSArray *responseArray, NSError *error) {
        resonseArray(responseArray,error);
    }];
}

#pragma mark - 根据地理范围获取数据
+ (void)messagewithBmob:(BmobQuery *)bquery withBlock:(ResultArray)resonse {
    
    
    
    //查询作者
    //    [bquery includeKey:@"author"];
    //    查询评论的人
    //    [bquery includeKey:@"comment"];
    
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (error) {
            
            resonse(nil,error);
        }
        else{
            
            NSMutableArray *resultArray = [@[] mutableCopy];
            
            //创建gcd group 控制顺序执行
            dispatch_group_t group  = dispatch_group_create();
            
            dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                for (BmobObject * obj in array) {
                    
                    dispatch_group_enter(group);
                    MessageModel * model = [[MessageModel alloc] init];
                    
                    if ([model respondsToSelector:@selector(toDictionary)]) {
                        
                        NSDictionary * modelPropertyTitleDic = [model toDictionary];
                        
                        for (NSString * key in modelPropertyTitleDic.allKeys) {
                            id value = [obj objectForKey:key];
                            [model setValue:value forKey:key];
                        }
                        //消息坐标
                        model.location = [obj objectForKey:@"location"];
                        
                        NSString * authorId = [[obj objectForKey:@"author"] objectId];
                        
                        if (authorId) {
                            
                            //获取作者
                            [self getObjectFromDBName:USER_DB objectedId:authorId returnModelClass:[UserInfoModel class] block:^(id dataModel, NSError *error) {
                                if (error) {
                                    NSLog(@"%@",error);
                                }
                                else {
                                    
                                    model.author = dataModel;
                                    [resultArray addObject:model];
                                    
                                }
                                dispatch_group_leave(group);
                                
                            }];
#warning 获取评论
                        }else{
                            dispatch_group_leave(group);
                        }
                        
                    }
                    
                }
            });
            
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                //回调
                resonse(resultArray,nil);
            });
            
            
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
            
            //转化为自定义模型
            NSArray * resultArray = [self objectsWithModelClass:modelClass fromBmobObjtArray:array];
            
            responseArray(resultArray,nil);
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


#pragma mark - 上传单个文件

+ (void)uploadDataWithPath:(NSString *)filePath block:(ResultImageUrl)response {
    
    BmobFile * uploadFile = [[BmobFile alloc] initWithFilePath:filePath];
    [uploadFile saveInBackground:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            response(uploadFile.url,nil);
        }else{
            
            response(nil,error);
        }
    }];
}

+ (void)uploadFileWithFileData:(UIImage *)image block:(ResultImageUrl)response {
    NSData * fileData = UIImageJPEGRepresentation(image, 0.7);
    NSString * fileName = [NSString stringWithFormat:@"%@.jpg",[Bmob getServerTimestamp]];
    BmobFile * uploadFile = [[BmobFile alloc] initWithFileName:fileName withFileData:fileData];
    [uploadFile saveInBackground:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            response(uploadFile.url,nil);
        }else{
            
            response(nil,error);
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


//根据类名和bmobObjet返回model
+ (NSArray *)objectsWithModelClass:(Class)modelClass fromBmobObjtArray:(NSArray *)bmobArr {
    
    NSMutableArray * resultArray = [@[] mutableCopy];
    
    for (BmobObject * obj in bmobArr) {
        
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
    return resultArray;
}
@end
