//
//  UIUtils.h
//  MediaPlayer
//
//  Created by Apple on 15/9/15.
//  Copyright (c) 2015年 Apple. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ZQAvPlayerHeader.h"
@interface UIUtils : NSObject


+ (void)alertTitle:(NSString*)title withMessage:(NSString *)msg;
+ (void)alertAutoDismiss:(NSString *)title withMessage:(NSString *)msg withTime:(NSTimeInterval)delay;
+ (void)msgHint:(NSString *)msg;
+ (void)msgHint:(NSString *)msg dismissAfter:(NSTimeInterval)delay;
+(UIView*)makeEffectViewWithFrame:(CGRect)frame stype:(UIBlurEffectStyle)style cornerRadius:(float)cornerRadius;


+(NSString*)convertSecond2Time:(int)second;
+(void)AddTestColorToView:(UIView*)view;//添加测试边框
+ (UIColor *) randomColor;//随机色
+(CGSize)fullScreenSize;//全屏范围
+(CGSize)normalScreenSize;

+(UIBarButtonItem*)navBackItemWithTarget:(id)target action:(SEL)action;//返回按钮
//UIbutton
+(UIButton*)makeButtonWithFrame:(CGRect)frame nromalImg:(UIImage*)normalImg selectImg:(UIImage*)selectImg title:(NSString*)title target:(id)target action:(SEL)action events:(UIControlEvents)events;
+(UIImage *)imageFromColor:(UIColor *)color  size:(CGSize)size;
+ (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize;
+ (NSString *)tmpPath;
+(NSString *)currentTimeString;
+(NSString *)stringFromeData:(NSData *)data;
+(unsigned long long)fileSizeWithPath:(NSString *)path;
@end
