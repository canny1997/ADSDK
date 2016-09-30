//
//  ADRequest.h
//  AD_SDK
//
//  Created by TOPTEAM on 16/9/29.
//  Copyright © 2016年 TOPTEAM. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^FinishLoadBlock)(NSData *data);
typedef void(^FailLoadBlock)(NSError *error);

@interface ADRequest : NSMutableURLRequest<NSURLConnectionDataDelegate>{
    
}

@property(nonatomic,retain)NSMutableData *data;
@property(nonatomic,retain)NSURLConnection *connection;
@property(nonatomic,copy)FinishLoadBlock block;
@property(nonatomic,copy)FailLoadBlock failBlock;

//开始异步请求
- (void)startAsynrc;

//取消异步请求
- (void)cancel;

//开始同步请求
- (NSData *)startSynrc:(NSError **)error;


@end
