//
//  DetailsViewController.m
//  XingAi02
//
//  Created by Lihui on 14/11/10.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//

#import "DetailsViewController.h"
#import "SportsDataDAO.h"
#import "ResultDataDAO.h"

@interface DetailsViewController ()<UIScrollViewDelegate>
{
    NSInteger flag;
}

@property(retain,nonatomic)UILabel *count;
@property(retain,nonatomic)UILabel *time;
@property(retain,nonatomic)UILabel *intensity;
@property(retain,nonatomic)UILabel *heat;
@property(retain,nonatomic)UILabel *Hz;

@end
@implementation DetailsViewController

//-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    if (self) {
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    _mainScrollView.delegate=self;
    _mainScrollView.pagingEnabled=YES;
    _mainScrollView.contentSize=CGSizeMake(self.view.frame.size.width*5, self.view.frame.size.height);
    _mainScrollView.showsHorizontalScrollIndicator=YES;
    _mainScrollView.showsVerticalScrollIndicator=NO;
    [self initView];
    [self initLabel];
}

-(void)initView {
    //次数页面
    _countView = [[[NSBundle mainBundle] loadNibNamed:@"PageView" owner:self options:nil] lastObject];
    UIImageView *flagView = (UIImageView*)[_countView viewWithTag:1];
    flagView.image=[UIImage imageNamed:@"详细-次数"];
    _countView.frame = CGRectMake( 0,  0,  _mainScrollView.frame.size.width,  _mainScrollView.frame.size.height);
    _countView.backgroundColor=[UIColor clearColor];
    [_mainScrollView addSubview:_countView];
    //时间页面
    _timeView = [[[NSBundle mainBundle] loadNibNamed:@"PageView" owner:self options:nil] lastObject];
    flagView=(UIImageView*)[_timeView viewWithTag:1];
    flagView.image=[UIImage imageNamed:@"详细-时长"];
    _timeView.frame = CGRectMake( _mainScrollView.frame.size.width, 0,  _mainScrollView.frame.size.width,  _mainScrollView.frame.size.height);
    _timeView.backgroundColor=[UIColor clearColor];
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, 340, 100, 50)];
    timeLabel.backgroundColor=[UIColor clearColor];
    timeLabel.text=@"时长";
    timeLabel.font=[UIFont systemFontOfSize:50];
    timeLabel.textColor=[UIColor colorWithRed:224.0/255 green:184.0/255 blue:25.0/255 alpha:1.0];
    [_timeView addSubview:timeLabel];
    [_mainScrollView addSubview:_timeView];
    //幅度页面
    _rangeView=[[[NSBundle mainBundle] loadNibNamed:@"PageView" owner:self options:nil] lastObject];
    flagView=(UIImageView*)[_rangeView viewWithTag:1];
    flagView.image=[UIImage imageNamed:@"详细-幅度"];
    _rangeView.frame = CGRectMake( _mainScrollView.frame.size.width*2, 0,  _mainScrollView.frame.size.width,  _mainScrollView.frame.size.height);
    _rangeView.backgroundColor=[UIColor clearColor];
    [_mainScrollView addSubview:_rangeView];
    
    _heatView=[[[NSBundle mainBundle] loadNibNamed:@"PageView" owner:self options:nil] lastObject];
    flagView=(UIImageView*)[_heatView viewWithTag:1];
    flagView.image=[UIImage imageNamed:@"详细-热量"];
    _heatView.frame = CGRectMake( _mainScrollView.frame.size.width*3, 0,  _mainScrollView.frame.size.width,  _mainScrollView.frame.size.height);
    _heatView.backgroundColor=[UIColor clearColor];
    [_mainScrollView addSubview:_heatView];
    
    _HzView=[[[NSBundle mainBundle] loadNibNamed:@"PageView" owner:self options:nil] lastObject];
    flagView=(UIImageView*)[_HzView viewWithTag:1];
    flagView.image=[UIImage imageNamed:@"详细-频率"];
    _HzView.frame = CGRectMake( _mainScrollView.frame.size.width*4, 0,  _mainScrollView.frame.size.width,  _mainScrollView.frame.size.height);
    _HzView.backgroundColor=[UIColor clearColor];
    [_mainScrollView addSubview:_HzView];
    [self movePosition];
}
-(void)scrollToPage:(NSInteger)n {
    CGPoint p = CGPointZero;
    flag=n;
    p.x = _mainScrollView.frame.size.width*n;
    p.x=(SCREEN_WIDTH)*n;
    NSLog(@"n=%d",n);
    NSLog(@"%f,%f",_mainScrollView.frame.size.width,_mainScrollView.frame.size.width*n);
    NSLog(@"p.x=%f,p.y=%f",p.x,p.y);
}

-(void)movePosition
{
    CGPoint p = CGPointZero;
    p.x = _mainScrollView.frame.size.width*flag;
    [_mainScrollView setContentOffset:p animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickReturnButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initLabel
{
    _count=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 120, 200, 200)];
    _count.text=@"";
    _count.textColor=[UIColor colorWithRed:224.0/255 green:184.0/255 blue:25.0/255 alpha:1.0];
    _count.textAlignment=NSTextAlignmentCenter;
    _count.font=[UIFont systemFontOfSize:100];
    [_countView addSubview:_count];
    //次数两个大字
    UILabel *CountLabel=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, 340, 100, 50)];
    CountLabel.text=@"次数";
    CountLabel.textColor=[UIColor colorWithRed:224.0/255 green:184.0/255 blue:25.0/255 alpha:1.0];
    CountLabel.font=[UIFont systemFontOfSize:45];
    CountLabel.textAlignment=NSTextAlignmentCenter;
    [_countView addSubview:CountLabel];
    
    _time=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 120, 200, 200)];
    _time.text=@"";
    _time.textColor=[UIColor colorWithRed:224.0/255 green:184.0/255 blue:25.0/255 alpha:1.0];
    _time.textAlignment=NSTextAlignmentCenter;
    _time.font=[UIFont systemFontOfSize:50];
    [_timeView addSubview:_time];
    
    _intensity=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 120, 200, 200)];
     _intensity.text=@"";
     _intensity.textColor=[UIColor whiteColor];
     _intensity.textAlignment=NSTextAlignmentCenter;
     _intensity.font=[UIFont systemFontOfSize:100];
   // [_rangeView addSubview:_intensity];
    
    //最大强度和平均强度
    UILabel *maxIntensity=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 140, 120, 40)];
    maxIntensity.text=@"最大强度(G)";
    maxIntensity.backgroundColor=[UIColor clearColor];
    maxIntensity.textAlignment=NSTextAlignmentCenter;
    maxIntensity.textColor=[UIColor colorWithRed:224.0/255 green:184.0/255 blue:25.0/255 alpha:1.0];
    maxIntensity.font=[UIFont systemFontOfSize:20];
    [_rangeView addSubview:maxIntensity];
    
    UILabel *maxIntensityData=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, 165, 100, 40)];
    maxIntensityData.text=@"";
    maxIntensityData.textAlignment=NSTextAlignmentCenter;
    maxIntensityData.textColor=[UIColor colorWithRed:224.0/255 green:184.0/255 blue:25.0/255 alpha:1.0];
    maxIntensityData.backgroundColor=[UIColor clearColor];
    [_rangeView addSubview:maxIntensityData];
    
    UILabel *averageIntensityData=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, 265, 100, 40)];
    averageIntensityData.text=@"";
    averageIntensityData.textAlignment=NSTextAlignmentCenter;
    averageIntensityData.textColor=[UIColor colorWithRed:224.0/255 green:184.0/255 blue:25.0/255 alpha:1.0];
    averageIntensityData.backgroundColor=[UIColor clearColor];
    [_rangeView addSubview:averageIntensityData];
    
    UILabel *averageIntensity=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 240, 120, 40)];
    averageIntensity.text=@"平均强度(G)";
    averageIntensity.textAlignment=NSTextAlignmentCenter;
    averageIntensity.backgroundColor=[UIColor clearColor];
    averageIntensity.textColor=[UIColor colorWithRed:224.0/255 green:184.0/255 blue:25.0/255 alpha:1.0];
    averageIntensity.font=[UIFont systemFontOfSize:20];
    [_rangeView addSubview:averageIntensity];
    
    //下面写强度两个大字
    UILabel *IntensityLabel=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, 340, 100, 50)];
    IntensityLabel.text=@"强度";
    IntensityLabel.textColor=[UIColor colorWithRed:224.0/255 green:184.0/255 blue:25.0/255 alpha:1.0];
    IntensityLabel.font=[UIFont systemFontOfSize:45];
    IntensityLabel.textAlignment=NSTextAlignmentCenter;
    [_rangeView addSubview:IntensityLabel];
    _heat=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 120, 200, 200)];
    _heat.text=@"";
    _heat.textColor=[UIColor colorWithRed:224.0/255 green:184.0/255 blue:25.0/255 alpha:1.0];
    _heat.textAlignment=NSTextAlignmentCenter;
    _heat.font=[UIFont systemFontOfSize:40];
    [_heatView addSubview:_heat];
    
    _Hz=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 120, 200, 200)];
    _Hz.text=@"";
    _Hz.textColor=[UIColor colorWithRed:224.0/255 green:184.0/255 blue:25.0/255 alpha:1.0];
    _Hz.textAlignment=NSTextAlignmentCenter;
    _Hz.font=[UIFont systemFontOfSize:40];
    //[_HzView addSubview:_Hz];
    //最大频率、平均频率
    UILabel *maxHz=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 140, 120, 40)];
    maxHz.text=@"最大频率";
    maxHz.backgroundColor=[UIColor clearColor];
    maxHz.textAlignment=NSTextAlignmentCenter;
    maxHz.font=[UIFont systemFontOfSize:20];
    maxHz.textColor=[UIColor colorWithRed:224.0/255 green:184.0/255 blue:25.0/255 alpha:1.0];
    [_HzView addSubview:maxHz];
    
    UILabel *maxHzData=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, 165, 100, 40)];
    maxHzData.text=@"";
    maxHzData.textAlignment=NSTextAlignmentCenter;
    maxHzData.textColor=[UIColor colorWithRed:224.0/255 green:184.0/255 blue:25.0/255 alpha:1.0];
    maxHzData.backgroundColor=[UIColor clearColor];
    maxHzData.font=[UIFont systemFontOfSize:20];
    [_HzView addSubview:maxHzData];
    
    UILabel *averageHzData=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, 265, 100, 40)];
    averageHzData.text=@"";
    averageHzData.textAlignment=NSTextAlignmentCenter;
    averageHzData.textColor=[UIColor colorWithRed:224.0/255 green:184.0/255 blue:25.0/255 alpha:1.0];
    averageHzData.backgroundColor=[UIColor clearColor];
    averageHzData.font=[UIFont systemFontOfSize:20];
    [_HzView addSubview:averageHzData];
    
    UILabel *averageHz=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 240, 120, 40)];
    averageHz.text=@"平均频率";
    averageHz.textAlignment=NSTextAlignmentCenter;
    averageHz.backgroundColor=[UIColor clearColor];
    averageHz.textColor=[UIColor colorWithRed:224.0/255 green:184.0/255 blue:25.0/255 alpha:1.0];
    averageHz.font=[UIFont systemFontOfSize:20];
    [_HzView addSubview:averageHz];
    //频率两个大字
    UILabel *HZLabel=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, 340, 100, 50)];
    HZLabel.text=@"频率";
    HZLabel.textColor=[UIColor colorWithRed:224.0/255 green:184.0/255 blue:25.0/255 alpha:1.0];
    HZLabel.font=[UIFont systemFontOfSize:45];
    HZLabel.textAlignment=NSTextAlignmentCenter;
    [_HzView addSubview:HZLabel];
    //热量
    //下面写热量两个大字
    UILabel *HeatLabel=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, 340, 100, 50)];
    HeatLabel.text=@"热量";
    HeatLabel.textColor=[UIColor colorWithRed:224.0/255 green:184.0/255 blue:25.0/255 alpha:1.0];
    HeatLabel.font=[UIFont systemFontOfSize:45];
    HeatLabel.textAlignment=NSTextAlignmentCenter;
    [_heatView addSubview:HeatLabel];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue,^{
        ResultData *data=[self getLastResultData];
        
        NSInteger maxIntensity=[data.maxIn floatValue];
        CGFloat averageIntensity=[data.averageIn floatValue];
        CGFloat max_Hz=[data.maxHz floatValue];
        CGFloat average_Hz=[data.averageHz floatValue];
        
        dispatch_async(dispatch_get_main_queue(),
        ^{
        _count.text=[NSString stringWithFormat:@"%ld",(long)[data.totalCount integerValue]];
        _time.text=[self transformTimeFormat:[data.totalTime integerValue]];
//        _intensity.text=[NSString stringWithFormat:@"%ld",(long)[data.intensity integerValue]];
        _heat.text=[NSString stringWithFormat:@"%0.1f",[data.totalHeat floatValue]];
//        _Hz.text=[NSString stringWithFormat:@"%0.1f",[theLastData.hz floatValue]];
            
            maxIntensityData.text=[NSString stringWithFormat:@"%ld",(long)maxIntensity];
            averageIntensityData.text=[NSString stringWithFormat:@"%0.1f",averageIntensity];
            maxHzData.text
            =[NSString stringWithFormat:@"%0.1f",max_Hz];
            averageHzData.text=[NSString stringWithFormat:@"%0.1f",average_Hz];
        });
    });
}
#pragma mark--获取最近一次的ResultData
-(ResultData*)getLastResultData
{
    ResultDataDAO *DAO=[ResultDataDAO shareManager];
    NSMutableArray *dataList=  [DAO findAll];
    ResultData *data=[dataList lastObject];
    return data;
}

-(SportsData*)getLastDataFromCoreDate
{
    SportsDataDAO *DAO=[SportsDataDAO shareManager];
    NSMutableArray *dataList=[DAO findAll];
    SportsData *theLastData=[dataList lastObject];
    return theLastData;
}

-(CGFloat)getLastGroupAverageCount
{
    SportsDataDAO *DAO=[SportsDataDAO shareManager];
    NSMutableArray *dataList=[DAO findAll];
    SportsData *theLastData=[dataList lastObject];
    //获取这组数据的最终次数
    NSInteger count=[theLastData.count integerValue];
    NSMutableArray *theLastGroupData=[[NSMutableArray alloc]init];
    for (NSInteger i=([dataList count]-count); i<[dataList count]; i++) {
        [theLastGroupData addObject:[dataList objectAtIndex:i]];
    }
    NSInteger sum=0;
    CGFloat average=0.f;
    for(NSInteger i=0;i<[theLastGroupData count];i++)
    {
        SportsData* data=[theLastGroupData objectAtIndex:i];
        sum=sum+[data.intensity integerValue];
    }
    average=(CGFloat)sum/([theLastGroupData count]);
    return average;
}

-(NSInteger)getLastGroupMaxCount
{
    SportsDataDAO *DAO=[SportsDataDAO shareManager];
    NSMutableArray *dataList=[DAO findAll];
    SportsData *theLastData=[dataList lastObject];
    //获取这组数据的最终次数
    NSInteger count=[theLastData.count integerValue];
    NSMutableArray *theLastGroupData=[[NSMutableArray alloc]init];
    for (NSInteger i=([dataList count]-count); i<[dataList count]; i++) {
        [theLastGroupData addObject:[dataList objectAtIndex:i]];
    }
    NSInteger max=0;
    for(NSInteger i=0;i<[theLastGroupData count];i++)
    {
        SportsData* data=[theLastGroupData objectAtIndex:i];
        if ([data.intensity integerValue]>max) {
           max=[data.intensity integerValue];
        }
    }
    return max;
}

-(float)getLastGroupMaxHz
{
    SportsDataDAO *DAO=[SportsDataDAO shareManager];
    NSMutableArray *dataList=[DAO findAll];
    SportsData *theLastData=[dataList lastObject];
    //获取这组数据的最终次数
    NSInteger count=[theLastData.count integerValue];
    NSMutableArray *theLastGroupData=[[NSMutableArray alloc]init];
    for (NSInteger i=([dataList count]-count); i<[dataList count]; i++) {
        [theLastGroupData addObject:[dataList objectAtIndex:i]];
    }
    float max=0.f;
    for(NSInteger i=0;i<[theLastGroupData count];i++)
    {
        SportsData* data=[theLastGroupData objectAtIndex:i];
        if ([data.hz floatValue]>max) {
            max=[data.hz floatValue];
        }
    }
    return max;
}

-(CGFloat)getLastGroupAverageHz
{
    SportsDataDAO *DAO=[SportsDataDAO shareManager];
    NSMutableArray *dataList=[DAO findAll];
    SportsData *theLastData=[dataList lastObject];
    //获取这组数据的最终次数
    NSInteger count =[theLastData.count integerValue];
    NSMutableArray *theLastGroupData=[[NSMutableArray alloc]init];
    for (NSInteger i=([dataList count]-count); i<[dataList count]; i++) {
        [theLastGroupData addObject:[dataList objectAtIndex:i]];
    }
     float sum=0.f;
    CGFloat average=0.f;
    for(NSInteger i=0;i<[theLastGroupData count];i++)
    {
        SportsData* data=[theLastGroupData objectAtIndex:i];
        sum=sum+[data.hz floatValue];
    }
    average=sum/([theLastGroupData count]);
    return average;
}

#pragma mark-- 时间选择器
-(NSString*)transformTimeFormat:(NSInteger)seconds
{
    NSInteger hour=seconds/3600;
    NSInteger minute=(seconds%3600)/60;
    NSInteger second=seconds%60;
    
    NSString *hourStr=hour<10?[NSString stringWithFormat:@"0%d",hour]:[NSString stringWithFormat:@"%d",hour];
    NSString *minuteStr=minute<10?[NSString stringWithFormat:@"0%d",minute]:[NSString stringWithFormat:@"%d",minute];
    NSString *secondStr=second<10?[NSString stringWithFormat:@"0%d",second]:[NSString stringWithFormat:@"%d",second];
    NSString *text=[NSString stringWithFormat:@"%@:%@:%@",hourStr,minuteStr,secondStr];
    return text;
}
@end
