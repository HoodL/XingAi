//
//  SliderViewController.h
//  LeftRightSlider
//
//  Created by Zhao Yiqi on 13-11-27.
//  Copyright (c) 2013年 Zhao Yiqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SliderViewController : UIViewController

@property(nonatomic,strong)UIViewController *LeftVC;
@property(nonatomic,strong)UIViewController *RightVC;
@property(nonatomic,strong)UIViewController *MainVC;

@property(nonatomic,strong)NSMutableDictionary *controllersDict;
//左右视图被拉出以后主视图的X方向的offset（正值）
@property(nonatomic,assign)float LeftSContentOffset;
@property(nonatomic,assign)float LeftContentViewSContentOffset;
@property(nonatomic,assign)float RightSContentOffset;
//左右视图被拉出以后主视图放缩的比例（0到1）
@property(nonatomic,assign)float LeftSContentScale;
@property(nonatomic,assign)float RightSContentScale;
//左右视图被拉的过程中的判断点的X值（正值）
@property(nonatomic,assign)float LeftSJudgeOffset;
@property(nonatomic,assign)float RightSJudgeOffset;
//左右视图拉出所用的时间
@property(nonatomic,assign)float LeftSOpenDuration;
@property(nonatomic,assign)float RightSOpenDuration;
//左右视图收回时所用的时间
@property(nonatomic,assign)float LeftSCloseDuration;
@property(nonatomic,assign)float RightSCloseDuration;
//左右视图能否被拉出
@property(nonatomic,assign)BOOL canShowLeft;
@property(nonatomic,assign)BOOL canShowRight;

@property (nonatomic, copy) void(^changeLeftView)(CGFloat sca, CGFloat transX);

+ (SliderViewController*)sharedSliderController;

- (void)showContentControllerWithModel:(NSString*)className;
- (void)showLeftViewController;
- (void)showRightViewController;

- (void)moveViewWithGesture:(UIPanGestureRecognizer *)panGes;
- (void)closeSideBar;
- (void)closeSideBarWithAnimate:(BOOL)bAnimate complete:(void(^)(BOOL finished))complete;

@end
