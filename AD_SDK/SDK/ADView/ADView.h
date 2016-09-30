//
//  ADView.h
//  AD_SDK
//
//  Created by TOPTEAM on 16/9/29.
//  Copyright © 2016年 TOPTEAM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADView : UIView

/** 倒计时（默认3秒） */
@property (nonatomic,assign) NSUInteger showTime;
/**
 *  初始化
 *  @param frame    广告页的位置
 *  @param appKey   申请的appKey或者应用名称
 *  @return self
 */
- (instancetype)initWithFrame:(CGRect)frame appKey:(NSString *)appKey;


/** 显示广告页面*/
- (void)show;
@end
