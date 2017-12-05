//
//  ZQVideoComplexTopBar.m
//  ZQAvPlayerDemo
//
//  Created by 肖兆强 on 2017/12/5.
//  Copyright © 2017年 ZQDemo. All rights reserved.
//

#define TopBarHeight 50


#import "ZQVideoComplexTopBar.h"
#import "UIUtils.h"


@implementation ZQVideoComplexTopBar
{
    UIView* _backView;
    
    UILabel* _titleLabel;
    
    UIButton* _backBtn;
    
   
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    _backView = [UIUtils makeEffectViewWithFrame:self.bounds stype:UIBlurEffectStyleDark cornerRadius:0];
    _backView.hidden = true;
    [self addSubview:_backView];
    
    
    float margin = 10;
    float btnWdith = TopBarHeight - 2*margin;
    //返回按钮
    _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(margin, margin, btnWdith, btnWdith)];
    //    _backBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    //    _backBtn.layer.cornerRadius = btnWdith/2;
    [_backBtn addTarget:self action:@selector(backMethod) forControlEvents:UIControlEventTouchUpInside];
    [_backBtn setImage:[UIImage imageNamed:@"player_back_btn"] forState:UIControlStateNormal];
    [self addSubview:_backBtn];
    
    
   
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(2*margin+btnWdith, margin, 200, btnWdith)];
    //    _titleLabel.text = @"老男孩";
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.hidden = true;
    [self addSubview:_titleLabel];
    
    
}

-(void)backMethod
{
    if ([_delegate respondsToSelector:@selector(topBarBackBtnClicked)]) {
        [_delegate performSelector:@selector(topBarBackBtnClicked) withObject:nil];
    }
}

-(void)setTitle:(NSString*)_title
{
    _titleLabel.text = _title;
}


-(void)showBackBtn:(BOOL)_show
{
    _backBtn.hidden = !_show;
}

-(void)setFullScreenStyle:(CGRect)frame
{
    
    //    CGRectMake(0, 0, self.bounds.size.width, TopBarHeight)
    
    self.frame = CGRectMake(0, 0, frame.size.width, TopBarHeight);
    _backView.frame = self.bounds;
    _backView.hidden = false;
    _titleLabel.hidden = false;
   
}


-(void)setNormaStyle:(CGRect)frame
{
    self.frame = frame;
    _backView.hidden = true;
    _titleLabel.hidden = true;
}


@end
