//
//  BmobHelper.h
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/2.
//  Copyright © 2015年 gf. All rights reserved.
//
@class UserInfoModel;
#import <Foundation/Foundation.h>
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
 *  根据id删除一行数据
 *
 *  @param className 表名
 *  @param objectId  id
 *  @param callBackBlock  回调函数
 */
+(void)deleteDataWithClassName:(NSString *)className
                      objectId:(NSString *)objectId
                     withBlock:(ResultBlock)callBackBlock;

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
///**
// *  保存用户
// *
// *  @param userModel     用户模型
// *  @param callBackBlock 回调函数
// */
//+ (void)saveUserWithModel:(UserInfoModel *)userModel
//                withBlock:(ResultBlock)callBackBlock;
@end
