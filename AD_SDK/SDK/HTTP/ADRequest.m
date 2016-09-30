//
//  ADRequest.m
//  AD_SDK
//
//  Created by TOPTEAM on 16/9/29.
//  Copyright © 2016年 TOPTEAM. All rights reserved.
//

#import "ADRequest.h"


@implementation ADRequest

#pragma mark 开始请求
- (void)startAsynrc {
    
    self.data = [NSMutableData data];
    
    //发送异步请求
    self.connection = [NSURLConnection connectionWithRequest:self delegate:self];
}

#pragma mark 取消请求
- (void)cancel {
    
    [self.connection cancel];
}


#pragma mark - NSURLConnection delegate
#pragma mark 正在请求
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.data appendData:data];
}

#pragma mark 请求完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    if (_block) {
        _block(_data);
    }
}

#pragma mark 请求出错
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"请求网络出错：%@",error);
    [self cancel];
    if (_failBlock) {
        _failBlock(error);
    }
}

#pragma mark - https证书处理
//如果返回No，将由系统自行处理。返回YES将会由后续的didReceiveAuthenticationChallenge处理。默认为No。
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    NSLog(@"处理证书");
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}


- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge previousFailureCount] == 0){
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
    }else{
        [[challenge sender]cancelAuthenticationChallenge:challenge];
    }
}


#pragma mark 发起同步请求
- (NSData *)startSynrc:(NSError **)error {
    
    NSHTTPURLResponse *urlResponese = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:self returningResponse:&urlResponese error:error];
    
    NSLog(@"error:%@",*error);
    return responseData;
}

@end
