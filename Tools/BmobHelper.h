//
//  BmobHelper.h
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/2.
//  Copyright © 2015年 gf. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  操作数据回调
 *
 *  @param BOOL    是否操作成功
 *  @param NSError 错误信息
 */
typedef void (^ResultBlock)(BOOL isSuccess,NSError *error);

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
@end
