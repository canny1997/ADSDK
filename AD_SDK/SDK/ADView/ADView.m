//
//  ADView.m
//  AD_SDK
//
//  Created by TOPTEAM on 16/9/29.
//  Copyright © 2016年 TOPTEAM. All rights reserved.
//

#import "ADView.h"
#import "ADHTTP.h"
#import "GiFTool.h"


//静态广告
#define ImgUrlString1 @"http://d.hiphotos.baidu.com/image/pic/item/14ce36d3d539b60071473204e150352ac75cb7f3.jpg"
//动态广告
#define ImgUrlString2 @"http://c.hiphotos.baidu.com/image/pic/item/d62a6059252dd42a6a943c180b3b5bb5c8eab8e7.jpg"




#define AD_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define AD_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define AD_UserDefaults [NSUserDefaults standardUserDefaults]
static NSString *const AD_ImageName = @"adImageName";
static NSString *const AD_Url = @"adUrl";
static NSString *const AD_Type = @"AD_Type";

#define AD_Type_MEDIO  @"AD_Type_MEDIO"
#define AD_Type_IMG    @"AD_Type_IMG"

#define URL_HTTP     @"http://www.51hfzs.cn/data.json"

#define APPKEY_BESTKEEP  @"BESTKEEP"
#define APPKEY_UTOUU     @"UTOUU"

@interface ADView()

@property (nonatomic, strong) UIImageView *adView;
@property (nonatomic, strong) UIButton *countBtn;
@property (nonatomic, strong) NSTimer *countTimer;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, copy)   NSString *imgPath;/** 广告图片本地路径 */
@property (nonatomic, copy)   NSString *imgUrl;/** 新广告图片地址 */
@property (nonatomic, copy)   NSString *adUrl;/** 新广告的链接 */
@property (nonatomic, copy)   NSString *clickAdUrl;/** 所点击的广告链接 */
@property (nonatomic, copy)   void (^clickImg)(NSString *url);/** 点击图片回调block */
@property (nonatomic, strong) NSMutableDictionary *responseDic;
@property (nonatomic, copy)   NSString *app_key;


@end

@implementation ADView

-(NSUInteger)showTime
{
    if (_showTime == 0)
    {
        _showTime = 3;
    }
    return _showTime;
}

- (NSTimer *)countTimer
{
    if (!_countTimer) {
        _countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }
    return _countTimer;
}
#pragma mark==================================================
- (instancetype)initWithFrame:(CGRect)frame appKey:(NSString *)appKey{
    self = [super initWithFrame:frame];
    if (self) {
        
        _responseDic = [NSMutableDictionary dictionary];
        //广告图片
        _adView = [[UIImageView alloc] initWithFrame:frame];
        _adView.userInteractionEnabled = YES;
        _adView.contentMode = UIViewContentModeScaleAspectFill;
        _adView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToAd)];
        [_adView addGestureRecognizer:tap];
        
        //跳过按钮
        CGFloat btnW = 60;
        CGFloat btnH = 30;
        _countBtn = [[UIButton alloc] initWithFrame:CGRectMake(AD_SCREEN_WIDTH - btnW - 24, btnH, btnW, btnH)];
        [_countBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        _countBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_countBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _countBtn.backgroundColor = [UIColor colorWithRed:38 /255.0 green:38 /255.0 blue:38 /255.0 alpha:0.6];
        _countBtn.layer.cornerRadius = 4;
        
        [self addSubview:_adView];
        [self addSubview:_countBtn];
        
        self.app_key=appKey;
        
        //添加监听 视频播放完成
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"moviePlayDidEnd" object:nil];
    }
    return self;
}

- (void)show
{

    
    //判断本地缓存广告是否存在，存在即显示
    if ([self imageExist]) {
               //当前显示的广告图片
        
      
            //设置按钮倒计时
            [_countBtn setTitle:[NSString stringWithFormat:@"跳过%zd", self.showTime] forState:UIControlStateNormal];

            _adView.image = [GiFTool ad_getCacheImageWithPath: [AD_UserDefaults valueForKey:AD_ImageName]];
            //开启倒计时
            [self startTimer];

        
        //当前显示的广告链接
        _clickAdUrl = [AD_UserDefaults valueForKey:AD_Url];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];

    }
    
    //不管本地是否存在广告图片都获取最新图片
    [self requetADData];
    
}
#pragma mark==================================================
-(void)requetADData{
    NSString * http_url;
    if ([self.app_key isEqualToString:APPKEY_BESTKEEP]) {
        http_url=URL_HTTP;
    }else if ([self.app_key isEqualToString:APPKEY_UTOUU]){
        http_url=URL_HTTP;
    }else{
        http_url=URL_HTTP;
    }
    
    [ADHTTP asynHttpForGet:http_url  block:^(NSData *data) {
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"%@",dictionary);
        
        _responseDic = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        
        if (_responseDic[@"image"]) {
            [AD_UserDefaults setValue:AD_Type_IMG forKey:AD_Type];
            _imgPath=_responseDic[@"image"];
            
            [self setNewADImgUrl:_responseDic[@"image"]];
            
        }
        
    } failBlock:^(NSError *error) {
        
    }];
    
}




//判断沙盒中是否存在广告图片，如果存在，直接显示
- (BOOL)imageExist
{
    
    if ([AD_UserDefaults valueForKey:AD_ImageName]) {
        _imgPath=[AD_UserDefaults valueForKey:AD_ImageName];
        return YES;
    }
    return NO;
    
}


//跳转到广告页面
- (void)pushToAd{
    NSUserDefaults *userDefault =  [NSUserDefaults standardUserDefaults];
    NSString *clikImgUrl = [userDefault objectForKey:AD_Url];
    if (clikImgUrl != nil) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:clikImgUrl]];
        [self dismiss];
    }
}

//跳过
- (void)countDown
{
    _count --;
    [_countBtn setTitle:[NSString stringWithFormat:@"跳过%zd",_count] forState:UIControlStateNormal];
    if (_count == 0) {
        
        [self dismiss];
    }
}

// 定时器倒计时
- (void)startTimer
{
    _count = self.showTime;
    [[NSRunLoop mainRunLoop] addTimer:self.countTimer forMode:NSRunLoopCommonModes];
}


// 移除广告页面
- (void)dismiss
{
    [self.countTimer invalidate];
    self.countTimer = nil;
    
    [UIView animateWithDuration:0.3f animations:^{
        
        self.alpha = 0.f;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}

//获取最新广告
- (void)setNewADImgUrl:(NSString *)imgUrl
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
//                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://124.193.165.209/vhot2.qqvideo.tc.qq.com/z01685nf12f.mp4?sdtfrom=v1010&amp;guid=2faae64ad495ffc8d441b44f0eedce60&amp;vkey=1279F181CF5BFC9196B2EFFAB3AD9E3E41766C2DB8AD9264B9405261F7E33126860D3B78A35F03597876616682DA9558E60D13D2914A18F5BD6CD626A11AD2A28C112166E522EEFC4FFCF9AFCBB29D2A68620DE4884DF812"]];
        
        NSLog(@"----988789-------%@---",[AD_UserDefaults valueForKey:AD_ImageName]);
        if (![imgUrl isEqualToString:[AD_UserDefaults valueForKey:AD_ImageName]]) {
            //新的图片
            NSLog(@"新的图片");
            [self   deleteOldImage];
            //存储图片
            [GiFTool ad_saveImageData:data imagePath:imgUrl];
            //设置新图片
            [AD_UserDefaults setValue:imgUrl forKey:AD_ImageName];
            //设置广告链接
            [AD_UserDefaults setValue:_responseDic[@"url"] forKey:AD_Url];
            
        }else{
            //旧的图片
            NSLog(@"旧的图片");
        }
        
    });
    
}



/**
 *  删除旧图片
 */
- (void)deleteOldImage
{
    
    NSString *imgPath = [GiFTool ad_cacheImagePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:imgPath error:nil];
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end






























