//
//  UIImageView+ADWebCache.m
//  AD_SDK
//
//  Created by TOPTEAM on 16/9/29.
//  Copyright © 2016年 TOPTEAM. All rights reserved.
//

#import "UIImageView+ADWebCache.h"

@implementation UIImageView (ADWebCache)

- (void)xh_setImageWithURL:(NSURL *)url
{
    [self xh_setImageWithURL:url placeholderImage:nil];
}
- (void)xh_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self xh_setImageWithURL:url placeholderImage:placeholder completed:nil];
}
- (void)xh_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(XHWebImageCompletionBlock)completedBlock
{
    [self xh_setImageWithURL:url placeholderImage:placeholder options:XHWebImageDefault completed:completedBlock];
}
-(void)xh_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(XHWebImageOptions)options completed:(XHWebImageCompletionBlock)completedBlock
{
    if(placeholder) self.image = placeholder;
    if(url)
    {
        __weak __typeof(self)wself = self;
        
        [ADWebImageDownload xh_downLoadImage_asyncWithURL:url options:options completed:^(UIImage *image, NSURL *url) {
            
            if(!wself) return;
            
            wself.image = image;
            if(image&&completedBlock)
            {
                completedBlock(image,url);
            }
        }];
    }
}
@end
