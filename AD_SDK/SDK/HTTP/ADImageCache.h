//
//  ADImageCache.h
//  AD_SDK
//
//  Created by TOPTEAM on 16/9/29.
//  Copyright © 2016年 TOPTEAM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADImageCache : NSObject

/**
 *  获取缓存图片
 *
 *  @param url 图片url
 *
 *  @return 图片
 */
+(UIImage *)xh_getCacheImageWithURL:(NSURL *)url;

/**
 *  缓存图片
 *
 *  @param data imageData
 *  @param url  图片url
 */
+(void)xh_saveImageData:(NSData *)data imageURL:(NSURL *)url;

/**
 *  获取缓存路径
 *
 *  @return path
 */
+(NSString *)xh_cacheImagePath;

/**
 *  check路径
 *
 *  @param path 路径
 */
+(void)xh_checkDirectory:(NSString *)path;
@end

