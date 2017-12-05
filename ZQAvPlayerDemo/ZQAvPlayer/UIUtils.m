//
//  UIUtils.m
//  MediaPlayer
//
//  Created by Apple on 15/9/15.
//  Copyright (c) 2015年 Apple. All rights reserved.
//
#define Color_RGB(r,g,b,a) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]

#import "UIUtils.h"

@implementation UIUtils

+ (void)alertTitle:(NSString *)title withMessage:(NSString *)msg {
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:title
                          message:msg
                          delegate:nil
                          cancelButtonTitle:@"确   定"
                          otherButtonTitles:nil];
    [alert show];
}

+ (void)alertAutoDismiss:(NSString *)title withMessage:(NSString *)msg withTime:(NSTimeInterval)delay{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil
                          ];
    
    [alert show];
    
    [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:delay];
}

+ (void) dismissAlert:(UIAlertView *)alert
{
    if(alert)
    {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}


+ (void)msgHint:(NSString *)msg {
    
    NSArray *windows = [UIApplication sharedApplication].windows;
    UIWindow *window;
    if ([windows count] > 1) {
        window = [windows objectAtIndex:1];
    } else {
        window = [windows objectAtIndex:0];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    
    CGSize size  = [self sizeWithString:msg font:hud.label.font maxSize:CGSizeMake(hud.label.frame.size.height, 100)];
    hud.label.bounds = CGRectMake(0, 0, size.width, size.height);
    hud.label.text = msg;
    hud.label.numberOfLines = 4;
    hud.label.textColor = [UIColor whiteColor];
    hud.margin = 20.0f;
    hud.offset = CGPointMake(0, 25);
    
    hud.bezelView.color = Color_RGB(1, 1, 1, 0.8);
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.removeFromSuperViewOnHide = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES afterDelay:1.5];
    });
    
}

+ (void)msgHint:(NSString *)msg dismissAfter:(NSTimeInterval)delay {
    
    NSArray *windows = [UIApplication sharedApplication].windows;
    UIWindow *window;
    if ([windows count] > 1) {
        window = [windows objectAtIndex:1];
    } else {
        window = [windows objectAtIndex:0];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    
    CGSize size  = [self sizeWithString:msg font:hud.label.font maxSize:CGSizeMake(hud.label.frame.size.height, 100)];
    hud.label.bounds = CGRectMake(0, 0, size.width, size.height);
    hud.label.text = msg;
    hud.label.numberOfLines = 0;
    hud.label.textColor = [UIColor whiteColor];
    hud.margin = 20.0f;
    hud.offset = CGPointMake(0, 25);
    
    hud.bezelView.color = Color_RGB(1, 1, 1, 0.8);
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.removeFromSuperViewOnHide = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES afterDelay:delay];
    });
    
}


+(CGSize)fullScreenSize{
    CGSize size = [UIScreen mainScreen].bounds.size;
    if (size.width>size.height) {
        return size;
    }
    else{
        return CGSizeMake(size.height, size.width);
    }
}

+(CGSize)normalScreenSize
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    size = size.width<size.height ? size : CGSizeMake(size.height, size.width);
    
    return size;
    
}
//随机色
+(UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}



//添加测试线条

+(void)AddTestColorToView:(UIView*)view
{
    [self addBorder:view];
    for (UIView* view1 in view.subviews) {
        [self addBorder:view1];
        for (UIView* view2 in view1.subviews) {
            [self addBorder:view2];
            for (UIView* view3 in view2.subviews) {
                [self addBorder:view3];
                for (UIView* view4 in view3.subviews) {
                    [self addBorder:view4];
                    for (UIView* view5 in view4.subviews) {
                        [self addBorder:view5];
                    }
                }
            }
        }
    }
}

+(UIView*)makeEffectViewWithFrame:(CGRect)frame stype:(UIBlurEffectStyle)style cornerRadius:(float)cornerRadius;
{
    UIView* view;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
        //毛玻璃效果
        UIBlurEffect* effect = [UIBlurEffect effectWithStyle:style];
        UIVisualEffectView* effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        if (cornerRadius) {
            effectView.layer.cornerRadius = cornerRadius;
            effectView.layer.masksToBounds = true;
        }
        effectView.frame = frame;
        view = effectView;
    }else
    {
        view = [[UIView alloc] initWithFrame:frame];
        view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        view.layer.cornerRadius = cornerRadius;
    }
    return view;
}

+(void)addBorder:(UIView*)view
{
    UIColor* color = [self randomColor];
    view.layer.borderColor = color.CGColor;
    view.layer.borderWidth = 1;
}

#pragma mark -
#pragma mark Second - Time

+(NSString *)convertSecond2Time:(int)second
{
    NSString* timeStr = @"" ;
    int oneHour = 3600;// 一小时 3600s
    NSTimeInterval time= second - 8*oneHour;//因为时差问题要减8小时(28800s)
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    dateFormatter.dateFormat = second < oneHour ? @"mm:ss" : @"HH:mm:ss";
    timeStr = [dateFormatter stringFromDate: detaildate];
    return timeStr;
}


+(UIBarButtonItem*)navBackItemWithTarget:(id)target action:(SEL)action
{
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_btn_2"] style:UIBarButtonItemStyleBordered target:target action:action];
    return item;
}

+(UIButton*)makeButtonWithFrame:(CGRect)frame nromalImg:(UIImage*)normalImg selectImg:(UIImage*)selectImg title:(NSString*)title target:(id)target action:(SEL)action events:(UIControlEvents)events
{
    UIButton* btn = [[UIButton alloc] initWithFrame:frame];
    [btn setImage:normalImg forState:UIControlStateNormal];
    [btn setImage:selectImg forState:UIControlStateSelected];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:events];
    return btn;
    
}
+(UIImage *)imageFromColor:(UIColor *)color  size:(CGSize)size
{
    // 使用颜色创建UIImage
    CGSize imageSize = size;
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *ColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return ColorImg;
}
+ (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    return size;
}
+ (NSString *)tmpPath
{
    return [NSHomeDirectory() stringByAppendingFormat:@"/tmp"];
}
+(NSString *)currentTime
{
    NSDate *today = [NSDate date];//当前时间
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];  // 格式化时间NSDate
    
    
    
    NSString *stringFromDate = [dateFormat stringFromDate:today];
    return stringFromDate;
}
+(NSString *)currentTimeString
{
    NSString *time = [self currentTime];
    NSMutableString *s = [NSMutableString stringWithString:time];
    
    [s replaceOccurrencesOfString:@" " withString:@"_" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@":" withString:@"_" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"." withString:@"_" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    time = s;
    return time;
}
-(NSString *)stringFromeData:(NSData *)data
{

    return [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
}
+(unsigned long long)fileSizeWithPath:(NSString *)path
{
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:path]){
        
        NSLog(@"文件大小%llu",[[manager attributesOfItemAtPath:path error:nil] fileSize]);
        
        return [[manager attributesOfItemAtPath:path error:nil] fileSize];
        
    }else{
        
        return 0;
    }
    
}
@end
