//
//  ZQTouchControlView.h
//  ZQAvPlayerDemo
//
//  Created by 肖兆强 on 2017/12/5.
//  Copyright © 2017年 ZQDemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZQProgressView.h"

typedef NS_ENUM(NSInteger, GestureType){
    GestureTypeOfNone = 0,
    GestureTypeOfVolume,
    GestureTypeOfBrightness,
    GestureTypeOfProgress,
};

@protocol ZQTouchControlViewDelegate <NSObject>
-(float)progressValueDidChanged:(float)value;

- (void)lockedClick:(BOOL)locked;

-(void)touchViewBeginTouchType:(GestureType)_type;
-(void)touchViewEndTouchType:(GestureType)_type;
-(void)touchViewTouchMovedType:(GestureType)_type;
-(void)touchViewDoubleTap;
-(void)touchViewUnlockScreen;

@end
@interface ZQTouchControlView : UIView<ZQProgressViewDelegate,UIGestureRecognizerDelegate>
@property (weak,nonatomic) id<ZQTouchControlViewDelegate>delegate;

@property (assign,nonatomic) BOOL canRespondProgressChange;

@property (assign,nonatomic) BOOL locked;

@property (nonatomic,strong)UIButton *lockBtn;

-(void)startLoadingView;
-(void)endLoadingView;
-(void)enableTouchView;
-(void)showLocked;



@end
