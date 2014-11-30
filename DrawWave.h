//
//  DrawWave.h
//  XingAi02
//
//  Created by Lihui on 14/11/14.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawWave : UIView
{
    
    float swing;
    int   i;
    float j;

}

- (void)callDraw:(float)f;

@end
