//
//  BmobHelper.h
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/2.
//  Copyright © 2015年 gf. All rights reserved.
//
@class BasicModel;
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
+ (void)insertDataWithModel:(id)dataModel withName:(NSString *)tableName withBlock:(ResultBlock)callBackBlock;

/**
 *  根据表名查询表中所有信息，返回的结果保存到modelClass数组中
 *
 *  @param className  表名
 *  @param modelClass 容器model
 *  @param responseArray 数据数组
 *  @param param:条件参数
 *  @param limited 记录数 如果为0 默认10条
 */
+ (void)queryDataWithClassName:(NSString *)className andWithReturnModelClass:(Class)modelClass withParam:(NSDictionary<NSString *,NSObject *> *)param withLimited:(NSInteger)limited withArray:(ResultArray) responseArray;


@end
