//
//  GiFTool.m
//  AD_SDK
//
//  Created by TOPTEAM on 16/9/29.
//  Copyright © 2016年 TOPTEAM. All rights reserved.
//

#import "GiFTool.h"
#import "ADImageCache.h"
@implementation GiFTool

/**
 *  获取缓存图片
 *
 *  @param url 图片url
 *
 *  @return 图片
 */
+(UIImage *)ad_getCacheImageWithPath:(NSString *)url{
    
    if (url) {
        return  [ADImageCache xh_getCacheImageWithURL:[NSURL URLWithString:url]];
    }else{
        return nil;
    }
    
}

/**
 *  缓存图片
 *
 *  @param data imageData
 *  @param url  图片url
 */
+(void)ad_saveImageData:(NSData *)data imagePath:(NSString *)url{
    [ADImageCache  xh_saveImageData:data imageURL:[NSURL URLWithString:url]];
}

/**
 *  获取缓存路径
 *
 *  @return path
 */
+(NSString *)ad_cacheImagePath{
    return [ADImageCache xh_cacheImagePath];
}

/**
 *  check路径
 *
 *  @param path 路径
 */
+(void)ad_checkDirectory:(NSString *)path{
    [ADImageCache xh_checkDirectory:path];
}
@end
