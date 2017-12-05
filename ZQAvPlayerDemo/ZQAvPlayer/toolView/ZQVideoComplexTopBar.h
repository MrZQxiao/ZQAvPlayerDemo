//
//  ZQVideoComplexTopBar.h
//  ZQAvPlayerDemo
//
//  Created by 肖兆强 on 2017/12/5.
//  Copyright © 2017年 ZQDemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZQVideoComplexTopBarDelegate <NSObject>

-(void)topBarBackBtnClicked;


@end

#define TopBarHeight 50


@interface ZQVideoComplexTopBar : UIView

@property(weak,nonatomic) id<ZQVideoComplexTopBarDelegate>delegate;


-(void)setTitle:(NSString*)_title;




-(void)showBackBtn:(BOOL)_show;


-(void)setFullScreenStyle:(CGRect)frame;

-(void)setNormaStyle:(CGRect)frame;

@end
