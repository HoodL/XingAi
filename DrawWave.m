//
//  DrawWave.m
//  XingAi02
//
//  Created by Lihui on 14/11/14.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//

#import "DrawWave.h"

@implementation DrawWave

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        i = 0;
        j = 0;
    }
    return self;
}

- (void)callDraw:(float)f
{
    if (f < 1) {
        swing = f;
    }else {
        swing = 1;
    }
    //4、直接调用setNeedsDisplay，或者setNeedsDisplayInRect:触发drawRect:，但是有个前提条件是rect不能为0。
    
   // [self setNeedsDisplay];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    if (i >=30) {
        
        i = 0;
        j = 0;
    }
    // Drawing code
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 1.0);
    
//    CGContextAddLineToPoint(context, 100, 100);
//    CGContextSetLineWidth(context, 2.0);
    //画直线
   /* for (j=0; j<=30;j++) {
        CGPoint aPoints[2];
        aPoints[0]=CGPointMake(300-10*j-i, 0);
        aPoints[1]=CGPointMake(300-10*j-i,15);
        CGContextAddLines(context, aPoints, 2);
        CGContextDrawPath(context, kCGPathStroke);
    }*/
    
   /* for(NSInteger n=0;n<=i/10;n++) {
        CGPoint nPoints[2];
        nPoints[0]=CGPointMake(300-i+10*n, 0);
        nPoints[1]=CGPointMake(300-i+10*n,15);
        CGContextAddLines(context, nPoints, 2);
        CGContextDrawPath(context, kCGPathStroke);
    }
    */
    
//    CGPoint bPoints[2];
//    bPoints[0]=CGPointMake(0, 15);
//    bPoints[1]=CGPointMake(300,15);
//    CGContextAddLines(context, bPoints, 2);
//    CGContextDrawPath(context, kCGPathStroke);
    
//    for (NSInteger m=0; m<100; m++) {
//        <#statements#>
//    }
//    i++;
//    j++;
    
    i++;
    //中间画一根横线线条
    CGPoint cPoints[2];
    cPoints[0]=CGPointMake(0, 36+180);
    cPoints[1]=CGPointMake(SCREEN_WIDTH,36+180);
    CGContextAddLines(context, cPoints, 2);
    CGContextDrawPath(context, kCGPathStroke);
    //下面画一根横线线条
    CGPoint dPoints[2];
    dPoints[0]=CGPointMake(0, 360+36);
    dPoints[1]=CGPointMake(SCREEN_WIDTH,360+36);
    CGContextAddLines(context, dPoints, 2);
    CGContextDrawPath(context, kCGPathStroke);
    //中间画一根树直线
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGPoint ePoints[2];
    ePoints[0]=CGPointMake(SCREEN_WIDTH/2, 36);
    ePoints[1]=CGPointMake(SCREEN_WIDTH/2,360+36);
    CGContextAddLines(context, ePoints, 2);
    CGContextDrawPath(context, kCGPathStroke);
}
@end
