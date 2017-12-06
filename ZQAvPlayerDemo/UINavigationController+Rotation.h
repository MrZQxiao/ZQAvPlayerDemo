//
//  UINavigationController+Rotation.h
//  LpMoviePlayer
//
//  Created by mjc on 14/8/20.
//  Copyright (c) 2014年 mjc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Rotation)
-(BOOL)shouldAutorotate;
-(NSUInteger)supportedInterfaceOrientations;
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation;
@end
