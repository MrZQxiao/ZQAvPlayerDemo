//
//  ViewController.m
//  ZQAvPlayerDemo
//
//  Created by 肖兆强 on 2017/12/5.
//  Copyright © 2017年 ZQDemo. All rights reserved.
//

#define titleImgHeight   ScreenWidth * 0.6


#import "ViewController.h"
#import "ZQAVPlayer.h"
#import "ZQVideoPlayController.h"

@interface ViewController ()<ZQAVPlayerDelegate>


@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *videoBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, 150, 80, 30)];
    videoBtn.tag = 0;
    [videoBtn addTarget:self action:@selector(videoPlay:) forControlEvents:UIControlEventTouchUpInside];
    [videoBtn setTitle:@"视频" forState:UIControlStateNormal];
    [videoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [videoBtn setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:videoBtn];
    
    
}
- (void)videoPlay:(UIButton *)sender
{
    
            ZQVideoPlayController *listTableVC = [[ZQVideoPlayController alloc] init];
            [self.navigationController pushViewController:listTableVC animated:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
