//
//  InWave.m
//  XingAi02
//
//  Created by Lihui on 14/12/4.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//

#import "InWave.h"
#import "SportsData.h"
#import "InAndHz.h"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@implementation InWave


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(void)setDataList:(NSMutableArray *)dataList
{
    NSMutableArray *list
    =[[NSMutableArray alloc]initWithCapacity:0];
    float HzSum=0.f;
    for (SportsData *data in dataList) {
        InAndHz *inandhz=[[InAndHz alloc]init];
        HzSum= 1.00/[data.hz floatValue]+HzSum;
        inandhz.in= [data.intensity floatValue];
        inandhz.Hz=HzSum;//
        [list addObject:inandhz];
    }
    _dataList=list;
}

- (void)callDrawWithData
{
    //_dataList=list;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    //先在正中间画一根横线，当做X轴
    CGContextRef context=UIGraphicsGetCurrentContext();
    UIColor *color=[UIColor colorWithRed:62.0/255 green:108.0/255 blue:190.0/255 alpha:1.0];
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGPoint aPoints[2];
    aPoints[0]=CGPointMake(0, 90);
    aPoints[1]=CGPointMake(SCREEN_WIDTH,90);
    CGContextAddLines(context, aPoints, 2);
    CGContextDrawPath(context, kCGPathStroke);
    
    UIColor *color1=[UIColor colorWithRed:61.0/255 green:107.0/255 blue:190.0/255 alpha:1.0];
    CGContextSetStrokeColorWithColor(context, color1.CGColor);
    
    
    for (int i=0; i<[_dataList count]; i++) {
        InAndHz *inandhz=[[InAndHz alloc]init];
        inandhz=[_dataList objectAtIndex:i];
        CGPoint aPoints[2];
        aPoints[0]=CGPointMake(0+inandhz.Hz, 90-inandhz.in*90/5.0);
        aPoints[1]=CGPointMake(0+inandhz.Hz,90+inandhz.in*90/5.0);
        CGContextAddLines(context, aPoints, 2);
        CGContextDrawPath(context, kCGPathStroke);

    }
}


@end
