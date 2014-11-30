//
//  ArcView.m
//  TestDrawCircle
//
//  Created by Lihui on 14/11/19.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//

#import "ArcView.h"
@interface ArcView()
@property(nonatomic,assign)CGFloat progress;
@property(nonatomic,assign)CGFloat angle;//angle between two lines
@end

@implementation ArcView

-(id)initWithFrame:(CGRect)frame backColor:(UIColor *)backColor progressColor:(UIColor *)progressColor lineWidth:(CGFloat)lineWidth
{
    self=[super initWithFrame:frame];
    //[self initBgCircleView];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        _backColor=backColor;
        _progressColor=progressColor;
        _lineWidth=lineWidth;
        //添加点击手势、拖动手势
        _tapGesture=[[UITapGestureRecognizer alloc]
                                            initWithTarget:self action:@selector(handelGesture:)];
        _tapGesture.cancelsTouchesInView = NO;
        //[self addGestureRecognizer:_tapGesture];
        //UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc]
//                                            initWithTarget:self action:@selector(handelGesture:)];
        //[self addGestureRecognizer:panGesture];
    }
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    UIBezierPath *backCircle=[UIBezierPath bezierPathWithArcCenter:CGPointMake(SCREEN_WIDTH/2-2,96+275/2-9)
        radius:83
        startAngle:(CGFloat)(M_PI*0.75+28.000/360)
        endAngle:(CGFloat)(2.25*M_PI-28.000/360)
    clockwise:YES];
    [self.backColor setStroke];
    
    backCircle.lineWidth=self.lineWidth;
    [backCircle stroke];
    //[self initBgCircleView];
    
    if(self.progress) {
        UIBezierPath *progressCircle=[UIBezierPath bezierPathWithArcCenter:
            CGPointMake(SCREEN_WIDTH/2-2,96+275/2-9)
            radius:83
            startAngle:(CGFloat)(M_PI*0.75+28.000/360) endAngle:(CGFloat) ((CGFloat)(M_PI*0.75+28.000/360)+_progress*(1.5*M_PI-56.00/360)) clockwise:YES];
    [self.progressColor setStroke];
    progressCircle.lineWidth=self.lineWidth;
    [progressCircle stroke];
  }
}

//-(void)initBgCircleView {
//    _bgCircleImageView=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-275)/2, 96, 275, 275)];
//    _bgCircleImageView.image=[UIImage imageNamed:@"主页大圆带刻度"];
//    [self addSubview:_bgCircleImageView];
//}

-(void)updateProgressCircle {
    self.progress=((float)(self.score)/100.0);
    
    //self.progress=(float)(self.angle/(1.5*M_PI-56.00/360));
    [self setNeedsDisplay];
    //[self.delegate updateScore];
    
}

- (void)handelGesture:(UIGestureRecognizer *)recognizer{
    CGPoint point = [recognizer locationInView:self];
    if (CGRectContainsPoint(CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.frame)/2), point)) {
        self.angle = [self angleFromStartToPoint:[recognizer locationInView:self]];
//        self.score =(NSInteger)(100.0 * (self.angle /(1.5*M_PI-56.00/360)));
        
        [self updateProgressCircle];
        if (recognizer.state == UIGestureRecognizerStateEnded) {
//            if (self.playOrPauseButtonIsPlaying) {
//                [self play];
            }
        }
    }



//calculate angle between start to point
- (CGFloat)angleFromStartToPoint:(CGPoint)point{
    CGFloat boundsWidth=CGRectGetWidth(self.bounds);
    CGFloat boundsHeight=CGRectGetHeight(self.bounds);

    CGFloat angle = [self angleBetweenLinesWithLine1Start:CGPointMake(SCREEN_WIDTH/2-2,96+275/2-9) Line1End:CGPointMake(SCREEN_WIDTH/2-2+83*cos(M_PI*0.75+28.000/360),96+275/2-9+83*sin(M_PI*0.75+28.000/360)) Line2Start:CGPointMake(SCREEN_WIDTH/2-2,96+275/2-9) Line2End:point];
    CGFloat angleNew=[self angleBetweenTwoLines:point];
    if (CGRectContainsPoint(CGRectMake(boundsWidth/2-67.5*cos(M_PI*0.75+28.000/360), 0, boundsWidth/2, boundsHeight), point))
        
    {
        if ([self angleBetweenLineToHorizontal:point]<(2*M_PI-(M_PI*0.75+28.000/360)))
        {
             angleNew =2*M_PI-angleNew;
        }
    }
    
//    if(angle>(M_PI)) angle =2*M_PI-angle;
    return angleNew;
}


//calculate angle between 2 lines
- (CGFloat)angleBetweenLinesWithLine1Start:(CGPoint)line1Start
                                  Line1End:(CGPoint)line1End
                                Line2Start:(CGPoint)line2Start
                                  Line2End:(CGPoint)line2End{
    CGFloat a = line1End.x - line1Start.x;
    CGFloat b = line1End.y - line1Start.y;
    CGFloat c = line2End.x - line2Start.x;
    CGFloat d = line2End.y - line2Start.y;
    return acos(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));
}
//根据手势点击点求夹角
-(CGFloat) angleBetweenTwoLines:(CGPoint)point
{
    //圆心坐标为
    CGPoint circleCenter =CGPointMake(SCREEN_WIDTH/2-2,96+275/2-9);
    //起点坐标为
    CGPoint startPoint =CGPointMake(SCREEN_WIDTH/2-2+83*cos(M_PI*0.75+28.000/360),96+275/2-9+83*sin(M_PI*0.75+28.000/360));
    //手势到圆心的距离的平方
   CGFloat square1=(point.x-circleCenter.x)*(point.x-circleCenter.x)+
    (point.y-circleCenter.y)*(point.y-circleCenter.y);
    //起点到手势点的距离平方
    CGFloat square2=(point.x-startPoint.x)*(point.x-startPoint.x)+
    (point.y-startPoint.y)*(point.y-startPoint.y);
    //手势到圆心的距离
    CGFloat length1=sqrt(square1);
    //手势到起点的距离
    //CGFloat length2=sqrt(square2);
    return acos((square1+83*83-square2)/(2*83*length1));
}
//手势点到圆心连线与水平线的夹角,只在右半圆讨论
-(CGFloat) angleBetweenLineToHorizontal:(CGPoint)point
{
    //圆心坐标为
    CGPoint circleCenter =CGPointMake(SCREEN_WIDTH/2-2,96+275/2-9);
    //point到圆心的x差距
   CGFloat heigth_x=point.x-circleCenter.x;
    //point到圆心的y差距
   CGFloat heigth_y=point.y-circleCenter.y;
    return atan(heigth_y/heigth_x);
}
@end

