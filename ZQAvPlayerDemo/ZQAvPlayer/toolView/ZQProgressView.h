//
//  ZQProgressView.h
//  ZQAvPlayerDemo
//
//  Created by 肖兆强 on 2017/12/5.
//  Copyright © 2017年 ZQDemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#define MediaProgressViewHeight 130

typedef NS_ENUM(NSInteger,MediaProgressType)
{
    MediaProgress_brightness,
    MediaProgress_playerTime,
    MediaProgress_volume,
    MediaProgress_loading,
    MedipProgress_locked,
};

@protocol ZQProgressViewDelegate <NSObject>

-(void)unLockedScreen;

@end

@interface ZQProgressView : UIView


@property (weak,nonatomic) id<ZQProgressViewDelegate>delegate;

-(void)showProgressViewType:(MediaProgressType)_type;

-(void)hideProgressView;

-(void)hideLoadingView;

-(void)setProgress:(float)_progress type:(MediaProgressType)_type;

-(void)endDisplay;



@end
