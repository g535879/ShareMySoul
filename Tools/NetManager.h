//
//  NetManager.h
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/23.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetManager : NSObject
/**
 下载数据成功回调
 */
typedef void (^SuccessCallBackData)(id successData);

/**
 下载数据回调失败
 */
typedef void (^FailureCallBackData)(NSError *error);

//加载图片回调
typedef void (^LoadImageCallBackData)(UIImage * image, NSError * error);
/**
 单例对象
 */

+ (instancetype)defaultManager;

/**
 *  下载数据
 *
 *  @param urlStr  地址
 *  @param params  参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */

+ (void)loadDataWithUrlStr:(NSString *)urlStr
                     param:(NSDictionary *)params
                     block:(SuccessCallBackData) success
                 withFaile:(FailureCallBackData) failure;

/**
 *  加载图片
 *
 *  @param url 根据url加载图片
 *  #param LoadImageCallBackData 加载完成回调函数
 *  @param url 是否清除缓存
 */
+ (void)loadImageWithUrl:(NSURL *)url
              clearCache:(BOOL)
        clearCache block:(LoadImageCallBackData)response ;
@end
