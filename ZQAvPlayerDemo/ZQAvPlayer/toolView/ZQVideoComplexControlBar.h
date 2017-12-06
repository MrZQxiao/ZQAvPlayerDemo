//
//  ZQVideoComplexControlBar.h
//  ZQAvPlayerDemo
//
//  Created by 肖兆强 on 2017/12/5.
//  Copyright © 2017年 ZQDemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZQPlayerProgress.h"

typedef NS_ENUM(NSInteger,ControlBarButtonType)
{
    control_barButton_download = 1,
    control_barButton_share = 2,
    control_barButton_praise = 3,
    control_barButton_fav = 4,
    control_barButton_lock = 5,
    control_barButton_Count = 6,
};

@protocol ZQVideoComplexControlBarDelegate <NSObject>

@optional
-(void)controlBarSetPlayerPlay:(BOOL)play;
-(void)controlBarSetPlayerProgress:(float)progress;
-(void)controlBarSetPlayerFullScreen:(BOOL)fullScreen;
-(void)controlBarSetPlayerCurrentPlaySecond:(float)second;
-(void)controlBarBtnClick:(ControlBarButtonType)_type;
//-(void)
-(void)breakEventHappend;
-(void)controlBarGoBefore;
-(void)controlBarGoNext;

@end

#define ControlBarHeight (40 + ProGressHeight)


@interface ZQVideoComplexControlBar : UIView<ZQPlayerProgressDelegate>

{
    ZQPlayerProgress* progress;
}

@property(weak,nonatomic) id<ZQVideoComplexControlBarDelegate>delegate;

@property (retain,nonatomic) ZQPlayerProgress* progress;

//for progress
-(void)updateProgessPlaySecond:(float)playSecond bufferProgress:(float)bufferProgess totalSecond:(float)totalSecond;




-(void)setFullScreenStyle:(CGRect)frame;

-(void)setNormaStyle:(CGRect)frame;

-(void)showBarButtons:(ControlBarButtonType)firstType,...;

-(void)setMaxProgress:(CMTime)time;

-(void)pauseProgress;

-(void)continueProgress;

-(void)change2LiveStype:(BOOL)_liveStyle;

-(void)showFullScreenBtn:(BOOL)show;



-(void)setPlayStatus:(BOOL)status;


@end
