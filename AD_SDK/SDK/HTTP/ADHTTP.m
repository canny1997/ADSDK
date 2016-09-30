//
//  ADHTTP.m
//  AD_SDK
//
//  Created by TOPTEAM on 16/9/29.
//  Copyright © 2016年 TOPTEAM. All rights reserved.
//

#import "ADHTTP.h"

@implementation ADHTTP


#pragma mark http的同步get请求，返回服务器返回的数据
+ (NSData *)synHttpForGet:(NSString *)urlstring error:(NSError **)error
{
    return [self synHttpForGet:urlstring addParams:nil error:error];
}

#pragma mark http的同步get请求，返回服务器返回的数据
+ (NSData *)synHttpForGet:(NSString *)urlstring addParams:(NSDictionary*)params error:(NSError **)error{
    
    if(urlstring.length <= 0) return nil;
    
    if (params && params.count > 0) {
        urlstring = [[NSString stringWithFormat:@"%@?%@",urlstring,[self addParams:params]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    NSURL* url = [NSURL URLWithString:urlstring];
    
    ADRequest* request = [[ADRequest alloc]init];
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TIMEOUT];
    
    return [request startSynrc:error];
}

+ (NSData *)synHttpForGet:(NSString *)urlstring timeOut:(int)timeOut error:(NSError **)error{
    
    if(urlstring.length <= 0) return nil;
    NSURL* url = [NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    ADRequest* request = [[ADRequest alloc]init];
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:timeOut];
    
    return [request startSynrc:error];
}

#pragma mark  http的同步post请求，返回服务器返回的数据
+ (NSData *)synHttpForPost:(NSString *)urlstring error:(NSError **)error
{
    return [self synHttpForPost:urlstring addData:nil error:error];
}


#pragma mark  http的同步post请求，返回服务器返回的数据
+(NSData *)synHttpForPost:(NSString *)urlstring addData:(NSData *)bodyData error:(NSError **)error
{
    if(urlstring.length <= 0) return nil;
    
    //设置post请求头
    NSMutableDictionary *headerParamdic = [[NSMutableDictionary alloc] init];
    [headerParamdic setValue:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
    [headerParamdic setValue:[NSString stringWithFormat:@"%lu",(unsigned long)bodyData.length] forKey:@"Content-Length"];
    
    ADRequest *request = [ADRequest requestWithURL:[NSURL URLWithString:urlstring]];
    
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:TIMEOUT];
    [self addHeaderParams:headerParamdic urlRequest:request];
    [request setHTTPBody:bodyData];
    
    return [request startSynrc:error];
    
}

#pragma mark  http的同步post请求，返回服务器返回的数据
+ (NSData *)synHttpForPost:(NSString *)urlstring addParams :(NSDictionary *)bodyParams error:(NSError **)error
{
    return [self synHttpForPost:urlstring addData:[self paramToData:bodyParams] error:error];
}

#pragma mark  http的同步post请求，返回服务器返回的数据
+ (NSData *)synHttpForPost:(NSString *)urlstring timeOut:(int)timeOut addData:(NSData *)bodyData error:(NSError **)error
{
    if(urlstring.length <= 0) return nil;
    //设置post请求头
    NSMutableDictionary *headerParamdic = [[NSMutableDictionary alloc] init];
    [headerParamdic setValue:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
    [headerParamdic setValue:[NSString stringWithFormat:@"%lu",(unsigned long)bodyData.length] forKey:@"Content-Length"];
    
    ADRequest *request = [ADRequest requestWithURL:[NSURL URLWithString:urlstring]];
    
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:timeOut];
    [ADHTTP addHeaderParams:headerParamdic urlRequest:request];
    [request setHTTPBody:bodyData];
    
    return [request startSynrc:error];
    
}

#pragma mark http的异步get请求
+ (ADRequest *)asynHttpForGet:(NSString *)urlstring
                        block:(HttpFinishLoadBlock)block
                    failBlock:(FailLoadBlock)failBlock{
    return [self asynHttpForGet:urlstring params:nil block:block failBlock:failBlock];
}

#pragma mark http的异步get请求
+ (ADRequest *)asynHttpForGet:(NSString *)urlstring
                       params:(NSDictionary *)params
                        block:(HttpFinishLoadBlock)block failBlock:(FailLoadBlock)failBlock{
    
    if(urlstring.length <= 0) return nil;
    NSString *requestUrl = urlstring;
    if (params && params.count > 0) {
        requestUrl = [[NSString stringWithFormat:@"%@?%@",urlstring,[self addParams:params]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    ADRequest *request = [ADRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TIMEOUT];
    
    request.block = ^(NSData *data) {
        block(data);
    };
    request.failBlock = ^(NSError *error) {
        failBlock(error);
    };
    
    [request startAsynrc];
    return request;
}

#pragma mark http的异步post请求
+ (ADRequest *)asynHttpForPost:(NSString *)urlstring block:(HttpFinishLoadBlock)block failBlock:(FailLoadBlock)failBlock
{
    return [self asynHttpForPost:urlstring addData:nil block:block failBlock:failBlock];
}

#pragma mark http的异步post请求
+ (ADRequest *)asynHttpForPost:(NSString *)urlstring addData:(NSData *)bodyData block:(HttpFinishLoadBlock)block failBlock:(FailLoadBlock)failBlock{
    
    if(urlstring.length <= 0) return nil;
    
    //设置post请求头
    NSMutableDictionary *headerParamdic = [[NSMutableDictionary alloc] init];
    [headerParamdic setValue:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
    [headerParamdic setValue:[NSString stringWithFormat:@"%lu",(unsigned long)bodyData.length] forKey:@"Content-Length"];
    
    //url编码
    ADRequest *request = [ADRequest requestWithURL:[NSURL URLWithString:urlstring]];
    
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:TIMEOUT];
    [self addHeaderParams:headerParamdic urlRequest:request];
    [request setHTTPBody:bodyData];
    
    request.block = ^(NSData *data) {
        block(data);
    };
    
    request.failBlock = ^(NSError *error) {
        failBlock(error);
    };
    
    [request startAsynrc];
    
    return request;
}

#pragma mark http的异步post请求
+ (ADRequest *)asynHttpForPost:(NSString *)urlstring addParams:(NSDictionary *)bodyParams block:(HttpFinishLoadBlock)block failBlock:(FailLoadBlock)failBlock
{
    return [self asynHttpForPost:urlstring addData:[self paramToData:bodyParams] block:block failBlock:failBlock];
}



#pragma mark 设置头文件参数
+ (void)addHeaderParams:(NSMutableDictionary *)params urlRequest:(NSMutableURLRequest*) request{
    if(params == nil || params.count == 0) return;
    
    NSArray* paramKeys = [params allKeys];
    for (int i = 0; i < [params count]; i++) {
        NSString *key = (NSString*)([paramKeys objectAtIndex:i]);
        NSString *value = (NSString*)([params objectForKey:key]);
        [request addValue: value forHTTPHeaderField:key];
    }
    
}

#pragma mark 设置get参数
+ (NSString *)addParams:(NSDictionary*)params{
    if(params == nil || params.count == 0) return @"";
    
    NSArray* paramKeys = [params allKeys];
    NSMutableString *paramStr = [NSMutableString stringWithFormat:@""];
    for (int i = 0; i < [params count]; i++) {
        NSString *key = (NSMutableString*)([paramKeys objectAtIndex:i]);
        NSString *value = (NSString*)([params objectForKey:key]);
        NSString *str = [NSString stringWithFormat:@"%@=%@",key,value];
        [paramStr appendString:str];
        if (i != params.count - 1) {
            [paramStr appendString:@"&"];
        }
    }
    
    return paramStr;
}

+ (NSData *)paramToData:(NSDictionary *)params
{
    NSData *bodyData;
    if (params && params.count > 0) {
        NSString *bodyStr = [[NSString stringWithFormat:@"%@",[self addParams:params]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        bodyData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    }
    return bodyData;
}

#pragma mark 取消请求
+ (void)cancel:(ADRequest *)request
{
    if (request == nil) return;
    [request cancel];
}

@end
