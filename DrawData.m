//
//  DrawData.m
//  XingAi02
//
//  Created by Lihui on 14/11/14.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//

#import "DrawData.h"

@implementation DrawData {
    float m;
    float n;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _bleControl=[BLEControl sharedBLEControl];
        _bleControl.delegate1=self;
        _dataList=[[NSMutableArray alloc]initWithCapacity:100];
         m= 0;
         n= 0;
    }
    return self;
}

-(void)addCountData:(float)data {
    NSNumber *num=[NSNumber numberWithFloat:data];
    [_dataList addObject:num];
    [self callDrawWithData:_dataList];
    [self setNeedsDisplay];
}

-(void)addZeroNum {
    NSNumber *zeroNum=[NSNumber numberWithFloat:0.0f];
    [_dataList addObject:zeroNum];
    [self setNeedsDisplay];
}
- (void)callDrawWithData:(NSMutableArray*) data
{
    //_dataList=data;
    [self setNeedsDisplay];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
//    if (m >=30) {
//        
//        m = 0;
//        n = 0;
//    }
    
    CGContextRef context=UIGraphicsGetCurrentContext();
   UIColor *color= [UIColor colorWithRed:224.0/255 green:184.0/255 blue:25.0/255 alpha:1.0];
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 3);
    
    NSInteger length=[_dataList count];
//    for (NSInteger i=0;i<length; i++) {
//        CGPoint bPoints[2];
//        bPoints[0]=CGPointMake(160-10*(length-i),150-[[_dataList objectAtIndex:i]integerValue]);
//        bPoints[1]=CGPointMake(160-10*(length-i),150);
//        CGContextAddLines(context, bPoints, 2);
//        CGContextDrawPath(context, kCGPathStroke);
//        
//    }
    if (length>=1) {
        for (NSInteger i=0;i<length; i++) {
            CGPoint bPoints[2];
            bPoints[0]=CGPointMake(160-5*(length-i+1),180.0-[[_dataList objectAtIndex:i]floatValue]*180/5.0);
            bPoints[1]=CGPointMake(160-5*(length-i+1),180.0+[[_dataList objectAtIndex:i]floatValue]*180/5.0);
            CGContextAddLines(context, bPoints, 2);
            CGContextDrawPath(context, kCGPathStroke);
//            NSLog(@"很爱很爱=%f",[[_dataList objectAtIndex:i]floatValue]*180/7.47);
        }
        
//        CGPoint cPoints[2];
//        cPoints[0]=CGPointMake(150-0.5,180-[[_dataList objectAtIndex:(length-1)]floatValue]);
//        cPoints[1]=CGPointMake(150-0.5,180+);
//        CGContextAddLines(context, cPoints, 2);
        //CGContextDrawPath(context, kCGPathStroke);
        //m++; n++;
    }
    else return;
}


@end
