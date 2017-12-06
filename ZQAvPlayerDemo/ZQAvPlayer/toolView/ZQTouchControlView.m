//
//  ZQTouchControlView.m
//  ZQAvPlayerDemo
//
//  Created by 肖兆强 on 2017/12/5.
//  Copyright © 2017年 ZQDemo. All rights reserved.
//

#import "ZQTouchControlView.h"
#define VolumeStep 0.02f
#define BrightnessStep 0.02f
#define MovieProgressStep 5.0f
#define minOffset  5.0f


@implementation ZQTouchControlView
{
    GestureType _gestureType;//滑动屏幕类型、音量、亮度、快进快退、
    
    CGPoint _originalLocation;//保存最后的滑动位置
    
    ZQProgressView* _mediaProgressView;//亮度显示、音量显示、时间进度显示
    

}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //        _canRespondProgressChange = true;
        [self initUI];
    }
    
    
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _mediaProgressView.center = self.center;
    
    CGFloat lockBtnW = 36;
    CGFloat lockBtnY = (self.bounds.size.height - lockBtnW)*0.5;
    CGFloat lockBtnX = 20;
    
    _lockBtn.frame = CGRectMake(lockBtnX, lockBtnY, lockBtnW, lockBtnW);
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapMethod)];
    tap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:tap];
}

-(void)doubleTapMethod
{
    NSLog(@"双击了");
    if ([_delegate respondsToSelector:@selector(touchViewDoubleTap)]) {
        [_delegate performSelector:@selector(touchViewDoubleTap)];
    }
}

-(void)initUI
{
    [self initMediaProgressView];
}

-(void)initMediaProgressView
{
    CGFloat lockBtnW = 36;
    CGFloat lockBtnY = (self.bounds.size.height - lockBtnW)*0.5;
    CGFloat lockBtnX = 20;

    _lockBtn = [[UIButton alloc] initWithFrame:CGRectMake(lockBtnX, lockBtnY, lockBtnW, lockBtnW)];
    [_lockBtn setImage:[UIImage imageNamed:@"bar_button_5"] forState:UIControlStateNormal];
    [_lockBtn setImage:[UIImage imageNamed:@"bar_button_5_selected"] forState:UIControlStateSelected];
    _lockBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [_lockBtn addTarget:self action:@selector(lockedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _lockBtn.selected = NO;
    _lockBtn.hidden = YES;
    _locked = NO;
    [self addSubview:_lockBtn];
    
    
    _mediaProgressView = [[ZQProgressView alloc] initWithFrame:CGRectMake((self.bounds.size.width - MediaProgressViewHeight)/2, (self.bounds.size.height - MediaProgressViewHeight)/2, MediaProgressViewHeight, MediaProgressViewHeight)];
    _mediaProgressView.delegate = self;
    [self addSubview:_mediaProgressView];
    [_mediaProgressView showProgressViewType:MediaProgress_loading];
}

#pragma mark -

- (void)lockedBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.locked = !self.locked;
    if ([self.delegate respondsToSelector:@selector(lockedClick:)]) {
        [self.delegate lockedClick:self.locked];
    }
}

#pragma mark TouchMethods 音量 亮度 进退

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"触摸开始");
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:self];
    _originalLocation = currentLocation;
    
    [_delegate touchViewBeginTouchType:GestureTypeOfNone];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    [_delegate touchViewEndTouchType:GestureTypeOfNone];
    
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:self];
    _originalLocation = currentLocation;
    NSLog(@"触摸结束%0.2f-------%0.2f",_originalLocation.x,_originalLocation.y);
    if (_gestureType == GestureTypeOfNone) {
        //这说明是轻拍收拾，隐藏／现实状态栏
        [_delegate touchViewEndTouchType:GestureTypeOfNone];
    }else if (_gestureType == GestureTypeOfProgress){//跳转进度
        [_mediaProgressView hideProgressView];
        _gestureType = GestureTypeOfNone;
        [_delegate touchViewEndTouchType:GestureTypeOfProgress];
        
    }else if(_gestureType == GestureTypeOfBrightness) {
        _gestureType = GestureTypeOfNone;
        [_mediaProgressView hideProgressView];
    }else if (_gestureType == GestureTypeOfVolume)
    {
        NSLog(@"音量调节结束");
        _gestureType = GestureTypeOfNone;
        [_mediaProgressView hideProgressView];
        
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    NSLog(@"移动中。。。");
    [_delegate touchViewTouchMovedType:GestureTypeOfNone];
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:self];
    CGFloat offset_x = currentLocation.x - _originalLocation.x;//横向偏移量
    CGFloat offset_y = currentLocation.y - _originalLocation.y;//纵向偏移量
    NSLog(@"x偏移量 = %f",offset_x);
    NSLog(@"y偏移量 = %f",offset_y);
    if (CGPointEqualToPoint(_originalLocation,CGPointZero)) {
        _originalLocation = currentLocation;
        return;
    }
    
    CGRect frame = self.bounds;

    
    if (ABS(offset_x)<10&&ABS(offset_y)<10) {
        _gestureType = GestureTypeOfNone;

    }else{
        
        if (_locked == true) {
            
            [self showLocked];
            return;
        }
        /**
         上下滑动：纵向偏移>横向偏移 offset_y>offset_x
         左右滑动：横向偏移>纵向偏移 offset_x>offset_y
         */
        
        //    if (_gestureType == GestureTypeOfNone) {
        if ((currentLocation.x > frame.size.width*0.7) && (ABS(offset_x) <= ABS(offset_y)))
        {
            _gestureType = GestureTypeOfVolume;
            
            NSLog(@"右侧——音量");
        }else if ((currentLocation.x < frame.size.width*0.3) && (ABS(offset_x) <= ABS(offset_y)))
        {
            _gestureType = GestureTypeOfBrightness;
            
            NSLog(@"左侧——亮度");
        }else if ((ABS(offset_x) >= ABS(offset_y))) {
            if (_canRespondProgressChange && ABS(offset_x) > minOffset) {
                NSLog(@"中间——进度");
                
                _gestureType = GestureTypeOfProgress;
            }else
            {
                _gestureType = GestureTypeOfNone;
            }
            
            
        }
        
        
    }
    

    //    }
    if ((_gestureType == GestureTypeOfProgress) && (ABS(offset_x) > ABS(offset_y))) {
        float progress;
        if (offset_x > minOffset) {
            NSLog(@"横向向右%0.2f",offset_x);
            [_mediaProgressView showProgressViewType:MediaProgress_playerTime];
            progress = [_delegate progressValueDidChanged:+1];
            [_mediaProgressView setProgress:progress type:MediaProgress_playerTime];
        }else if (ABS(offset_x) > minOffset){
            NSLog(@"横向向左%0.2f",offset_x);
            [_mediaProgressView showProgressViewType:MediaProgress_playerTime];
            progress = [_delegate progressValueDidChanged:-1];
            [_mediaProgressView setProgress:progress type:MediaProgress_playerTime];
        }
        
    }else if ((_gestureType == GestureTypeOfVolume) && (currentLocation.x > frame.size.width*0.7) && (ABS(offset_x) <= ABS(offset_y))){
        if (offset_y > minOffset){
            NSLog(@"右侧向下");
            [_mediaProgressView showProgressViewType:MediaProgress_volume];
            [self volumeAdd:-VolumeStep];
        }else if (ABS(offset_y) > minOffset){
            [_mediaProgressView showProgressViewType:MediaProgress_volume];
            [self volumeAdd:VolumeStep];
            NSLog(@"右侧向上");
        }
    }else if ((_gestureType == GestureTypeOfBrightness) && (currentLocation.x < frame.size.width*0.3) && (ABS(offset_x) <= ABS(offset_y))){
        if (offset_y > minOffset) {
            NSLog(@"左侧向下");
            [_mediaProgressView showProgressViewType:MediaProgress_brightness];
            [self brightnessAdd:-BrightnessStep];
        }else if (ABS(offset_y) > minOffset){
            NSLog(@"左侧向上");
            [_mediaProgressView showProgressViewType:MediaProgress_brightness];
            [self brightnessAdd:BrightnessStep];
        }
    }
}


//声音增加
- (void)volumeAdd:(CGFloat)step{
    [_mediaProgressView setProgress:step type:MediaProgress_volume];
}

//亮度增加
- (void)brightnessAdd:(CGFloat)step{
    [UIScreen mainScreen].brightness += step;
    [_mediaProgressView setProgress:[UIScreen mainScreen].brightness type:MediaProgress_brightness];
}


-(void)startLoadingView
{
    [_mediaProgressView showProgressViewType:MediaProgress_loading];
}

-(void)endLoadingView
{
    [_mediaProgressView hideLoadingView];
}


-(void)enableTouchView
{
    [_mediaProgressView endDisplay];
}

-(void)unLockedScreen
{
    if ([_delegate respondsToSelector:@selector(touchViewUnlockScreen)]) {
        [_delegate performSelector:@selector(touchViewUnlockScreen)];
    }
}




-(void)showLocked
{
    [_mediaProgressView showProgressViewType:MedipProgress_locked];
}


@end
