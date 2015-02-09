//
//  WaveViewController.m
//  XingAi02
//
//  Created by Lihui on 14/11/14.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//

#import "WaveViewController.h"
#import "MainTabViewController.h"
#import "SliderViewController.h"
#import "UserScoreDAO.h"

@interface WaveViewController ()
{
    NSTimer *timer;
    NSTimer *setZeroTimer;
}
@property(nonatomic,retain)UILabel *sportsTime;
@property(nonatomic,retain)UILabel *sportsIntensity;
@property(nonatomic,retain)UILabel *sportsHz;
@property(nonatomic,retain)UILabel *sportsCount;

@property(nonatomic,retain)UILabel *sportsTimeData;
@property(nonatomic,retain)UILabel *sportsIntensityData;
@property(nonatomic,retain)UILabel *sportsHzData;
@property(nonatomic,retain)UILabel *sportsCountData;
@property(nonatomic,retain)UIButton *pauseButton;
@property(nonatomic,retain)UIButton *finishButton;

@end

@implementation WaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(clickReturnButton:)];

    _returnButton.userInteractionEnabled=NO;
    [self addObserver:[SliderViewController sharedSliderController].MainVC forKeyPath:@"isEndGetReciveData" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"Pass Contex"];
    _isEndGetReciveData=NO;
    // Do any additional setup after loading the view from its nib.
    _wave = [[DrawWave alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, 36+360)];
    _wave.clipsToBounds = YES;
    _wave.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_wave];
    
    UIImageView *scaleImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36)];
    
    scaleImageView.image=[UIImage imageNamed:@"主页-上滑标尺"];
    [_wave addSubview:scaleImageView];
    
    _wave1=[[DrawData alloc] initWithFrame:CGRectMake(0, 90+36, SCREEN_WIDTH, 360)];
    _wave1.clipsToBounds = YES;
    _wave1.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_wave1];
    
    timer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];
    //[self setTimerFire];
//    setZeroTimer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];
    _bleControl=[BLEControl sharedBLEControl];
    _bleControl.delegate=self;
    _label=[[UILabel alloc]initWithFrame:CGRectMake(20, 450, 280, 100)];
    //[self.view addSubview:_label];
    _label.backgroundColor=[UIColor clearColor];
    _label.text=@"0";
    _label.textAlignment=NSTextAlignmentCenter;
    _label.font=[UIFont systemFontOfSize:80];
    _label.textColor=[UIColor whiteColor];
    [self initLabel];
    [self initDataLabel];
    //开启一个后台线程，调用执行startReciveRealTimeData方法
    [self performSelectorInBackground:@selector(startReciveRealTimeData) withObject:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

-(void) initLabel
{
    _sportsTime=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+30, 165, SCREEN_WIDTH/2-70, 30)];
    _sportsTime.backgroundColor=[UIColor clearColor];
    _sportsTime.text=@"运动时间";
    _sportsTime.textAlignment=NSTextAlignmentLeft;
    _sportsTime.font=[UIFont systemFontOfSize:15];
    _sportsTime.textColor=[UIColor whiteColor];
    [self.view addSubview:_sportsTime];
    
    _sportsCount=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+30, 230, SCREEN_WIDTH/2-70, 30)];
    _sportsCount.backgroundColor=[UIColor clearColor];
    _sportsCount.text=@"运动次数";
    _sportsCount.textAlignment=NSTextAlignmentLeft;
    _sportsCount.font=[UIFont systemFontOfSize:15];
    _sportsCount.textColor=[UIColor whiteColor];
    [self.view addSubview:_sportsCount];
    
    _sportsIntensity=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+30, 305, SCREEN_WIDTH/2-70, 30)];
    _sportsIntensity.backgroundColor=[UIColor clearColor];
    _sportsIntensity.text=@"实时强度";
    _sportsIntensity.textAlignment=NSTextAlignmentLeft;
    _sportsIntensity.font=[UIFont systemFontOfSize:15];
    _sportsIntensity.textColor=[UIColor whiteColor];
    [self.view addSubview:_sportsIntensity];
    
    _sportsHz=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+30, 370, SCREEN_WIDTH/2-70, 30)];
    _sportsHz.backgroundColor=[UIColor clearColor];
    _sportsHz.text=@"实时频率";
    _sportsHz.textAlignment=NSTextAlignmentLeft;
    _sportsHz.font=[UIFont systemFontOfSize:15];
    _sportsHz.textColor=[UIColor whiteColor];
    [self.view addSubview:_sportsHz];

}
-(void)initDataLabel
{
    _sportsTimeData=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+30, 185, SCREEN_WIDTH/2-70, 30)];
    _sportsTimeData.backgroundColor=[UIColor clearColor];
    _sportsTimeData.text=[self transformTimeFormat:_bleControl.sportsSeconds];
    _sportsTimeData.textAlignment=NSTextAlignmentLeft;
   _sportsTimeData.font=[UIFont systemFontOfSize:20];
   _sportsTimeData.textColor=[UIColor colorWithRed:224.0/255 green:184.0/255 blue:25.0/255 alpha:1.0];
   [self.view addSubview:_sportsTimeData];
    
    _sportsCountData=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+30, 250, 60, 30)];
    _sportsCountData.backgroundColor=[UIColor clearColor];
    _sportsCountData.text=@"0";
    _sportsCountData.textAlignment=NSTextAlignmentLeft;
    _sportsCountData.font=[UIFont systemFontOfSize:20];
    _sportsCountData.textColor=[UIColor colorWithRed:224.0/255 green:184.0/255 blue:25.0/255 alpha:1.0];
    [self.view addSubview:_sportsCountData];
    
    _sportsIntensityData=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+30, 325, 60, 30)];
    _sportsIntensityData.backgroundColor=[UIColor clearColor];
    _sportsIntensityData.text=@"0";
    _sportsIntensityData.textAlignment=NSTextAlignmentLeft;
    _sportsIntensityData.font=[UIFont systemFontOfSize:20];
    _sportsIntensityData.textColor=[UIColor colorWithRed:224.0/255 green:184.0/255 blue:25.0/255 alpha:1.0];
    [self.view addSubview:_sportsIntensityData];
    
    _sportsHzData=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+30, 390, SCREEN_WIDTH/2-70, 30)];
   _sportsHzData.textColor=[UIColor colorWithRed:224.0/255 green:184.0/255 blue:25.0/255 alpha:1.0];
    _sportsHzData.text=@"0";
    _sportsHzData.textAlignment=NSTextAlignmentLeft;
   _sportsHzData.font=[UIFont systemFontOfSize:18];
    _sportsHzData.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_sportsHzData];
    
    _pauseButton=[[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-66)/2, 425+36-3-40, 66, 66)];
//    [StopButton setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    [self.view addSubview:_pauseButton];
    [_pauseButton setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
//    [_pauseButton setTitle:@"暂 停" forState:UIControlStateNormal];
//    [_pauseButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [_pauseButton addTarget:self action:@selector(clickPauseButton) forControlEvents:UIControlEventTouchUpInside];
    
    _finishButton=[[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-60)/2+80, 425+36-3, 60, 33)];
    //    [StopButton setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    [self.view addSubview:_finishButton];
    [_finishButton setTitle:@"完 成" forState:UIControlStateNormal];
    [_finishButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_finishButton addTarget:self action:@selector(clickFinishButton) forControlEvents:UIControlEventTouchUpInside];
}

-(void)clickPauseButton {
    if ([_pauseButton.imageView.image isEqual:[UIImage imageNamed:@"暂停"]]) {
        [_pauseButton setImage:[UIImage imageNamed:@"开始"] forState:UIControlStateNormal];
        [_bleControl endReciveRealTimeData];
    }
    else {
        [_pauseButton setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
        [_bleControl getRealTimeData];
    }
//    if ([_pauseButton.titleLabel.text isEqualToString:@"暂 停"]) {
//        [_bleControl endReciveRealTimeData];
//        [_pauseButton setTitle:@"开 始" forState:UIControlStateNormal];
//        [_pauseButton setImage:[UIImage imageNamed:@"开始"] forState:UIControlStateNormal];
//    }
//    else if([_pauseButton.titleLabel.text isEqualToString:@"开 始"])
//    {
//        [_bleControl getRealTimeData];
//        [_pauseButton setTitle:@"暂 停" forState:UIControlStateNormal];
//        [_pauseButton setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
//
//    }
}

-(void)clickFinishButton
{
    [_bleControl finishRealTimeSports];
    _pauseButton.userInteractionEnabled=NO;
    _returnButton.userInteractionEnabled=YES;
    _finishButton.userInteractionEnabled=NO;
    
    self.isEndGetReciveData=YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
    _bleControl.delegate=nil;
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"请您对本次结果打分"message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    //先存个默认的分数0分
    dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self saveZeroInUserScoreCoreDate];
    });
}

-(void)addCountNum:(NSInteger)num
         Intensity:(float)intensity
                Hz:(float)hz
{
    _sportsCountData.text=[NSString stringWithFormat:@"%ld",(long)num];
    _sportsIntensityData.text
    =[NSString stringWithFormat:@"%0.1f",intensity];
    _sportsHzData.text=[NSString stringWithFormat:@"%0.1f",hz];
    
}

-(void)renewSportsTime {
    NSString *timeStr=[self transformTimeFormat:_bleControl.sportsSeconds];
    _sportsTimeData.text=timeStr;
}

-(void)detectionVoice
{
  //[_wave callDraw:1];
  [_wave1 addZeroNum];
}
//清零
-(void)setDataLabelZero
{
        double delayInSeconds = 5.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            _sportsHzData.text=@"0";
            _sportsCountData.text=@"0";
            _sportsIntensityData.text=@"0";
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//关闭定时器
-(void)setTimerFire {
    [timer setFireDate:[NSDate distantFuture]];
}

//开启定时器
-(void)setTimerRun {
    [timer setFireDate:[NSDate distantPast]];
}

//关闭定时器
-(void)setZeroTimerFire {
    [setZeroTimer setFireDate:[NSDate distantFuture]];
}

//开启定时器
-(void)setZeroTimerRun {
    [setZeroTimer setFireDate:[NSDate distantPast]];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickStartButton:(id)sender {
    if(_bleControl.activePeripheral) {
        //CBPeripheral *xx=_bleControl.activePeripheral;
        //NSLog(@"%@",xx.name);
//        [self.bleControl getRealTimeData];
        [self.bleControl endReciveRealTimeData];
//        if ([self.startButton.titleLabel.text isEqualToString:@"开始"]) {
//            [self.startButton setTitle:@"结束" forState:UIControlStateNormal];
//            [self.bleControl getRealTimeData];
//        }
//        else {
//             [self.startButton setTitle:@"开始" forState:UIControlStateNormal];
//            [self.bleControl endReciveRealTimeData];
//             }
//
    }
}

//开始接收蓝牙实时数据
-(void) startReciveRealTimeData
{
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue,^{
        [_bleControl getRealTimeData];
    });
}

- (IBAction)clickReturnButton:(id)sender {
    //[_bleControl endReciveRealTimeData];
    self.isEndGetReciveData=YES;
[self.navigationController popToRootViewControllerAnimated:YES];
    _bleControl.delegate=nil;
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"请您对本次结果打分"message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    //先存个默认的分数0分
    dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self saveZeroInUserScoreCoreDate];
    });
}

//时间转换器
-(NSString*)transformTimeFormat:(NSInteger)seconds
{
    NSInteger hour=seconds/3600;
    NSInteger minute=(seconds%3600)/60;
    NSInteger second=seconds%60;
    
    NSString *hourStr=hour<10?[NSString stringWithFormat:@"0%ld",(long)hour]:[NSString stringWithFormat:@"%ld",(long)hour];
    NSString *minuteStr=minute<10?[NSString stringWithFormat:@"0%ld",(long)minute]:[NSString stringWithFormat:@"%ld",(long)minute];
    NSString *secondStr=second<10?[NSString stringWithFormat:@"0%ld",(long)second]:[NSString stringWithFormat:@"%ld",(long)second];
    NSString *text=[NSString stringWithFormat:@"%@:%@:%@",hourStr,minuteStr,secondStr];
    return text;
}

-(BOOL)saveZeroInUserScoreCoreDate
{
    UserScoreDAO *DAO=[UserScoreDAO shareManager];
    UserScore *data=[[UserScore alloc]init];
    data.score=[NSNumber numberWithInt:0];
    data.date=[NSDate date];
    if([DAO create:data]==0) {
        NSLog(@"这个默认的分数0保存了");
        return YES;
    }
    else return NO;
}
-(void)autoPopCurrentVC
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"请您对本次结果打分"message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    _bleControl.delegate=nil;
}
@end
