//
//  HomePage.m
//  XingAi02
//
//  Created by Lihui on 14/11/21.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//

#import "HomePage.h"

@implementation HomePage

-(id)initWithFrame:(CGRect)frame {
    self=[super initWithFrame:frame];
    if (self) {
        [self initBgCircleView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) initBgCircleView {
    _bgCircleImageView=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-275)/2, 96, 275, 275)];
    _bgCircleImageView.image=[UIImage imageNamed:@"主页大圆带刻度"];
    [self addSubview:_bgCircleImageView];
}
@end
