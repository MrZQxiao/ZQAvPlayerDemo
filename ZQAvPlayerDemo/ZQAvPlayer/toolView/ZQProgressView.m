//
//  ZQProgressView.m
//  ZQAvPlayerDemo
//
//  Created by 肖兆强 on 2017/12/5.
//  Copyright © 2017年 ZQDemo. All rights reserved.
//

#import "ZQProgressView.h"
#import "UIUtils.h"

@implementation ZQProgressView
{
    UIProgressView* _brightNessProgress;
    UIProgressView* _volumeProgress;
    UILabel* _playerTimeLabel;
    UISlider* _volumeSlider;
    UIActivityIndicatorView *_activityView;//加载动画
    UIButton* _lockedBtn;
    
    UIView* _brightNessView;//亮度
    UIView* _playerTimeView;//快进时间
    UIView* _volumeView;//声音
    UIView* _loadingView;//加载提示
    UIView* _lockedView;
    
    //保存初始化时的亮度、音量
    float _systemVolume;
    float _systemBrightness;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        [self initData];
    }
    return self;
}

-(void)initUI
{
    //初始化视图
    [self initBrightNessView];
    [self initVolumeView];
    [self initPlayerTimeView];
    [self initLoadingView];
    [self initLockedView];
    
    //    [UIUtils AddTestColorToView:self];
}



-(void)initData
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    _systemBrightness = [UIScreen mainScreen].brightness;
    _systemVolume = _volumeSlider.value;
}


#pragma mark -
#pragma mark For UI

-(void)initBrightNessView
{
    _brightNessView = [[UIView alloc] initWithFrame:self.bounds];
    _brightNessView.hidden = true;
    [self addSubview:_brightNessView];
    
    //毛玻璃效果
    [_brightNessView addSubview:[UIUtils makeEffectViewWithFrame:_brightNessView.bounds stype:UIBlurEffectStyleExtraLight cornerRadius:10]];
    
    float margin = 30;
    float progressHeight = 10;
    float logoWidth = _brightNessView.bounds.size.width - 2*margin;
    
    UIImageView* logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(margin, margin, logoWidth, logoWidth)];
    logoImg.image = [UIImage imageNamed:@"progress_brightness_logo"];
    [_brightNessView addSubview:logoImg];
    
    _brightNessProgress = [[UIProgressView alloc]initWithFrame:CGRectMake(10 , margin+logoWidth+10, _brightNessView.bounds.size.width-20, progressHeight)];
    [_brightNessProgress setTrackTintColor:[UIColor grayColor]];
    [_brightNessProgress setProgressTintColor:[UIColor whiteColor]];
    _brightNessProgress.progress = [UIScreen mainScreen].brightness;
    [_brightNessView addSubview:_brightNessProgress];
}

//初始化音量视图
-(void)initVolumeView
{
    //初始化改变系统音量的模块
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    volumeView.frame = CGRectMake(-1000, -1000, 100, 100);
    [self addSubview:volumeView];
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _volumeSlider = (UISlider*)view;
            break;
        }
    }
    
    _volumeView = [[UIView alloc] initWithFrame:self.bounds];
    _volumeView.hidden = true;
    [self addSubview:_volumeView];
    
    [_volumeView addSubview:[UIUtils makeEffectViewWithFrame:_volumeView.bounds stype:UIBlurEffectStyleExtraLight cornerRadius:10]];
    
    float margin = 30;
    float progressHeight = 10;
    float logoWidth = _volumeView.bounds.size.width - 2*margin;
    
    UIImageView* logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(margin, margin, logoWidth, logoWidth)];
    logoImg.image = [UIImage imageNamed:@"progress_volume_logo"];
    [_volumeView addSubview:logoImg];
    _volumeProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(10 , margin+logoWidth+10, _volumeView.bounds.size.width-20, progressHeight)];
    [_volumeProgress setTrackTintColor:[UIColor grayColor]];
    [_volumeProgress setProgressTintColor:[UIColor whiteColor]];
    _volumeProgress.progress = _volumeSlider.value;
    [_volumeView addSubview:_volumeProgress];
}

//初始化快进退视图
-(void)initPlayerTimeView
{
    _playerTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.width/4, self.bounds.size.width, self.bounds.size.height/2)];
    _playerTimeView.hidden = true;
    [self addSubview:_playerTimeView];
    
    [_playerTimeView addSubview:[UIUtils makeEffectViewWithFrame:_playerTimeView.bounds stype:UIBlurEffectStyleDark cornerRadius:_playerTimeView.bounds.size.height/2]];
    
    //时间label
    _playerTimeLabel = [[UILabel alloc] initWithFrame:_playerTimeView.bounds];
    _playerTimeLabel.textColor = [UIColor whiteColor];
    _playerTimeLabel.textAlignment = NSTextAlignmentCenter;
    _playerTimeLabel.font = [UIFont boldSystemFontOfSize:25];
    [_playerTimeView addSubview:_playerTimeLabel];
}

//创建加载提示
-(void)initLoadingView
{
    _loadingView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width/4, self.bounds.size.height/4, self.bounds.size.width/2, self.bounds.size.height/2)];
    _loadingView.hidden = true;
    [self addSubview:_loadingView];
    
    [_loadingView addSubview:[UIUtils makeEffectViewWithFrame:_loadingView.bounds stype:UIBlurEffectStyleDark cornerRadius:10]];
    
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityView.frame = _loadingView.bounds;
    [_activityView startAnimating];
    [_loadingView addSubview:_activityView];
    
}


-(void)initLockedView
{
    _lockedView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width/4, self.bounds.size.height/4, self.bounds.size.width/2, self.bounds.size.height/2)];
    _lockedView.hidden = true;
    [_lockedView addSubview:[UIUtils makeEffectViewWithFrame:_lockedView.bounds stype:UIBlurEffectStyleDark cornerRadius:10]];
    [self addSubview:_lockedView];
    
    _lockedBtn = [[UIButton alloc] initWithFrame:_lockedView.bounds];
    [_lockedBtn setImage:[UIImage imageNamed:@"bar_button_5"] forState:UIControlStateNormal];
    [_lockedBtn addTarget:self action:@selector(unLockPlayer) forControlEvents:UIControlEventTouchUpInside];
    [_lockedBtn setImage:[UIImage imageNamed:@"bar_button_5_selected"] forState:UIControlStateSelected];
    _lockedBtn.selected = true;
    [_lockedView addSubview:_lockedBtn];
}


#pragma mark -
#pragma mark For Control

/**
 显示提示view
 */
-(void)showProgressViewType:(MediaProgressType)_type
{
    [self hideProgressView];
    switch (_type) {
        case MediaProgress_brightness:
            _brightNessView.hidden = false;
            break;
        case MediaProgress_volume:
            _volumeView.hidden = false;
            break;
        case MediaProgress_playerTime:
            _playerTimeView.hidden = false;
            break;
        case MediaProgress_loading:
            _loadingView.hidden = false;
            break;
        case MedipProgress_locked:
            [self showLockeView];
            break;
            
        default:
            break;
    }
}
/**
 隐藏加载提示
 */

-(void)hideLoadingView
{
    _loadingView.hidden = true;
}


//隐藏所有view
-(void)hideProgressView
{
    _brightNessView.hidden = true;
    _volumeView.hidden = true;
    _playerTimeView.hidden = true;
    _loadingView.hidden = true;
    _lockedView.hidden = true;
}

//更新UI

-(void)setProgress:(float)_progress type:(MediaProgressType)_type
{
    switch (_type) {
        case MediaProgress_brightness:
            _brightNessProgress.progress = _progress;
            break;
        case MediaProgress_volume:
            _volumeProgress.progress  += _progress;
            _volumeSlider.value += _progress;
            break;
        case MediaProgress_playerTime:
            _playerTimeLabel.text = [UIUtils convertSecond2Time:_progress];
            break;
        case MediaProgress_loading:
            
            break;
            
        default:
            break;
    }
}

//接收通知方法
-(void)volumeChanged:(NSNotification*)notification
{
    //    NSLog(@"音量notifaication = %@",notification);
    //    NSDictionary* info = notification.userInfo;
    //    float volume = [[info objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    //    _volumeProgress.progress = volume;
    //    [self showProgressViewType:progress_volume];
    //    [self performSelector:@selector(hideProgressView) withObject:nil afterDelay:3];
}

-(void)endDisplay
{
    //恢复系统音量
    //    [UIScreen mainScreen].brightness = _systemBrightness;
    //    _volumeSlider.value = _systemVolume;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//解锁播放器
-(void)unLockPlayer
{
    _lockedBtn.selected = true;
    if ([_delegate respondsToSelector:@selector(unLockedScreen)]) {
        [_delegate performSelector:@selector(unLockedScreen)];
    }
    [self performSelector:@selector(hideLoadingView) withObject:nil afterDelay:1];
}

-(void)showLockeView
{
    _lockedView.hidden = false;
    [self performSelector:@selector(hideLockView) withObject:nil afterDelay:1];
}

-(void)hideLockView
{
    _lockedView.hidden = true;
}




@end
