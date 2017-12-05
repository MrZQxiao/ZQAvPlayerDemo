//
//  ZQAvPlayerHeader.h
//  ZQAvPlayerDemo
//
//  Created by 肖兆强 on 2017/12/5.
//  Copyright © 2017年 ZQDemo. All rights reserved.
//

#ifndef ZQAvPlayerHeader_h
#define ZQAvPlayerHeader_h

#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define RGB(r,g,b) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1]

#define SelectedColor [UIColor colorWithRed:75/255.0 green:111/255.0 blue:249/255.0 alpha:1]

#define AnimateDuration 0.3f


#define testLocalUrl [[NSBundle mainBundle] URLForResource:@"1" withExtension:@"mp4"]



#ifdef __OBJC__

#endif
//

typedef NS_ENUM(NSInteger, PlaySate)
{
    playState_Buffing,
    playState_Playing,
    playState_Pausing,
    playState_reloading,
};//播放器播放状态

typedef NS_ENUM(NSInteger, PlayerFullScreenState)
{
    fullScreenState_normal,
    fullScreenState_full,
};//播放器全屏状态


typedef NS_ENUM(NSInteger,TopBarButtonType)
{
    topBar_button_default = 0,
    topBar_button_rate = 1,//清晰度
    topBar_button_related = 2,//相关
    topBar_button_sets = 3,//剧集
    topBar_button_drama = 4,//选集
    topBar_button_scale = 5,//比例
    topBar_button_cdnType = 6,//防盗链方式
    topBar_button_jiangYi = 7,//讲义
    topBar_button_count = 8,
};


#endif /* ZQAvPlayerHeader_h */
