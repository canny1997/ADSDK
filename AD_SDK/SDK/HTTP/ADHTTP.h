//
//  ADHTTP.h
//  AD_SDK
//
//  Created by TOPTEAM on 16/9/29.
//  Copyright © 2016年 TOPTEAM. All rights reserved.
//



#define TIMEOUT 20

#import <Foundation/Foundation.h>
#import "ADRequest.h"

typedef void(^HttpFinishLoadBlock)(NSData* data);
typedef void(^FailLoadBlock)(NSError* error);
typedef void(^CancelBlock)(NSError* error);

@interface ADHTTP : NSObject

#pragma mark http的同步请求，返回服务器返回的数据
+ (NSData *)synHttpForGet:(NSString *)urlstring error:(NSError **)error;
+ (NSData *)synHttpForGet:(NSString *)urlstring addParams:(NSDictionary*)params error:(NSError **)error;
+ (NSData *)synHttpForGet:(NSString *)urlstring timeOut:(int)timeOut error:(NSError **)error;

+ (NSData *)synHttpForPost:(NSString *)urlstring error:(NSError **)error;
+ (NSData *)synHttpForPost:(NSString *)urlstring addData:(NSData *)bodyData error:(NSError **)error;
+ (NSData *)synHttpForPost:(NSString *)urlstring addParams:(NSDictionary *)bodyParams error:(NSError **)error;
+ (NSData *)synHttpForPost:(NSString *)urlstring timeOut:(int)timeOut addData:(NSData *)bodyData error:(NSError **)error;

#pragma mark http的异步请求
+ (ADRequest *)asynHttpForGet:(NSString *)urlstring block:(HttpFinishLoadBlock)block failBlock:(FailLoadBlock)failBlock;
+ (ADRequest *)asynHttpForGet:(NSString *)urlstring params:(NSDictionary *)params block:(HttpFinishLoadBlock)block failBlock:(FailLoadBlock)failBlock;
+ (ADRequest *)asynHttpForPost:(NSString *)urlstring block:(HttpFinishLoadBlock)block failBlock:(FailLoadBlock)failBlock;
+ (ADRequest *)asynHttpForPost:(NSString *)urlstring addData:(NSData *)bodyData block:(HttpFinishLoadBlock)block failBlock:(FailLoadBlock)failBlock;
+ (ADRequest *)asynHttpForPost:(NSString *)urlstring addParams:(NSDictionary *)bodyParams block:(HttpFinishLoadBlock)block failBlock:(FailLoadBlock)failBlock;
+ (void)cancel:(ADRequest *)request;

@end
