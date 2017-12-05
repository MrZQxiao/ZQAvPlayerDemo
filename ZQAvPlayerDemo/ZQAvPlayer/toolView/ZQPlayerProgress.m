//
//  ZQPlayerProgress.m
//  ZQAvPlayerDemo
//
//  Created by 肖兆强 on 2017/12/5.
//  Copyright © 2017年 ZQDemo. All rights reserved.
//

#import "ZQPlayerProgress.h"
#import "ZQAvPlayerHeader.h"

@implementation ZQPlayerProgress
{
    UIProgressView* _progressView;
}
@synthesize slider;

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _progressView.frame = CGRectMake(2, self.bounds.size.height/2-0.5, self.bounds.size.width-2, self.bounds.size.height/2);
    slider.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
}


-(void)initUI
{
    //缓冲进度条
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(2, (self.bounds.size.height-2)/2, self.bounds.size.width, self.bounds.size.height/2)];
    [_progressView setTrackTintColor:RGB(11, 15, 18)];
    [_progressView setProgressTintColor:RGB(70, 71, 70)];
    [self addSubview:_progressView];
    
    //播放滑动条
    slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [slider setThumbImage:[UIImage imageNamed:@"video_slider_normal"] forState:UIControlStateNormal];
    [slider setThumbImage:[UIImage imageNamed:@"video_slider_highted"] forState:UIControlStateHighlighted];
    //    [slider setMinimumTrackImage:[UIImage imageNamed:@"progressSlider_thum_mini"] forState:UIControlStateNormal];
    [slider setMinimumTrackTintColor:RGB(58, 167, 251)];
    [slider setMaximumTrackTintColor:[UIColor clearColor]];
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    slider.continuous = false;
    [self addSubview:slider];
}

-(void)setPlaySecond:(float)playSecond//播放进度条
{
    if (!slider.isTracking) {
        slider.value = playSecond;
    }
}

-(void)setBufferProgess:(float)bufferProgess//更新缓冲进度
{
    _progressView.progress = bufferProgess;
}

-(void)setMaxTime:(CMTime)duration
{
    if (duration.value == 0) {
        return;
    }
    
    float second = CMTimeGetSeconds(duration);
    
    if (slider.maximumValue == second) {
        return;
    }
    NSLog(@"总时长：%f",second);
    slider.maximumValue = second;
}

-(void)sliderValueChanged:(UISlider*)sender
{
    NSLog(@"跳转到了%fs",sender.value);
    
    if ([_delegate respondsToSelector:@selector(seekToSecond:)]) {
        [_delegate seekToSecond:sender.value];
    }
}




@end
