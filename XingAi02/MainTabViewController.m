//
//  MainTabViewController.m
//  XingAi
//
//  Created by Lihui on 14/11/10.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//
#import "SliderViewController.h"
#import "MainTabViewController.h"
#import "DetailsViewController.h"
#import "CDRTranslucentSideBar.h"
#import "calendarViewController.h"
#import "CalendarHomeViewController.h"
#import "PNLineChartView.h"
#import "PNPlot.h"
#import "WaveViewController.h"
#import "ArcView.h"
#import "SliderViewController.h"
#import "BLEControl.h"
#import "DeviceVC.h"

@interface MainTabViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    CalendarHomeViewController *chvc;
    
}

@property (nonatomic, strong) CDRTranslucentSideBar *sideBar;
//@property (nonatomic, strong) CDRTranslucentSideBar *rightSideBar;
@property(nonatomic,retain)PNLineChartView *chartView;

@property(nonatomic,retain)UIGestureRecognizer *tapGesture;
@property(nonatomic,retain)UIButton *menuButton;
@property(nonatomic,retain)UIButton *canlendarButton;
@property(nonatomic,retain)UIButton *synButton;
@property(nonatomic,retain)UIButton *shareButton;
@property(nonatomic,retain)UIButton *startButton;
@property(nonatomic,retain)BLEControl *bleControl;
@property(nonatomic,retain)UILabel *score;//用户给自己打分
@end

@implementation MainTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self lightenAndPutOutButton];
    //[self.view insertSubview:_mainScrollView atIndex:1];
    //_mainScrollView.backgroundColor=[UIColor whiteColor];
    [self initScrollView];
    [self initBgCircleView];
    [self initArcView];
    [self initButton];
    [self initBleControl];
    [self initMarkScoreButton];
    [self initScoreLabel];
    //[self initGesture];
    NSLog(@"width=%f",[UIScreen mainScreen].bounds.size.width);
    NSLog(@"heigth=%f",[UIScreen mainScreen].bounds.size.height);
    //NSLog(@"heigth=%f",SCREEN_HEIGTH);
    //NSLog(@"heigth=%f",SCREEN_WIDTH);

    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    [self setNeedsStatusBarAppearanceUpdate];
    [self addPanGestureRecognizer];
    _Arc.backgroundColor=[UIColor clearColor];
    //[self.view addSubview:_Arc];
    //_Arc.pagingEnabled=YES;
    /*if (!iPhone5) {
        self.Arc.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 480);
    }
    self.Arc.delegate=self;
    _Arc.showsHorizontalScrollIndicator=NO;
    _Arc.showsVerticalScrollIndicator=YES;*/
    _mainScrollView.contentSize=CGSizeMake(self.view.bounds.size.width,(self.view.bounds.size.height)*3);
    //第二屏
    UIImageView *secondBG=[[UIImageView alloc]initWithFrame:CGRectMake(0,(self.view.frame.size.height),self.view.frame.size.width,self.view.frame.size.height)];
    secondBG.image=[UIImage imageNamed:@"功能页面背景"];
    [_mainScrollView addSubview:secondBG];
    //第三屏
    UIImageView *thirdBG=[[UIImageView alloc]initWithFrame:CGRectMake(0,secondBG.frame.origin.y+self.view.frame.size.height,self.view.frame.size.width,self.view.frame.size.height)];
    thirdBG.image=[UIImage imageNamed:@"侧边栏背景图-568h"];
    [_mainScrollView addSubview:thirdBG];
    
    //刻度
    UIImageView *scale=[[UIImageView alloc]initWithFrame:CGRectMake(0, secondBG.frame.origin.y+100, self.view.frame.size.width, 36)];
    scale.image=[UIImage imageNamed:@"主页-上滑标尺"];
    [_mainScrollView addSubview:scale];
    // 右侧刻度
    UIImageView *rightScale=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-33/2, scale.frame.origin.y+scale.frame.size.height, 33/2, 181)];
    rightScale.image=[UIImage imageNamed:@"主页-上滑右侧刻度"];
    [_mainScrollView addSubview:rightScale];
    //运动时间和下方文字
    UILabel *sportTime=[[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width/2)-100, rightScale.frame.origin.y+181+50,200, 50)];
    sportTime.text=@"12:03:20";
    sportTime.textAlignment=NSTextAlignmentCenter;
    sportTime.textColor=[UIColor whiteColor];
    sportTime.font=[UIFont systemFontOfSize:50];
    [_mainScrollView addSubview:sportTime];
    UILabel *sportDistance=[[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width/2)-120, sportTime.frame.origin.y+50, 240, 50)];
    sportDistance.text=@"你的运动距离相当于5公里路程";
    sportDistance.textAlignment=NSTextAlignmentCenter;
    sportDistance.textColor=[UIColor whiteColor];
    sportDistance.font=[UIFont systemFontOfSize:15];
    [_mainScrollView addSubview:sportDistance];
    //第三屏上写星爱建议suggestion
    //图标和大字
    UIImageView *suggestionLogo=[[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width)/2-33/2, 20, 33, 33)];
    suggestionLogo.image=[UIImage imageNamed:@"星爱建议icon"];
    UILabel *suggestionLabel=[[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width)/2-50, 64, 100, 25)];
    suggestionLabel.text=@"星爱建议";
    suggestionLabel.textAlignment=NSTextAlignmentCenter;
    [thirdBG addSubview:suggestionLabel];
    [thirdBG addSubview:suggestionLogo];

    CGSize maxSize=CGSizeMake(self.view.frame.size.width-40, 999);
   NSString *text1=@"我们希望一些事情非常高效，但我们不得不承认下面建议是正确的:慢下来,小伙子！“性爱并不是一场比赛,因此要慢慢地去探索她”;";
    UIFont *font=[UIFont systemFontOfSize:14];
    CGSize dataStringSize1=[text1 sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *suggestionLael1=[[UILabel alloc]initWithFrame:CGRectMake(20, 100, self.view.frame.size.width-40, dataStringSize1.height)];
    suggestionLael1.numberOfLines=0;
    //[suggestionLael1 sizeToFit];
    suggestionLael1.textAlignment=NSTextAlignmentLeft;
    suggestionLael1.textColor=[UIColor whiteColor];
    suggestionLael1.text=text1;
    [suggestionLael1 setLineBreakMode:NSLineBreakByWordWrapping];
    [thirdBG addSubview:suggestionLael1];
    
    NSString *text2=@"你和他是不是多年来使用相同的姿势?\n换换吧";
    CGSize dataStringSize2=[text2 sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *suggestionLael2=[[UILabel alloc]initWithFrame:CGRectMake(20, suggestionLael1.frame.origin.y+dataStringSize1.height+20, self.view.frame.size.width-40, dataStringSize1.height)];
    suggestionLael2.numberOfLines=0;
    //[suggestionLael1 sizeToFit];
    suggestionLael2.textAlignment=NSTextAlignmentLeft;
    suggestionLael2.textColor=[UIColor whiteColor];
    suggestionLael2.text=text2;
    [suggestionLael2 setLineBreakMode:NSLineBreakByWordWrapping];
    [thirdBG addSubview:suggestionLael2];
    
    NSString *text3=@"双方还可以性爱以后吃4、5个大枣，补血，还可以吃一些富含胡萝卜素的食物，板栗、榛子、仁杏、腰果等滋阴补阳、补精气，这些食物对于双方来说都是很好的帮助与缓解，不建议刚做就睡觉;";
    CGSize dataStringSize3=[text3 sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *suggestionLael3=[[UILabel alloc]initWithFrame:CGRectMake(20, suggestionLael2.frame.origin.y+dataStringSize2.height+40, self.view.frame.size.width-40, dataStringSize3.height)];
    suggestionLael3.numberOfLines=0;
    //[suggestionLael1 sizeToFit];
    suggestionLael3.textAlignment=NSTextAlignmentLeft;
    suggestionLael3.textColor=[UIColor whiteColor];
    suggestionLael3.text=text3;
    [suggestionLael3 setLineBreakMode:NSLineBreakByWordWrapping];
    [thirdBG addSubview:suggestionLael3];
    
    NSString *text4=@"排球对臂部肌肉和腹部肌肉的锻炼效果尤为明显，同时，对你的灵敏性的提高也很有帮助，让你的协作能力更强，享受更多床第间变化的乐趣。";
    CGSize dataStringSize4=[text3 sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *suggestionLael4=[[UILabel alloc]initWithFrame:CGRectMake(20, suggestionLael3.frame.origin.y+dataStringSize3.height+20, self.view.frame.size.width-40, dataStringSize4.height)];
    
    suggestionLael4.numberOfLines=0;
    //[suggestionLael1 sizeToFit];
    suggestionLael4.textAlignment=NSTextAlignmentLeft;
    suggestionLael4.textColor=[UIColor whiteColor];
    suggestionLael4.text=text4;
    [suggestionLael4 setLineBreakMode:NSLineBreakByWordWrapping];
    [thirdBG addSubview:suggestionLael4];
    //白色分割线
    UIImageView *separatedLine=[[UIImageView alloc]initWithFrame:CGRectMake(0, suggestionLael4.frame.origin.y+suggestionLael4.frame.size.height+10, self.view.frame.size.width, 1)];
    separatedLine.backgroundColor=[UIColor whiteColor];
    [thirdBG addSubview:separatedLine];
    //底下两个按钮以及白色Logo
    UIButton *deviceButton=[[UIButton alloc]initWithFrame:CGRectMake(20, suggestionLael4.frame.origin.y+suggestionLael4.frame.size.height+30, 128, 47)];
    [deviceButton setBackgroundImage:[UIImage imageNamed:@"主页-上滑透明按钮"] forState:UIControlStateNormal];
    [thirdBG addSubview:deviceButton];
    UIImageView *deviceImageView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 7, 33, 33)];
    deviceImageView.image=[UIImage imageNamed:@"主页-上滑设备"];
    [deviceButton addSubview:deviceImageView];
    UILabel *deviceLabel=[[UILabel alloc]initWithFrame:CGRectMake(63, 6, 50,33)];
    deviceLabel.text=@"设备";
    //deviceLabel.font=[UIFont systemFontOfSize:10];
    deviceLabel.textColor=[UIColor whiteColor];
    [deviceButton addSubview:deviceLabel];
    
    UIButton *recordButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-20-128, suggestionLael4.frame.origin.y+suggestionLael4.frame.size.height+30, 128, 47)];
    [recordButton setBackgroundImage:[UIImage imageNamed:@"主页-上滑透明按钮"] forState:UIControlStateNormal];
    [thirdBG addSubview:recordButton];
    UIImageView *recordImageView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 7, 33, 33)];
    recordImageView.image=[UIImage imageNamed:@"主页-上滑记录"];
    [recordButton addSubview:recordImageView];
    UILabel *recordLabel=[[UILabel alloc]initWithFrame:CGRectMake(63, 6, 33, 33)];
    recordLabel.text=@"记录";
    recordLabel.textColor=[UIColor whiteColor];
    recordLabel.font=[UIFont systemFontOfSize:15];
    [recordButton addSubview:recordLabel];
    //底下的白色logo
    UIImageView *whiteLogo=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-22, deviceButton.frame.origin.y+deviceButton.frame.size.height+10, 44, 44)];
    whiteLogo.image=[UIImage imageNamed:@"主页-上滑白色logo"];
    [thirdBG addSubview:whiteLogo];
}

-(void) addPanGestureRecognizer {
    //[self.view addGestureRecognizer:panGestureRecognizer];
}
- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    
    // if you have left and right sidebar, you can control the pan gesture by start point.
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint startPoint = [recognizer locationInView:self.view];
        
        // Left SideBar
        if (startPoint.x < self.view.bounds.size.width / 2.0) {
            //self.sideBar.isCurrentPanGestureTarget = YES;
        }
        // Right SideBar
        else {
            if (!chvc) {
                chvc = [[CalendarHomeViewController alloc]init];
                chvc.calendartitle = @"飞机";
                [chvc setAirPlaneToDay:365 ToDateforString:nil];//飞机初始化方法
            }
            chvc.calendarblock = ^(CalendarDayModel *model){
                
                NSLog(@"\n---------------------------");
                NSLog(@"1星期 %@",[model getWeek]);
                NSLog(@"2字符串 %@",[model toString]);
                NSLog(@"3节日  %@",model.holiday);
            };
            [self.navigationController pushViewController:chvc animated:YES];
            // self.rightSideBar.isCurrentPanGestureTarget = YES;
        }
    }
    
    [self.sideBar handlePanGestureToShow:recognizer inView:self.view];
    
}
-(void)initSuggestion {
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickCountButton:(id)sender {
    //点击次数查看详情
    DetailsViewController *vc=[[DetailsViewController alloc]initWithNibName:@"DetailsViewController" bundle:nil];
    //vc.modalTransitionStyle=UIModalTransitionStylePartialCurl;
    [vc scrollToPage:0];
 [[SliderViewController sharedSliderController].navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickTimeButton:(id)sender {
    //点击次数查看时间
    DetailsViewController *vc=[[DetailsViewController alloc]initWithNibName:@"DetailsViewController" bundle:nil];
    [vc scrollToPage:1];
   // vc.modalTransitionStyle=UIModalTransitionStylePartialCurl;
 [[SliderViewController sharedSliderController].navigationController pushViewController:vc animated:YES];

}

- (IBAction)clickHzButton:(id)sender {
    //点击次数查看频率
    DetailsViewController *vc=[[DetailsViewController alloc]initWithNibName:@"DetailsViewController" bundle:nil];
    //vc.modalTransitionStyle=UIModalTransitionStylePartialCurl;
    [vc scrollToPage:4];
 [[SliderViewController sharedSliderController].navigationController pushViewController:vc animated:YES];

}

- (IBAction)clickRangeButton:(id)sender {
    //点击次数查看幅度
    DetailsViewController *vc=[[DetailsViewController alloc]initWithNibName:@"DetailsViewController" bundle:nil];
   // vc.modalTransitionStyle=UIModalTransitionStylePartialCurl;
    [vc scrollToPage:2];
 [[SliderViewController sharedSliderController].navigationController pushViewController:vc animated:YES];
    
}


- (IBAction)clickHeatButton:(id)sender {
    //点击查看热量
    DetailsViewController *vc=[[DetailsViewController alloc]initWithNibName:@"DetailsViewController" bundle:nil];
 [[SliderViewController sharedSliderController].navigationController pushViewController:vc animated:YES];
    [vc scrollToPage:3];
}

//开始实时统计用户数据
- (IBAction)clickStartButton:(id)sender {
    [self initBleControl];
    if (_bleControl.activePeripheral.state== CBPeripheralStateConnected) {
        NSLog(@"蓝牙已经连接,可以开始实时统计数据了");
        WaveViewController *vc=[[WaveViewController alloc]initWithNibName:@"WaveViewController" bundle:nil];
        [[SliderViewController sharedSliderController].navigationController pushViewController:vc animated:YES];
    }
    else {
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"您还未连接星爱哦" message:@"是否现在连接" delegate:self cancelButtonTitle:@"现在连接" otherButtonTitles:@"不了，谢谢", nil];
        alert.tag=0;
        //alert.delegate=self;
    [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(alertView.tag)
    {
            case 0:
            if (buttonIndex==0)
            {
                DeviceVC *vc=[[DeviceVC alloc]initWithNibName:@"DeviceVC" bundle:nil];
                vc.tagComingFromWhichVC=0;
                [[SliderViewController sharedSliderController].navigationController pushViewController:vc animated:YES];
            }
            break;
            case 1:
            if (buttonIndex==0)
            {
                DeviceVC *vc=[[DeviceVC alloc]initWithNibName:@"DeviceVC" bundle:nil];
                vc.tagComingFromWhichVC=1;
                [[SliderViewController sharedSliderController].navigationController pushViewController:vc animated:YES];
            }
            break;
            case 2:
            break;
            default:
            break;
    }
}

- (IBAction)clickSyButton:(id)sender {
    _bleControl=[BLEControl sharedBLEControl];
    if (_bleControl.activePeripheral.state==CBPeripheralStateDisconnected) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"您还未连接星爱哦" message:@"是否现在连接" delegate:self cancelButtonTitle:@"现在连接" otherButtonTitles:@"不了，谢谢", nil];
        alert.tag=1;
        [alert show];
    }
    else
    {
        [_bleControl synHistoryData];
    }
}

- (IBAction)clickShareButton:(id)sender {
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"还不能分享哦" message:@"待开发..." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    alert.tag=2;
    [alert show];
}

- (IBAction)clickCalendar {
    if (!chvc) {
        chvc = [[CalendarHomeViewController alloc]init];
        chvc.calendartitle = @"飞机";
        [chvc setAirPlaneToDay:365 ToDateforString:nil];//飞机初始化方法
    }
    chvc.calendarblock = ^(CalendarDayModel *model){
        
        NSLog(@"\n---------------------------");
        NSLog(@"选择了%@%@",[model toString],[model getWeek]);
        NSLog(@"\n---------------------------");
        
    };
    chvc.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
//    [self presentViewController:chvc animated:YES completion:^{}];
    [[SliderViewController sharedSliderController].navigationController pushViewController:chvc animated:YES];
}

- (IBAction)clickMenuButton:(id)sender {
    SliderViewController *slider=[SliderViewController sharedSliderController];
    [slider showLeftViewController];
}

- (IBAction)clickHaha:(id)sender {
    NSLog(@"啦啦啦啦啦啦啦啦啦啦啦啦");
}

- (IBAction)CountButton:(id)sender {
    NSLog(@"啦啦啦啦啦啦啦啦啦啦啦啦");
}

-(void)initScrollView
{
_mainScrollView=[[UIScrollView alloc]initWithFrame:self.view.bounds];
[self.view addSubview:_mainScrollView];
    [self.view insertSubview:_mainScrollView atIndex:1];
    
}

-(void)handelTapGesture:(UIGestureRecognizer*)recognizer
{
    [_Arc handelGesture:recognizer];
}
-(void)handelPanGesture:(UIGestureRecognizer*)recognizer
{
    if (recognizer.state==UIGestureRecognizerStateBegan) {
        CGPoint startPoint=[recognizer locationInView:_mainScrollView];
        if (startPoint.x>SCREEN_WIDTH/2.0) {
            [self clickCalendar];
        }
    }
}
-(void)initArcView {
    //金色 goldenColor
//    UIColor *goldenColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"金色-1"]];
    UIColor *goldenColor=[UIColor colorWithRed:206.0/255.0
                                         green:166.0/255.0
                                          blue:0.0
                                         alpha:1.0];
    _Arc=[[ArcView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) backColor:[UIColor clearColor] progressColor:goldenColor lineWidth:24.5];
     //_Arc.tapGesture.delegate=self;
    //[self.view insertSubview:_Arc atIndex:2];
    
    _Arc.delegate=self;
    
    [_mainScrollView insertSubview:_Arc atIndex:1];
}
-(void)initBgCircleView {
    _bgCircleImageView=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-275)/2, 96, 275, 275)];
    _bgCircleImageView.image=[UIImage imageNamed:@"主页大圆带刻度"];
   // [self.view insertSubview:_bgCircleImageView atIndex:1];
    [_mainScrollView insertSubview:_bgCircleImageView atIndex:0];
}
-(void)initButton {
    //次数按钮
    _countButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-(160-73), 115, 33, 33)];
    [_countButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_countButton addTarget:self action:@selector(clickCountButton:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:_countButton];
    //时间长度按钮
    _timeButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+(210-160),115, 33, 33)];
    [_timeButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_timeButton addTarget:self action:@selector(clickTimeButton:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:_timeButton];
    //频率按钮
    _HzButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-(160-32),247, 33, 33)];
    [_HzButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_HzButton addTarget:self action:@selector(clickHzButton:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:_HzButton];
    //幅度按钮
    _rangeButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+(254-160),247, 33, 33)];
    [_rangeButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_rangeButton addTarget:self action:@selector(clickRangeButton:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:_rangeButton];
    //热量按钮
    _heatButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-33/2,325, 33, 33)];
    [_heatButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_heatButton addTarget:self action:@selector(clickHeatButton:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:_heatButton];
    //菜单 日历 黄色logo
    _menuButton=[[UIButton alloc]initWithFrame:CGRectMake(20, 20, 44, 44)];
    [_menuButton setImage:[UIImage imageNamed:@"主页-菜单按钮"] forState:UIControlStateNormal];
    [_menuButton addTarget:self action:@selector(clickMenuButton:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:_menuButton];
    
    _canlendarButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-20-44, 20, 44, 44)];
    [_canlendarButton setImage:[UIImage imageNamed:@"主页-日历按钮"] forState:UIControlStateNormal];
    [_canlendarButton addTarget:self action:@selector(clickCalendar) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:_canlendarButton];
    
    UIImageView *logoView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-34, 20, 68, 68)];
    logoView.image=[UIImage imageNamed:@"全局logo"];
    [_mainScrollView addSubview:logoView];
    
    //中间的START按钮
    _startButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-42, 241, 84, 33)];
    [_startButton setImage:[UIImage imageNamed:@"主页-蓝色START"] forState:UIControlStateNormal];
    [_startButton addTarget:self action:@selector(clickStartButton:) forControlEvents:UIControlEventTouchUpInside];
    _startButton.tag=0;
    [_mainScrollView addSubview:_startButton];
    //同步和分享按钮
    _synButton=[[UIButton alloc]initWithFrame:CGRectMake(22, 358, 65, 65)];
    [_synButton setImage:[UIImage imageNamed:@"主页-同步未点亮"] forState:UIControlStateNormal];
    [_synButton addTarget:self action:@selector(clickSyButton:) forControlEvents:UIControlEventTouchUpInside];
    _synButton.tag=1;
    [_mainScrollView addSubview:_synButton];
    _shareButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-22-65, 358, 65, 65)];
    [_shareButton setImage:[UIImage imageNamed:@"主页-分享未点亮"] forState:UIControlStateNormal];
    [_shareButton addTarget:self action:@selector(clickShareButton:) forControlEvents:UIControlEventTouchUpInside];
    _shareButton.tag=2;
    [_mainScrollView addSubview:_shareButton];
    //底下的分隔横线
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 430, SCREEN_WIDTH, 3)];
    line.image=[UIImage imageNamed:@"主页底部-线"];
    [_mainScrollView addSubview:line];
    //底下的箭头
    UIImageView *arrow=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-25, 446, 50, 30)];
    arrow.image=[UIImage imageNamed:@"主页-上拉箭头"];
    [_mainScrollView addSubview:arrow];
}
//分数Label
-(void)initScoreLabel
{
    _score=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, 180, 100, 50)];
    _score.textAlignment=NSTextAlignmentCenter;
    _score.textColor=[UIColor colorWithRed:206.0/255.0
                                     green:166.0/255.0
                                      blue:0.0
                                      alpha:1.0];
    _score.text=@"0";
    _score.font=[UIFont systemFontOfSize:50];
    _score.backgroundColor=[UIColor clearColor];
    [_mainScrollView addSubview:_score];
    _score.hidden=NO;
}
//随手指滑动更新分数
-(void)updateScore
{
    NSInteger score=(NSInteger)_Arc.score;
    if (score>100) {
        score=100;
    }
    _score.text=[NSString stringWithFormat:@"%d",score];
};
//打分按钮
-(void)initMarkScoreButton
{
    _markScoreButton=[[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 180, 120, 50)];
    [_markScoreButton setTitle:@"打分" forState:UIControlStateNormal];
    UIColor *goldenColor=[UIColor colorWithRed:
                          206.0/255
                        green:166.0/255
                        blue:0.0
                        alpha:1.0];
    
    [_markScoreButton setTitleColor:goldenColor forState:UIControlStateNormal];
    _markScoreButton.backgroundColor=[UIColor clearColor];
    [_mainScrollView addSubview:_markScoreButton];
    [_markScoreButton addTarget:self action:@selector(clickMarkScoreButton) forControlEvents:UIControlEventTouchUpInside];
    _markScoreButton.titleLabel.font=[UIFont systemFontOfSize:40];
    _markScoreButton.titleLabel.textAlignment=NSTextAlignmentCenter;
    _markScoreButton.hidden=YES;
}

-(void)clickMarkScoreButton
{
    _markScoreButton.hidden=YES;
    //[_scoreField.textInputView becomeFirstResponder];
    _scoreField=[[UITextField alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, 180, 100, 50)];
    _scoreField.placeholder=@"请输入分数";
    _scoreField.borderStyle=UITextBorderStyleRoundedRect;
    _scoreField.keyboardType=UIKeyboardTypeNumberPad;
    _scoreField.returnKeyType= UIReturnKeyDone;
    _scoreField.clearButtonMode=UITextFieldViewModeWhileEditing;
    
   UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(260, 0, 50, 44)];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickFinishButton) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    view.backgroundColor=[UIColor blueColor];
    _scoreField.inputAccessoryView=view;
    [_mainScrollView addSubview:_scoreField];
    [self.view endEditing:YES];
    [_scoreField becomeFirstResponder];
}
//完成打分操作
-(void)clickFinishButton
{
    if ([_scoreField.text isEqualToString:@""]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"您还未输入分数"message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSInteger scoreData=[_scoreField.text integerValue];
    NSLog(@"用户给自己打分%ld",(long)scoreData);
    if (scoreData>100||scoreData<0) {
        _scoreField.text=@"";
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"您的输入有误"message:@"请输入0~100之间的整数" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
    }
    else {
    [_scoreField resignFirstResponder];
        _scoreField.hidden=YES;
        _score.text=_scoreField.text;
        _Arc.score=scoreData;
        [_Arc updateProgressCircle];
        _score.hidden=NO;
    }
}
-(void)initGesture {
//    _tapGesture=[[UITapGestureRecognizer alloc]
//                 initWithTarget:self action:@selector(handelGesture:)];
//    _tapGesture.cancelsTouchesInView = NO;
//    [self.view addGestureRecognizer:_tapGesture];
}

-(void) initBleControl {
    _bleControl=[BLEControl sharedBLEControl];
    [_bleControl addObserver:self forKeyPath:@"activePeripheralState" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"haha"];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    CGPoint location = [touch locationInView:self.view];
    CGFloat x=location.x;
    CGFloat y=location.y;
    CGFloat circleCenter_x=CGPointMake(SCREEN_WIDTH/2-2,96+275/2-9).x;
    CGFloat circleCenter_y=CGPointMake(SCREEN_WIDTH/2-2,96+275/2-9).y;
    //点击点到圆心的距离
    CGFloat distance=
    sqrt((x-circleCenter_x)*(x-circleCenter_x)
         +(y-circleCenter_y)*(y-circleCenter_y));
    if (distance>95||distance<(83-25-10)) {
        NSLog(@"点击越界了");
        return NO;
    }
    NSLog(@"%@",NSStringFromClass([touch.view class]));
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}

-(void)lightenAndPutOutButton {
    double delayInSconds=2.0;
    dispatch_time_t popTime1=dispatch_time(DISPATCH_TIME_NOW,(int64_t)(delayInSconds*NSEC_PER_SEC));
    dispatch_time_t popTime2=dispatch_time(DISPATCH_TIME_NOW,(int64_t)((delayInSconds+1)*NSEC_PER_SEC));
    dispatch_time_t popTime3=dispatch_time(DISPATCH_TIME_NOW,(int64_t)((delayInSconds+2)*NSEC_PER_SEC));
    dispatch_time_t popTime4=dispatch_time(DISPATCH_TIME_NOW,(int64_t)((delayInSconds+3)*NSEC_PER_SEC));
    dispatch_time_t popTime5=dispatch_time(DISPATCH_TIME_NOW,(int64_t)((delayInSconds+4)*NSEC_PER_SEC));

    dispatch_after(popTime1,dispatch_get_main_queue(),^(void) {
        [_HzButton setImage:[UIImage imageNamed:@"主页-内圆_频率点亮"] forState:UIControlStateNormal];
    });
    dispatch_after(popTime2,dispatch_get_main_queue(),^(void) {
        [_countButton setImage:[UIImage imageNamed:@"主页-内圆_次数点亮"] forState:UIControlStateNormal];
    });
    dispatch_after(popTime3,dispatch_get_main_queue(),^(void) {
        [_timeButton setImage:[UIImage imageNamed:@"主页-内圆_时间点亮"] forState:UIControlStateNormal];
    });
    
    dispatch_after(popTime4,dispatch_get_main_queue(),^(void) {
        [_rangeButton setImage:[UIImage imageNamed:@"主页-内圆_幅度点亮"] forState:UIControlStateNormal];
    });
    
    dispatch_after(popTime5,dispatch_get_main_queue(),^(void) {
        [_heatButton setImage:[UIImage imageNamed:@"主页-内圆_热量点亮"] forState:UIControlStateNormal];
    });
    
    dispatch_after(popTime1,dispatch_get_main_queue(),^(void) {
        [_synButton setImage:[UIImage imageNamed:@"主页-同步点亮"] forState:UIControlStateNormal];
    });
    
    dispatch_after(popTime2,dispatch_get_main_queue(),^(void) {
        [_shareButton setImage:[UIImage imageNamed:@"主页-分享点亮"] forState:UIControlStateNormal];
    });
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([(__bridge NSString*)context isEqualToString:@"statechanged"]) {
        NSLog(@"state changed!");
    }
    NSLog(@"%@,%@,%@,%@",keyPath,object,change,context);
    _markScoreButton.hidden=NO;
    _score.hidden=YES;
    _Arc.score=0;
}

@end
