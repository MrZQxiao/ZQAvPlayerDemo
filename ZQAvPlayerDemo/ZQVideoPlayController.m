//
//  ZQVideoFullScreenPlayer.m
//  ZQAvPlayerDemo
//
//  Created by 肖兆强 on 2017/12/5.
//  Copyright © 2017年 ZQDemo. All rights reserved.
//
#define titleImgHeight   ScreenWidth * 0.6


#import "ZQVideoPlayController.h"

@interface ZQVideoPlayController ()<ZQAVPlayerDelegate>
{
    ZQAVPlayer *_player;
    
    NSInteger _stratTime;
    NSInteger _breakTime;
    NSInteger _playTime;
    NSInteger _stayTime;
    BOOL _isOneLoop;

    
}
@end

@implementation ZQVideoPlayController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:true];
//    if (_player.currentPlayState == playState_Pausing) {
        [_player play];
//    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:true];
    
    [super viewWillDisappear:animated];
    if (_player.currentPlayState == playState_Playing) {
        [_player pause];
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _stratTime = 0;
    _breakTime = 0;
    _playTime = 0;
    _stayTime = 0;
    // Do any additional setup after loading the view.
    [self makePlayer];
    [self makeChangeBtn];
    
    
}
-(void)makePlayer
{
    if (_player == nil) {
    
        
        _player = [[ZQAVPlayer alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, titleImgHeight) url:@"http://27.112.86.59:1935/vod1//2017_11/22/1511344230826.mp4" type:player_online];
        _player.delegate = self;
        [self.view addSubview:_player];
//        [_player play];
    }
}

- (void)makeChangeBtn
{
    CGFloat btnx = 150;
    CGFloat btnY = CGRectGetMaxY(_player.frame) + 30;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnx,btnY, 80, 30)];
    
    [btn addTarget:self action:@selector(changeUrl) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"切换视频" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:btn];
    
}

- (void)changeUrl
{
    
    [_player changeVideoUrl:@"http://27.112.86.59:1935/vod1//2017_11/22/1511344230826.mp4"];
    
}


-(void)playerStartPlay:(NSInteger)seconds
{
    
    
    _stratTime = seconds;
    _isOneLoop = YES;
}


-(void)breakEventBecome:(NSInteger)second
{
    if (_isOneLoop) {
        _isOneLoop = NO;
        _breakTime = second;
        _playTime = _breakTime - _stratTime;
        _stayTime = _stayTime + _playTime;
        _playTime = 0;
    }
    
    
}
-(void)changeEventBecome
{
    NSLog(@"从这个时间切换了视频changeEventBecome");
    
    
    
    
}


#pragma mark PlayerDelegate
-(void)playerBackBtnClicked
{
    
    [self.navigationController popViewControllerAnimated:true];
    
    
}

-(void)go2FullScreen
{
    [_player showBackBtn:true];
    
    [self.view addSubview:_player];
    NSLog(@"全屏");
}


-(void)playerEnd
{
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
