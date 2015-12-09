//
//  BmobHelper.h
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/2.
//  Copyright © 2015年 gf. All rights reserved.
//
@class UserInfoModel;
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "MessageModel.h"
/**
 *  操作数据结果回调
 *
 *  @param BOOL    是否操作成功
 *  @param NSError 错误信息
 */
typedef void (^ResultBlock)(BOOL isSuccess,NSError *error);

/**
 *  数据数组回调
 *
 *  @param responseArray 数据数组
 *  @param error 错误
 */
typedef void (^ResultArray)(NSArray *responseArray, NSError * error);

/**
 *  返回单个数据信息
 *
 *  @param dataModel 数据model
 *  @param error     错误
 */
typedef void (^ResultData)(id  dataModel, NSError * error );

/**
 *  返回图片地址
 *
 *  @param url   url
 *  @param error error
 */
typedef void (^ResultImageUrl)(NSString * url, NSError * error );

@interface BmobHelper : NSObject

/**
 *  单例模式
 *
 *  @return self
 */
+ (instancetype)sharedInstance;

/**
 *  插入一条数据
 *
 *  @param model         数据模型
 *  @param tableName     表名
 *  @param callBackBlock 回调block
 */
+ (void)insertDataWithModel:(id)dataModel
                   withName:(NSString *)tableName
                  withBlock:(ResultBlock)callBackBlock;

/**
 *  发送状态
 *
 *  @param msgModel      数据模型
 *  @param callBackBlock 回调block
 */
+ (void)sendMessageWithMessageModel:(MessageModel *)msgModel withBlock:(ResultBlock )callBackBlock;


/**
 *  根据根据用户当前坐标获取周围的状态信息
 *
 *  @param location     用户location
 *  @param resonseArray 结果
 *  @maxDistance 半径(公里)
 */
+ (void)messageWithCurrentLocation:(CLLocationCoordinate2D)location
                       maxDistance:(double)distance
                         withBlock:(ResultArray)resonseArray;
/**
 *  根据根据用户当前坐标范围获取周围的状态信息
 *  @param Region                  范围
 *  @param resonArray              回调函数
 */
+ (void)messageWithCurrentLocation:(MACoordinateRegion)region withBlock:(ResultArray)resonseArray;
/**
 *  根据id删除一行数据
 *  @param className 表名
 *  @param objectId  id
 *  @param callBackBlock  回调函数
 */
+(void)deleteDataWithClassName:(NSString *)className
                      objectId:(NSString *)objectId
                     withBlock:(ResultBlock)callBackBlock;

/**
 *  根据id获取一条记录
 *
 *  @param dbName   表名
 *  @param objId    id
 *  @param modelClass 容器model
 *  @param response obj
 */
+(void)getObjectFromDBName:(NSString *)dbName
                objectedId:(NSString *)objId
          returnModelClass:(Class)modelClass
                     block:(ResultData)response;

/**
 *  根据表名以及条件查询表中所有信息，返回的结果保存到modelClass数组中
 *
 *  @param className  表名
 *  @param modelClass 容器model
 *  @param responseArray 数据数组
 *  @param param:条件参数
 *  @param limited 记录数 如果为0 默认10条
 */
+ (void)queryDataWithClassName:(NSString *)className
       andWithReturnModelClass:(Class)modelClass
                     withParam:(NSDictionary<NSString *,NSObject *> *)param
                   withLimited:(NSInteger)limited
                     withArray:(ResultArray) responseArray;
/**
 *  返回单个model
 *
 *  @param className    表明
 *  @param modelClass   容器model
 *  @param param        参数
 *  @param responseData 返回结果
 */
+ (void)SelectDataWithClassName:(NSString *)className
        andWithReturnModelClass:(Class)modelClass
                      withParam:(NSDictionary<NSString *,NSObject *> *)param
                      withReponseData:(ResultData) responseData;
/**
 *  更新一个数据
 *
 *  @param className 表明
 *  @param dataModel 要更新的model
 *  @param callBackBlock  回调函数
 */
+ (void)updateDataWithClassName:(NSString *)className
                      WithModel:(id)dataModel
                      withBlock:(ResultBlock)callBackBlock;
/**
 *   上传单个数据
 *
 *  @param filePath 文件名
 *  @param response 结果回调
 */
+ (void)uploadDataWithPath:(NSString *)filePath block:(ResultImageUrl)response;
/**
 *  上传单个图片
 *
 *  @param image 图片
 *  @param response url结果
 */
+ (void)uploadFileWithFileData:(UIImage *)image block:(ResultImageUrl)response;

@end
