//
//  ZQButton.m
//  ZQAvPlayerDemo
//
//  Created by 肖兆强 on 2017/12/5.
//  Copyright © 2017年 ZQDemo. All rights reserved.
//

#import "ZQButton.h"

#define SmallEdge 5


@implementation ZQButton

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self buildLayout];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildLayout];
    }
    return self;
}

-(void)buildLayout
{
    self.showsTouchWhenHighlighted = true;
    [self changeImgEdge];
}


-(void)changeImgEdge
{
    [self setImageEdgeInsets:UIEdgeInsetsMake(SmallEdge, SmallEdge, SmallEdge, SmallEdge)];
}

@end
