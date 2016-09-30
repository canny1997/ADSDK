//
//  ADWebImageDownload.m
//  AD_SDK
//
//  Created by TOPTEAM on 16/9/29.
//  Copyright © 2016年 TOPTEAM. All rights reserved.
//


#import "ADWebImageDownload.h"
#import "ADImageCache.h"
#import "UIImage+ADGIF.h"

@implementation ADWebImageDownload
+(void)xh_downLoadImage_asyncWithURL:(NSURL *)url options:(XHWebImageOptions)options completed:(XHWebImageCompletionBlock)completedBlock
{
    if(!options) options = XHWebImageDefault;
    if(options&XHWebImageOnlyLoad)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            UIImage *image = [self xh_downLoadImageWithURL:url];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(completedBlock)
                {
                    completedBlock(image,url);
                }
            });
        });
        
        return;
    }
    UIImage *image0 = [ADImageCache xh_getCacheImageWithURL:url];
    if(image0&&completedBlock)
    {
        completedBlock(image0,url);
        
        if(options&XHWebImageDefault) return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *image = [self xh_downLoadImageAndCacheWithURL:url];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(completedBlock)
            {
                completedBlock(image,url);
            }
        });
        
    });
}

+(UIImage *)xh_downLoadImageWithURL:(NSURL *)url{
    
    if(url==nil) return nil;
    NSData *data = [NSData dataWithContentsOfURL:url];
    return [UIImage xh_animatedGIFWithData:data];
    
}
+(UIImage *)xh_downLoadImageAndCacheWithURL:(NSURL *)url
{
    if(url==nil) return nil;
    NSData *data = [NSData dataWithContentsOfURL:url];
    [ADImageCache xh_saveImageData:data imageURL:url];
    return [UIImage xh_animatedGIFWithData:data];
}
@end
