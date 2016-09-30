//
//  GiFTool.h
//  AD_SDK
//
//  Created by TOPTEAM on 16/9/29.
//  Copyright © 2016年 TOPTEAM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiFTool : NSObject
/**
 *  获取缓存图片
 *
 *  @param url 图片url
 *
 *  @return 图片
 */
+(UIImage *)ad_getCacheImageWithPath:(NSString *)url;

/**
 *  缓存图片
 *
 *  @param data imageData
 *  @param url  图片url
 */
+(void)ad_saveImageData:(NSData *)data imagePath:(NSString *)url;

/**
 *  获取缓存路径
 *
 *  @return path
 */
+(NSString *)ad_cacheImagePath;

/**
 *  check路径
 *
 *  @param path 路径
 */
+(void)ad_checkDirectory:(NSString *)path;
@end
