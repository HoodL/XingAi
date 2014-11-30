//
//  MainTabViewController.h
//  XingAi
//
//  Created by Lihui on 14/11/10.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcView.h"
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@protocol tapGestureDelegate <NSObject>
@required
-(void) respondGesture:(UIGestureRecognizer*)recongnizer;
@end

@interface MainTabViewController : UIViewController

//@property (retain, nonatomic) IBOutlet ArcView *mainArcView;
//
//
@property (retain, nonatomic) UIScrollView *mainScrollView;

@property(nonatomic,retain) id<tapGestureDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;
@property (retain, nonatomic)  UIButton *countButton;
@property (retain, nonatomic)  UIButton *timeButton;
@property (retain, nonatomic)  UIButton *HzButton;
@property (retain, nonatomic)  UIButton *rangeButton;
@property (retain, nonatomic)  UIButton *heatButton;
@property (retain, nonatomic)  UIImageView *line;
@property (retain, nonatomic)  UIImageView *arrow;
@property (retain, nonatomic)  UIButton *markScoreButton;
//@property (strong, nonatomic) IBOutlet UIImageView *bgCircleImageView;
//@property (nonatomic,assign) CGPoint tapZone;
- (IBAction)clickCountButton:(id)sender;
- (IBAction)clickTimeButton:(id)sender;
- (IBAction)clickHzButton:(id)sender;
- (IBAction)clickRangeButton:(id)sender;
- (IBAction)clickHeatButton:(id)sender;
- (IBAction)clickStartButton:(id)sender;
- (IBAction)clickSyButton:(id)sender;
- (IBAction)clickShareButton:(id)sender;
- (IBAction)clickMenuButton:(id)sender;
-(void)clickMarkScoreButton;
@property (strong, nonatomic) IBOutlet UIButton *hahaButton;
@property(retain,nonatomic) UIImageView *bgCircleImageView;
@property(nonatomic,retain)ArcView *Arc;
@property(nonatomic,retain)UITextField *scoreField;
@end
