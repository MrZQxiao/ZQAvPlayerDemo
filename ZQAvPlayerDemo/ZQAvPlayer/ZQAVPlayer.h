//
//  ZQFullScreenPlayer.h
//  ZQAvPlayerDemo
//
//  Created by 肖兆强 on 2017/12/5.
//  Copyright © 2017年 ZQDemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZQAvPlayerHeader.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UIUtils.h"
#import "ZQVideoComplexTopBar.h"
#import "ZQVideoComplexControlBar.h"
#import "ZQTouchControlView.h"

@protocol ZQAVPlayerDelegate <NSObject>
@optional

/**
 返回按钮点击
 */
-(void)playerBackBtnClicked;

/**
 播放结束
 */
-(void)playerEnd;

/**
 进入全屏
 */
-(void)go2FullScreen;

/**
 退出全屏
 */
-(void)exitFullScreen;

/**
 屏幕方向改变
 */
-(void)OrienrationChanged:(UIDeviceOrientation)orientation;

/**
 开始播放

 @param seconds 开始播放位置(秒)
 */
-(void)playerStartPlay:(NSInteger)seconds;

/**
 播放中断

 @param seconds 中断播放位置(秒)
 */
-(void)breakEventBecome:(NSInteger)seconds;

/**
 切换地址
 */
-(void)changeEventBecome;

/**
 播放出错
 */
-(void)errorEventBecome;

@end





@interface ZQAVPlayer : UIView<ZQVideoComplexControlBarDelegate,ZQVideoComplexTopBarDelegate,ZQTouchControlViewDelegate>

@property (weak,nonatomic) id<ZQAVPlayerDelegate>delegate;

@property (assign,nonatomic) BOOL locked;


@property (assign,nonatomic) PlaySate currentPlayState;//当前播放状态：播放、暂停、缓冲、重连


/**
 创建播放器
 url：地址
 type：类型 本地或网络
 */
-(instancetype)initWithFrame:(CGRect)frame url:(NSString*)url;



//正片地址
@property (retain,nonatomic) NSString *contentUrl;

@property (retain,nonatomic) NSString* videoTitle;
/**
 观看时长，从打开播放器到退出播放器的时长
 */
@property (assign,nonatomic) float watchTime;
/**
 观看时长，从打开播放器到退出播放器的时长
 */
@property (assign,nonatomic) float sumTime;
@property (strong,nonatomic) NSString *sumtimeNew;
/*
 播放时长，播放到多少秒
 */
@property (assign,nonatomic) float playTime;


/**
 切换播放视频连接
 _url:播放地址
 */
-(void)changeVideoUrl:(NSString*)_url;
/**
 显示/隐藏返回按钮
 */
-(void)showBackBtn:(BOOL)_show;
/**
 是否显示全屏按钮
 */
-(void)showFullScreenBtn:(BOOL)_show;

/**
 进入全屏
 */
-(void)go2FullScreen;

/**
 跳转进度
 */
-(void)seek2PlayTime:(CGFloat)time;
/**
 停止
 */
-(void)stop;
/**
 暂停
 */
-(void)pause;
/**
 播放
 */
-(void)play;



@end
