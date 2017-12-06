//
//  ZQFullScreenPlayer.m
//  ZQAvPlayerDemo
//
//  Created by 肖兆强 on 2017/12/5.
//  Copyright © 2017年 ZQDemo. All rights reserved.
//

#import "ZQAVPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "ZQVideoComplexTopBar.h"
#import "ZQVideoComplexControlBar.h"
#import "ZQTouchControlView.h"
#import "UIUtils.h"


@implementation ZQAVPlayer
{
    AVPlayer* _player;//播放器
    
    
    AVPlayerLayer* _playerLayer;//播放器layer
    
    CGRect _normalFrame;//保存正常大小
    
    
    ZQVideoComplexTopBar* _topBar;//标题栏
    
    ZQVideoComplexControlBar* _controlBar;//控制栏
    
    NSTimer* _UITimer;//更新ui的timer
    
    NSTimer* _watchTimer;//计算观看了多长时间
    
    
    NSInteger _hideControlBarSecond;//隐藏controlbar 的时间 5秒后隐藏
    
    PlayerFullScreenState _currentFullScreenState;//全屏小屏
    
    ZQTouchControlView* _touchControlView;//用于响应滑动方法
}

-(instancetype)initWithFrame:(CGRect)frame url:(NSString*)url
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _contentUrl = url;
        NSLog(@"当前播放的url = %@",_contentUrl);
        [self initUI];
        [self initData];
    }
    
    return self;
}



-(void)initUI
{
    self.backgroundColor = [UIColor blackColor];
    [self initPlayer];
    [self initTouchControlView];
    [self initTopBar];
    [self initControlBar];
}



-(void)initPlayer
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    //    NSURL *url = testLocalUrl;
    
    AVPlayerItem* item  = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:_contentUrl]];
    
    _player = [AVPlayer playerWithPlayerItem:item];
    _player.volume = 0.5;
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.frame = self.layer.bounds;
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.layer addSublayer:_playerLayer];
    
    // 添加视频播放结束通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
    //播放失败通知（网络不好/缓冲不足）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidError:) name:AVPlayerItemPlaybackStalledNotification object:_player.currentItem];
    
}

-(void)initTopBar
{
    _topBar = [[ZQVideoComplexTopBar alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, TopBarHeight)];
               
    _topBar.delegate = self;
    [self addSubview:_topBar];
}

-(void)initControlBar
{
    _controlBar = [[ZQVideoComplexControlBar alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - ControlBarHeight, self.bounds.size.width, ControlBarHeight)];
    _controlBar.delegate = self;
    [self addSubview:_controlBar];
}


-(void)setVideoTitle:(NSString *)videoTitle
{
    _videoTitle = videoTitle;
    [_topBar setTitle:videoTitle];
}
#pragma mark -
#pragma mark 工具栏显示和隐藏
-(void)showOrHideBars
{
    if (_locked) {
       
        [self showOrHideLocked];
    }else
    {
        if (_topBar.hidden == true) {
            [self ShowTopAndControBar];
        }else
        {
            [self hideTopAndControBar];
        }
    }
    
}

- (void)showOrHideLocked
{
        _touchControlView.lockBtn.hidden = false;
        
        [UIView animateWithDuration:AnimateDuration animations:^{
            
            _touchControlView.lockBtn.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];

}


-(void)hideTopAndControBar
{
        _hideControlBarSecond = 0;
        
        [UIView animateWithDuration:AnimateDuration animations:^{
            _topBar.alpha = 0;
            _controlBar.alpha = 0;
            if (_currentFullScreenState == fullScreenState_full)
            {
                _touchControlView.lockBtn.alpha = 0;

            }
        } completion:^(BOOL finished) {
            _topBar.hidden = true;
            _controlBar.hidden = true;
            if (_currentFullScreenState == fullScreenState_full)
            {
                _touchControlView.lockBtn.hidden = true;
            }
        }];
        

    
}

-(void)ShowTopAndControBar
{
        _topBar.hidden = false;
        _controlBar.hidden = false;
        if (_currentFullScreenState == fullScreenState_full)
        {
            _touchControlView.lockBtn.hidden = false;

        }
        [UIView animateWithDuration:AnimateDuration animations:^{
            _topBar.alpha = 1;
            _controlBar.alpha = 1;
            if (_currentFullScreenState == fullScreenState_full)
            {
                _touchControlView.lockBtn.alpha = 1;

            }
        } completion:^(BOOL finished) {
     
        }];

}

//快进快退什么的
-(void)initTouchControlView
{
    _touchControlView = [[ZQTouchControlView alloc] initWithFrame:self.bounds];
    _touchControlView.delegate = self;
    [self addSubview:_touchControlView];
}

#pragma mark -



-(void)initData
{
    
    [self startUITimer];
    _currentPlayState = playState_Buffing;//初始化加载状态为缓冲
    _currentFullScreenState = fullScreenState_normal;//初始化为非全屏状态
    _normalFrame = self.frame;
        //旋转通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)startWatchTimer
{
    if (_watchTimer == nil) {
        _watchTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateWatchTime) userInfo:nil repeats:true];
    }
    [_watchTimer setFireDate:[NSDate date]];
}

-(void)startUITimer
{
    _UITimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateUI) userInfo:nil repeats:true];
}

-(void)changePlayerItem
{
    
}

-(void)changeVideoUrl:(NSString*)_url
{
    if (_url.length>0) {
        
        [self breakEventHappend];
        
        _hideControlBarSecond = 0;
        _playTime = 0;
        _watchTime = 0;
        [_touchControlView startLoadingView];
        [self changePlayerCurrentItem:_url];
    }else{
        [UIUtils msgHint:@"请检查视频地址是否正确"];
    }
    
}




-(void)changePlayerCurrentItem:(NSString*)videoUrl
{
    
    AVPlayerItem* newItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:videoUrl]];
   
    [_player replaceCurrentItemWithPlayerItem:newItem];
    [_player play];
    [self changEventHappend];
    [self playEventhappend];
    
    
    
}

#pragma mark -
#pragma mark TopBarDelegate

-(void)topBarBackBtnClicked
{
    if (_currentFullScreenState == fullScreenState_full) {

        [self updateScreenOrientation:UIDeviceOrientationPortrait byFullScreenBtn:true];
    }
    else if (_currentFullScreenState == fullScreenState_normal)
    {
        if ([_delegate respondsToSelector:@selector(playerBackBtnClicked)]) {
            [_delegate performSelector:@selector(playerBackBtnClicked)];
        }
        [self stop];
    }
}


//跳转进度
-(void)seek2PlayTime:(CGFloat)time
{
    [self controlBarSetPlayerCurrentPlaySecond:time];
   
}



#pragma mark -
#pragma mark TouchViewDelegate

- (void)lockedClick:(BOOL)locked
{
    _locked = locked;
    if (_locked) {
        [self hideTopAndControBar];
    }else
    {
        [self showOrHideBars];
    }
}


-(void)touchViewUnlockScreen
{
    _locked = false;
    _touchControlView.locked = false;
}

-(void)touchViewBeginTouchType:(GestureType)_type
{

}

-(void)touchViewTouchMovedType:(GestureType)_type
{

    if (_type == GestureTypeOfProgress) {
        [self breakEventHappend];
    }
}

-(void)touchViewEndTouchType:(GestureType)_type
{
    if (_type == GestureTypeOfProgress) {
        [_controlBar continueProgress];
        [self controlBarSetPlayerCurrentPlaySecond:_controlBar.progress.slider.value];
    }else if (_type == GestureTypeOfNone)
    {
        [self showOrHideBars];
        
    }
}

-(float)progressValueDidChanged:(float)value
{
    [_controlBar pauseProgress];
    _controlBar.progress.slider.value+=value;
    return _controlBar.progress.slider.value;
}

-(void)go2FullScreen
{
    [self updateScreenOrientation:UIDeviceOrientationLandscapeRight byFullScreenBtn:false];
    _currentFullScreenState = fullScreenState_normal;
}

//双击
-(void)touchViewDoubleTap
{
    if (_currentPlayState == playState_Playing) {
        [_controlBar setPlayStatus:true];
        [_player pause];
        _currentPlayState = playState_Pausing;
    }else if (_currentPlayState == playState_Pausing){
        [_controlBar setPlayStatus:false];
        _currentPlayState = playState_Playing;

        [_player play];
    }
    
}

#pragma mark -
#pragma mark ControlBarDelegate

-(void)controlBarSetPlayerPlay:(BOOL)play
{
    if (play) {//播放
        NSLog(@"开始播放");
        [self playEventhappend];
        [_player play];
        _currentPlayState = playState_Playing;
    }else//暂停
    {
        NSLog(@"暂停了");
        [_player pause];
        _currentPlayState = playState_Pausing;
        [self breakEventHappend];
    }
}

-(void)controlBarBtnClick:(ControlBarButtonType)_type
{
    switch (_type) {
        case control_barButton_lock :
            if (_locked == false) {
                _locked = true;
                [_touchControlView showLocked];
                _touchControlView.locked = true;
                [self hideTopAndControBar];
            }else
            {
                _locked = false;
                _touchControlView.locked = false;
            }
            break;
            
        default:
            break;
    }
}

//跳转进度
-(void)controlBarSetPlayerCurrentPlaySecond:(float)second
{
    CMTime changedTime = CMTimeMakeWithSeconds(second, 1);
    [_touchControlView startLoadingView];
    [_controlBar pauseProgress];
    [_player pause];
    [self breakEventHappend];
    _currentPlayState = playState_Pausing;
    [_player seekToTime:changedTime completionHandler:^(BOOL finished) {
        [_player play];
        [self playEventhappend];
        _currentPlayState = playState_Playing;
        [_touchControlView endLoadingView];
        [_controlBar continueProgress];
    }];
}

-(void)controlBarSetPlayerFullScreen:(BOOL)fullScreen
{
    if (_currentFullScreenState == fullScreenState_full) {
        [self updateScreenOrientation:UIDeviceOrientationPortrait byFullScreenBtn:true];
        
    }else
    {
        [self updateScreenOrientation:UIDeviceOrientationLandscapeLeft byFullScreenBtn:true];
        
    }
    if (_currentFullScreenState == fullScreenState_full) {//全屏状态
        [self go2FullScreenPlayer];
    }else if (_currentFullScreenState == fullScreenState_normal)
    {
        [self go2normalPlayer];
    }
}

-(void)controlBarGoBefore
{
    [self changePlayerItem];
}

-(void)controlBarGoNext
{
    
}



#pragma mark For Update UI

-(void)updateUI
{
    //控制控制栏是否隐藏 当在显示状态秒后变位隐藏
    _hideControlBarSecond = _hideControlBarSecond + 1;
    
    if (_hideControlBarSecond>=8) {
        _hideControlBarSecond = 0;
        [self hideTopAndControBar];
    }
    
    CMTime duration = _player.currentItem.duration;// 获取视频总长度
    float timf = CMTimeGetSeconds(duration);
    if (timf > 0) {
        CMTime time = duration;
        NSString *tstr = [NSString stringWithFormat:@"%lld",time.value];
        NSString *tsstr = [NSString stringWithFormat:@"%d",time.timescale];
        NSString *tim = [tstr substringWithRange:NSMakeRange(0, tstr.length - tsstr.length + 1)];
        NSString *s = [tsstr substringWithRange:NSMakeRange(0, 1)];
        self.sumtimeNew = [NSString stringWithFormat:@"%ld",tim.integerValue/s.integerValue];
    }
    
    
    
    //当可以播放的时候设置进度条的最大范围
    //加载完成
    if (_player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        _touchControlView.canRespondProgressChange = true;
        [_controlBar setMaxProgress:duration];
        [_touchControlView endLoadingView];
        //开始计算观看时长的timer
        [self startWatchTimer];
    }
    CGFloat totalSecond = 0;
    //总秒数
    if(duration.timescale!=0)
    {
        totalSecond = duration.value / duration.timescale;
    }
    
    //当前秒数
    CGFloat currentSecond = _player.currentItem.currentTime.value/_player.currentItem.currentTime.timescale;
    
    _playTime = currentSecond;
    
    //计算缓冲进度
    NSTimeInterval timeInterval = [self availableDuration];
    
    
    if (totalSecond == currentSecond && totalSecond!=0){
        
            if ([_delegate respondsToSelector:@selector(playerEnd)]) {
                //播放结束
                [_delegate performSelector:@selector(playerEnd)];
                [_watchTimer setFireDate:[NSDate distantFuture]];

                //                [_UITimer invalidate];
                [self breakEventHappend];
            }
        
    }
    
    //当缓冲秒数超过当前播放秒数3秒后开始播放
    if ((timeInterval - currentSecond) >=3) {
        if (_currentPlayState == playState_reloading) {
            NSLog(@"复播了");
            [_player play];
            
            _currentPlayState = playState_Playing;
        }
    }
    //播放状态默认为buffing 当当前秒数大为0 的时候切换为playing
    if (_currentPlayState == playState_Buffing) {
        if (currentSecond>0) {
            _currentPlayState = playState_Playing;
        }
    }
    
    
    //播放状态的时候隐藏加载提示
    if (_currentPlayState == playState_Playing) {
        
        [_touchControlView endLoadingView];
        
    }
    //更新controlbar的进度条
    [_controlBar updateProgessPlaySecond:currentSecond bufferProgress:timeInterval/totalSecond totalSecond:totalSecond];
}

-(void)updateWatchTime
{
    _watchTime +=1;
   
}

- (NSTimeInterval)availableDuration {
    
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

#pragma mark -
#pragma mark 屏幕旋转控制

-(void)orientationChanged:(NSNotification*)notification{
    
    if (_locked == true) {
        [_touchControlView showLocked];
        return;
    }
    
    UIDeviceOrientation currentOrientation = [[UIDevice currentDevice] orientation];
    NSLog(@"Rouatenofifation.dic = %@",notification.userInfo);
    
    if ([_delegate respondsToSelector:@selector(OrienrationChanged:)]) {
        [_delegate OrienrationChanged:currentOrientation];
    }
    switch(currentOrientation){
        case UIDeviceOrientationPortrait:{
            NSLog(@"正");
            [self updateScreenOrientation:currentOrientation byFullScreenBtn:false];
        }
            break;
        case UIDeviceOrientationLandscapeRight:{
            NSLog(@"右");
            [self updateScreenOrientation:currentOrientation byFullScreenBtn:false];
        }
            break;
        case UIDeviceOrientationLandscapeLeft:{
            NSLog(@"左");
            [self updateScreenOrientation:currentOrientation byFullScreenBtn:false];
        }
            break;
        default:
            break;
    }
}

/**
 在视频播放器中被简化
 */
-(void)updateScreenOrientation:(UIDeviceOrientation)_orientation byFullScreenBtn:(BOOL)_byBtn
{
    BOOL full = true;
    if (_orientation == UIDeviceOrientationPortrait) {
        full = false;
    }
    if (_byBtn) {
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            SEL selector = NSSelectorFromString(@"setOrientation:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation  setTarget:[UIDevice currentDevice]];
            int val  =  full ? UIInterfaceOrientationLandscapeRight : UIInterfaceOrientationPortrait ;
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }
    }
    
   
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    [UIView animateWithDuration:duration animations:^{
        
        
        if (full) {
            _currentFullScreenState = fullScreenState_full;
            CGSize size = [UIUtils fullScreenSize];
            self.frame = CGRectMake(0, 0, size.width, size.height);
            _playerLayer.frame = self.bounds;
            _touchControlView.frame = self.bounds;
            _touchControlView.lockBtn.hidden = false;
            [_topBar setFullScreenStyle:self.bounds];
            [_controlBar setFullScreenStyle:CGRectMake(0, self.bounds.size.height - ControlBarHeight, self.bounds.size.width, ControlBarHeight)];
            [self go2FullScreenPlayer];
        }else
        {
            _currentFullScreenState = fullScreenState_normal;
            self.frame = _normalFrame;
            _playerLayer.frame = self.bounds;
            _touchControlView.frame = self.bounds;
            _touchControlView.lockBtn.hidden = true;
            [_topBar setNormaStyle:CGRectMake(0, 0, self.bounds.size.width, TopBarHeight)];
            [_controlBar setNormaStyle:CGRectMake(0, self.bounds.size.height - ControlBarHeight, self.bounds.size.width, ControlBarHeight)];
            [self go2normalPlayer];
        }
        
    } completion:^(BOOL finished) {
        
        
    }];
}

#pragma mark -
#pragma mark 停止功能

-(void)stop
{
    [_player pause];
    [_UITimer invalidate];
    [_watchTimer invalidate];
    [_touchControlView enableTouchView];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self breakEventHappend];
}

-(void)pause
{
    _currentPlayState = playState_Pausing;
    [_player pause];
    [self breakEventHappend];
    
}

-(void)play
{
    _currentPlayState = playState_Playing;
    [_player play];
    [self playEventhappend];
    
    
}
#pragma mark -
#pragma mark 视频播放通知方法

//视频播放到尾部
- (void)moviePlayDidEnd:(NSNotification *)notification {
    
    
}



//视频播放失败
-(void)moviePlayDidError:(NSNotification*)notification
{
    [_touchControlView startLoadingView];
    NSLog(@"播放失败了");
    NSLog(@"notification = %@",notification);
    [_player pause];
    [UIUtils msgHint:@"请检查视频地址是否正确"];

    _currentPlayState = playState_reloading;
    if ([self.delegate respondsToSelector:@selector(errorEventBecome)]) {
        [self.delegate errorEventBecome];
    }
    
}

-(void)showBackBtn:(BOOL)_show
{
    [_topBar showBackBtn:_show];
}

-(void)showFullScreenBtn:(BOOL)_show
{
    [_controlBar showFullScreenBtn:_show];
}

//响应代理方法
-(void)go2normalPlayer
{
    if ([_delegate respondsToSelector:@selector(exitFullScreen)]) {
        [_delegate performSelector:@selector(exitFullScreen)];
    }
}

-(void)go2FullScreenPlayer
{
    if ([_delegate respondsToSelector:@selector(go2FullScreen)]) {
        [_delegate performSelector:@selector(go2FullScreen) withObject:nil];
    }
    
}

#pragma mark -
#pragma mark 切换播放模式
-(void)changeToLiveStype:(BOOL)_liveStyle
{
    if (_liveStyle) {
        _touchControlView.canRespondProgressChange = false;
        [_controlBar change2LiveStype:true];
    }else
    {
        _touchControlView.canRespondProgressChange = false;
        [_controlBar change2LiveStype:false];
    }
}




-(void)dealloc
{
    
    [self stop];
}
-(void)playEventhappend
{
   
    if ([self.delegate respondsToSelector:@selector(playerStartPlay:)]) {
        CMTime time = _player.currentTime;
        NSInteger sec = CMTimeGetSeconds(time);
        
        [self.delegate playerStartPlay:sec];
    }
}



-(void)breakEventHappend
{
    if ([self.delegate respondsToSelector:@selector(breakEventBecome:)]) {
        CMTime time = _player.currentTime;
        NSInteger sec = CMTimeGetSeconds(time);
        
        [self.delegate breakEventBecome:sec];
    }
    
}
-(void)changEventHappend
{
    if ([self.delegate respondsToSelector:@selector(changeEventBecome)]) {
        [self.delegate changeEventBecome];
    }
}






@end
