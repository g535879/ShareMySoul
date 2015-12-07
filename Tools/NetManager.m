//
//  NetManager.m
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/23.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import "NetManager.h"

@interface NetManager ()

@property (strong, nonatomic) AFHTTPRequestOperationManager * manager;


@property (strong, nonatomic) SDWebImageManager * sdManager;

@end
static NetManager * singltonManager = nil;

@implementation NetManager

+ (instancetype)defaultManager {
    
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        singltonManager = [[super alloc] init];
    });
    return singltonManager;
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        singltonManager = [super allocWithZone:zone];
    });
    
    return singltonManager;
}


- (AFHTTPRequestOperationManager *)manager {
    
    if (!_manager) {
        _manager = [AFHTTPRequestOperationManager manager];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    
    return _manager;
}

- (SDWebImageManager *)sdManager {
    if (!_sdManager) {
        _sdManager = [SDWebImageManager sharedManager];
    }
    
    return _sdManager;
}

+ (void)loadDataWithUrlStr:(NSString *)urlStr param:(NSDictionary *)params block:(SuccessCallBackData)success withFaile:(FailureCallBackData)failure {
    NetManager * singleton = [NetManager defaultManager];
    
    [singleton.manager GET:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //回调获取的数据
        //
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        //失败回调
        failure(error);
    }];
}

+ (void)loadImageWithUrl:(NSURL *)url clearCache:(BOOL)clearCache block:(LoadImageCallBackData)response {
    
    
    NetManager * singleton = [NetManager defaultManager];
    
   __block UIImage * cacheImage;

    __weak typeof(singleton.sdManager) weakManager = singleton.sdManager;
    
    //清除缓存
    if (clearCache) {
        
        [[singleton.sdManager imageCache] clearDisk];
    }
    
    [singleton.sdManager cachedImageExistsForURL:url completion:^(BOOL isInCache) {
        if (isInCache) {
            
             cacheImage = [[singleton.sdManager imageCache] imageFromDiskCacheForKey:url.absoluteString];
            //有图片
            if (response) {
                response(cacheImage,nil);
            }
        }
        else{
            
            [[singleton.sdManager imageDownloader] downloadImageWithURL:url options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                if (response) {
                    
                    response(image,nil);
                }
                __strong typeof(weakManager) strongManager = weakManager;
                //缓存到本地
                [strongManager saveImageToCache:image forURL:url];
                
            }];
        }
    }];
}
@end
