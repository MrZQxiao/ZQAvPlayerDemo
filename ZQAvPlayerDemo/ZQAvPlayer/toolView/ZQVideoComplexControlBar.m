//
//  ZQVideoComplexControlBar.m
//  ZQAvPlayerDemo
//
//  Created by 肖兆强 on 2017/12/5.
//  Copyright © 2017年 ZQDemo. All rights reserved.
//

#import "ZQVideoComplexControlBar.h"
#import "UIUtils.h"
#import "ZQButton.h"



@implementation ZQVideoComplexControlBar
{
    UIView* _backView;
    UIButton* _playBtn;
    UILabel* _playTimeLabel;
    ZQButton* _fullScreenBtn;
    UIButton* _lockBtn;
    
    
    UIView* _optionView;
    
    BOOL _pauseProgress;
    
}

@synthesize progress;

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    //    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    
    //半透明背景
    //    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, ProGressHeight/2, self.bounds.size.width, self.bounds.size.height - ProGressHeight/2)];
    //    _backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    _backView = [UIUtils makeEffectViewWithFrame:CGRectMake(0, ProGressHeight/2, self.bounds.size.width, self.bounds.size.height - ProGressHeight/2) stype:UIBlurEffectStyleDark cornerRadius:0];
    [self addSubview:_backView];
    
    
    float margin = 10;
    float btnHeight = ControlBarHeight - ProGressHeight - margin;
    
    progress = [[ZQPlayerProgress alloc] initWithFrame:CGRectMake(0,0, self.bounds.size.width, ProGressHeight)];
    progress.delegate = self;
    [self addSubview:progress];
    
    
    float viewY =  ProGressHeight;
    
    _playBtn = [[UIButton alloc] initWithFrame:CGRectMake(margin,viewY , btnHeight, btnHeight)];
    _playBtn.showsTouchWhenHighlighted = true;
    [_playBtn addTarget:self action:@selector(playBtnMethod:) forControlEvents:UIControlEventTouchDown];
    [_playBtn setImage:[UIImage imageNamed:@"btn_pause_nomal"] forState:UIControlStateNormal];
    [_playBtn setImage:[UIImage imageNamed:@"btn_play_nomal"] forState:UIControlStateSelected];
    
    [self addSubview:_playBtn];
    
    _playTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(2*margin+btnHeight, viewY, 100, btnHeight)];
    _playTimeLabel.font = [UIFont systemFontOfSize:13];
    _playTimeLabel.adjustsFontSizeToFitWidth = true;
    _playTimeLabel.textColor = [UIColor whiteColor];
    _playTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_playTimeLabel];
    
    _fullScreenBtn = [[ZQButton alloc] initWithFrame:CGRectMake(self.bounds.size.width-margin-btnHeight, viewY, btnHeight, btnHeight)];
    [_fullScreenBtn setImage:[UIImage imageNamed:@"btn_2large_normal"] forState:UIControlStateNormal];
    [_fullScreenBtn setImage:[UIImage imageNamed:@"btn_2small_normal"] forState:UIControlStateSelected];
    [_fullScreenBtn addTarget:self action:@selector(fullScreenMethod:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:_fullScreenBtn];
    
   
    
    [self initOptionView];
    
    //    [UIUtils AddTestColorToView:self];
}

-(void)showFullScreenBtn:(BOOL)show
{
    _fullScreenBtn.hidden = !show;
}

#pragma mark -
#pragma mark 功能view

-(void)showBarButtons:(ControlBarButtonType)firstType,...
{
    va_list args;
    va_start(args, firstType);
    for (ControlBarButtonType type = firstType; type < control_barButton_Count && type!=0; type = va_arg(args,ControlBarButtonType)) {
        NSLog(@"type = %ld",type);
        [self optionViewInsertButtonWithType:type];
    }
    va_end(args);
}

-(void)initOptionView
{
    _optionView = [[UIView alloc] init];
    _optionView.hidden = true;
    [self addSubview:_optionView];
}

-(void)optionViewInsertButtonWithType:(ControlBarButtonType)type
{
    float margin = 10;
    float btnHeight = ControlBarHeight - ProGressHeight - margin;
    NSUInteger count = _optionView.subviews.count;
    
    //    //更新optionview的frame
    //    float optionWidth = (count+1)*btnHeight+(count)*margin;
    //    float opthinX = _fullScreenBtn.frame.origin.x - optionWidth;
    //    _optionView.frame = CGRectMake(opthinX, ProGressHeight, optionWidth, btnHeight);
    
    //创建一个button 新的放在最后面
    ZQButton *button = [[ZQButton alloc] init];
    button.frame = CGRectMake(count*btnHeight + count*margin, 0, btnHeight, btnHeight);
    button.tag = type;
    [button addTarget:self action:@selector(optionBarButtonClick:) forControlEvents:UIControlEventTouchDown];
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"bar_button_%ld",(long)type]] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"bar_button_%ld_selected",(long)type]] forState:UIControlStateSelected];
    [_optionView addSubview:button];
    
    if (type == control_barButton_lock ) {
        _lockBtn = button;
    }
    
    //    [UIUtils AddTestColorToView:_optionView];
    
}

-(void)playBtnMethod:(ZQButton*)sender
{
    if ([_delegate respondsToSelector:@selector(controlBarSetPlayerPlay:)]) {
        [_delegate controlBarSetPlayerPlay:sender.selected];
    }
    if (sender.selected == false) {
        sender.selected = true;//暂停
    }else
    {
        sender.selected = false;//播放
    }
}

-(void)fullScreenMethod:(ZQButton*)sender
{
    if (sender.selected == true) {
        sender.selected = false;
        NSLog(@"退出全屏");
    }else
    {
        NSLog(@"进入全屏");
        sender.selected = true;
    }
    
    if ([_delegate respondsToSelector:@selector(controlBarSetPlayerFullScreen:)]) {
        [_delegate controlBarSetPlayerFullScreen:sender.selected];
    }
}

//更新缓冲和播放进度
-(void)updateProgessPlaySecond:(float)playSecond bufferProgress:(float)bufferProgess totalSecond:(float)totalSecond
{
    
    if (!_pauseProgress) {
        progress.playSecond = playSecond;
    }
    
    progress.bufferProgess = bufferProgess;
    
    
    NSString* totalTimeStr = [UIUtils convertSecond2Time:totalSecond];
    NSString* currentTimeStr = [UIUtils convertSecond2Time:playSecond];
    
    _playTimeLabel.text = [NSString stringWithFormat:@"%@/%@",currentTimeStr,totalTimeStr];
}

-(void)setMaxProgress:(CMTime)time;
{
    [progress setMaxTime:time];
}

#pragma mark -
#pragma mark ProgtessDelegate

-(void)seekToSecond:(float)second
{
    if ([_delegate respondsToSelector:@selector(breakEventHappend)]) {
        [_delegate breakEventHappend];
        
    }
    if ([_delegate respondsToSelector:@selector(controlBarSetPlayerCurrentPlaySecond:)]) {
        [_delegate controlBarSetPlayerCurrentPlaySecond:second];
        
    }
    
}

-(void)pauseProgress
{
    _pauseProgress = true;
}

-(void)continueProgress
{
    _pauseProgress = false;
}

#pragma mark -
#pragma mark OptionalBtnsMethod

-(void)optionBarButtonClick:(ZQButton*)sender
{
    if ([_delegate respondsToSelector:@selector(controlBarBtnClick:)]) {
        [_delegate controlBarBtnClick:sender.tag];
    }
    switch (sender.tag) {
        case control_barButton_download:
        {
            [UIUtils msgHint:@"下载"];
        }
            break;
        case control_barButton_share:
        {
            [UIUtils msgHint:@"分享"];
        }
            break;
        case control_barButton_praise:
        {
            [UIUtils msgHint:@"点赞"];
        }
            break;
        case control_barButton_fav:
        {
            [UIUtils msgHint:@"收藏"];
        }
            break;
        case control_barButton_lock:
        {
            if (sender.selected == false) {
                //                [UIUtils msgHint:@"上锁"];
                sender.selected = true;
            }else if(sender.selected == true)
            {
                //                [UIUtils msgHint:@"开锁"];
                sender.selected = false;
            }
        }
            break;
            
        default:
            break;
    }
}



#pragma mark -
#pragma mark 切换全屏/小屏

-(void)setFullScreenStyle:(CGRect)frame
{
    self.frame = frame;
    _backView.frame = CGRectMake(0, ProGressHeight/2, self.bounds.size.width, self.bounds.size.height - ProGressHeight/2);
    
    float margin = 10;
    float btnHeight = ControlBarHeight - ProGressHeight - margin;
    float viewY =  ProGressHeight;
    
    //    _playBtn.frame = CGRectMake(btnHeight+2*margin, viewY, btnHeight, btnHeight);
    //    _goBeforeBtn.frame = CGRectMake(margin, viewY, btnHeight, btnHeight);
    //    _goBeforeBtn.hidden = false;
    //    _goNextBtn.frame = CGRectMake(2*btnHeight + 3*margin, viewY, btnHeight, btnHeight);
    //    _goNextBtn.hidden = false;
    
    _optionView.hidden = false;
    
    
    
    _fullScreenBtn.frame = CGRectMake(self.bounds.size.width-margin-btnHeight, viewY, btnHeight, btnHeight);
    _fullScreenBtn.selected = true;
    
    //功能栏
    NSUInteger count = _optionView.subviews.count;
    float optionWidth = count*btnHeight + count*margin;
    float opthinX = _fullScreenBtn.frame.origin.x - optionWidth;
    _optionView.frame = CGRectMake(opthinX, ProGressHeight, optionWidth, btnHeight);
    
    float timeLabelWidth = 100; //opthinX - (_goNextBtn.frame.origin.x+_goNextBtn.frame.size.width)  - 2*margin;
    
    
    float timeLabelX = 1*btnHeight+2*margin;
    _playTimeLabel.frame = CGRectMake(timeLabelX, viewY, timeLabelWidth, btnHeight);
    float progressX = timeLabelX + timeLabelWidth + margin;
    float progressWidth = opthinX - progressX - 2*margin;
    progress.frame = CGRectMake(progressX, viewY, progressWidth, ProGressHeight);
    
}

-(void)setNormaStyle:(CGRect)frame
{
    
    self.frame = frame;
    
    //隐藏optionview
    
    
    //半透明背景
    _backView.frame = CGRectMake(0, ProGressHeight/2, self.bounds.size.width, self.bounds.size.height - ProGressHeight/2);
    _optionView.hidden = true;
    
    float margin = 10;
    float btnHeight = ControlBarHeight - ProGressHeight - margin;
    float viewY =  ProGressHeight;
    
    //    _playBtn.frame = CGRectMake(margin, viewY, btnHeight, btnHeight);
    
    progress.frame = CGRectMake(0,0, self.bounds.size.width, ProGressHeight);
    
    //    _playBtn.frame = CGRectMake(margin,viewY , btnHeight, btnHeight);
    //    _goNextBtn.hidden = true;
    //    _goBeforeBtn.hidden = true;
    
    //    [self addSubview:_playBtn];
    
    _playTimeLabel.frame = CGRectMake(2*margin+btnHeight, viewY, 100, btnHeight);
    
    _fullScreenBtn.frame = CGRectMake(self.bounds.size.width-margin-btnHeight, viewY, btnHeight, btnHeight);
    _fullScreenBtn.selected = false;
}

-(void)change2LiveStype:(BOOL)_liveStyle
{
    if (_liveStyle) {
        progress.hidden = true;
        _playTimeLabel.hidden = true;
    }else
    {
        progress.hidden = false;
        _playTimeLabel.hidden = false;
    }
}



-(void)goBehindOrForward:(ZQButton*)sender
{
    switch (sender.tag) {
        case 1:
        {
            [UIUtils msgHint:@"上一个"];
            
            if ([_delegate respondsToSelector:@selector(controlBarGoBefore)]) {
                [_delegate performSelector:@selector(controlBarGoBefore)];
            }
        }
            break;
        case 2:
        {
            [UIUtils msgHint:@"下一个"];
            
            if ([_delegate respondsToSelector:@selector(controlBarGoNext)]) {
                [_delegate performSelector:@selector(controlBarGoNext)];
            }
        }
            break;
            
        default:
            break;
    }
}

/**
 更新锁定按钮状态
 */
-(void)setLocked:(BOOL)_locked
{
    _lockBtn.selected = _locked;
}


@end
