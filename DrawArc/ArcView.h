//
//  ArcView.h
//  TestDrawCircle
//
//  Created by Lihui on 14/11/19.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePage.h"


#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@protocol updateScoreDelegate
@optional
-(void)updateScore;
@end

@interface ArcView : UIView
@property(nonatomic) UIColor *backColor;
@property(nonatomic) UIColor *progressColor;
@property(assign,nonatomic)CGFloat lineWidth;
@property(nonatomic,assign)NSInteger score;
@property(nonatomic,retain)UITapGestureRecognizer *tapGesture;
@property(nonatomic,retain) id<updateScoreDelegate> delegate;
//@property(nonatomic,retain)UIImageView *bgCircleImageView;
-(id)initWithFrame:(CGRect)frame
        backColor:(UIColor*)backColor
    progressColor:(UIColor*)progressColor
        lineWidth:(CGFloat)lineWidth;
-(void)handelGesture:(UIGestureRecognizer *)recognizer;
-(void)updateProgressCircle;
@end
