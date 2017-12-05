//
//  ZQPlayerProgress.h
//  ZQAvPlayerDemo
//
//  Created by 肖兆强 on 2017/12/5.
//  Copyright © 2017年 ZQDemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#define ProGressHeight 25

@protocol ZQPlayerProgressDelegate <NSObject>

-(void)seekToSecond:(float)second;

@end


@interface ZQPlayerProgress : UIView
{
    UISlider* slider;
}
@property (assign,nonatomic) float playSecond;
@property (assign,nonatomic) float bufferProgess;
@property (retain,nonatomic) UISlider* slider;
@property (weak,nonatomic) id<ZQPlayerProgressDelegate>delegate;
-(void)setMaxTime:(CMTime)duration;

@end
