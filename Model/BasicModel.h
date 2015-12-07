//
//  BasicModel.h
//  ShareMySoul
//
//  Created by 古玉彬 on 15/12/3.
//  Copyright © 2015年 gf. All rights reserved.
//

#import "RootModel.h"


@interface BasicModel : RootModel

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

