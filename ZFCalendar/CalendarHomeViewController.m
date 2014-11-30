//
//  CalendarHomeViewController.m
//  Calendar
//
//  Created by Lihui on 14-6-23.
//  Copyright (c) 2014年 张凡. All rights reserved.
//


#import "CalendarHomeViewController.h"
#import "Color.h"
#import "UIWindow+YzdHUD.h"
#import "SliderViewController.h"
#define CATDayLabelWidth  40.0f
#define CATDayLabelHeight 20.0f
@interface CalendarHomeViewController ()
{

    
    int daynumber;//天数
    int optiondaynumber;//选择日期数量
//    NSMutableArray *optiondayarray;//存放选择好的日期对象数组
    
}
@property (weak, nonatomic) UILabel *day1OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day2OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day3OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day4OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day5OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day6OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day7OfTheWeekLabel;
@property (retain,nonatomic)UIView  *weekView;
@property (retain,nonatomic)UIImageView *bottom;
@property (retain,nonatomic)UILabel *currentMonthData;
@property (retain,nonatomic)UILabel *totalData;
@end

@implementation CalendarHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    UIButton *returnButton=[[UIButton alloc]initWithFrame:CGRectMake(5, 20, 44, 44)];
    [returnButton setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [self.view addSubview:returnButton];
    [returnButton addTarget:self action:@selector(clickReturnButton) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor=[UIColor clearColor];
    UIImageView *bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    bgImageView.image=[UIImage imageNamed:@"侧边栏背景图-568h"];
    [self.view insertSubview:bgImageView atIndex:0];
    //中间加标题:
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-60)/2, 20, 60, 44)];
    title.text=@"记录";
    title.textColor=[UIColor blackColor];
    title.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:title];
    // 添加星期栏
    _weekView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 30)];
    _weekView.backgroundColor=[UIColor redColor];
    [self.view addSubview:_weekView];
    [self addWeekLabel];
    //底部添加黑色条
    _bottom=[[UIImageView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-75, SCREEN_WIDTH, 75)];
    _bottom.image=[UIImage imageNamed:@"历史记录-日历底部背景"];
    [self.view addSubview:_bottom];
    [self addLabelOnBottom];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) addLabelOnBottom
{
    UILabel *currentMonth=[[UILabel alloc]initWithFrame:CGRectMake(88, 50, 30, 21)];
    currentMonth.textAlignment=NSTextAlignmentCenter;
    currentMonth.text=@"本月";
    currentMonth.font=[UIFont systemFontOfSize:15];
    currentMonth.textColor=[UIColor colorWithRed:87.0/255 green:154.0/255 blue:243.0/255 alpha:1.0];
    [_bottom addSubview:currentMonth];
    
    UILabel *total=[[UILabel alloc]initWithFrame:CGRectMake(206, 50,30 ,21)];
    total.text=@"总计";
    total.textAlignment=NSTextAlignmentCenter;
    total.font=[UIFont systemFontOfSize:15];
    total.textColor=[UIColor colorWithRed:87.0/255 green:154.0/255 blue:243.0/255 alpha:1.0];
    [_bottom addSubview:total];

    _currentMonthData=[[UILabel alloc]initWithFrame:CGRectMake(53, 15, 100, 30)];
    _currentMonthData.textAlignment=NSTextAlignmentCenter;
    _currentMonthData.font=[UIFont systemFontOfSize:25];
    _currentMonthData.textColor=[UIColor colorWithRed:87.0/255 green:154.0/255 blue:243.0/255 alpha:1.0];
    [_bottom addSubview:_currentMonthData];
    
    _totalData=[[UILabel alloc]initWithFrame:CGRectMake(171, 15, 100, 30)];
   _totalData.textAlignment=NSTextAlignmentCenter;
    _totalData.font=[UIFont systemFontOfSize:25];
   _totalData.textColor=[UIColor colorWithRed:87.0/255 green:154.0/255 blue:243.0/255 alpha:1.0];
    [_bottom addSubview:_totalData];
    
}
#pragma mark - 设置方法

//飞机初始化方法  传365和nil
- (void)setAirPlaneToDay:(int)day ToDateforString:(NSString *)todate
{
    //计算本月的运动次数
    dispatch_queue_t queue1=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue1, ^{
        NSDate *today=[NSDate date];
    NSDateComponents *components=[today YMDComponents];
        int year= [components year];
        int month=[components month];
        CalendarLogic *logic=[[CalendarLogic alloc]init];
      int currentMonthData=  [[logic findDataFromCoreDataWithYearAndMonth:year Month:month] count];
        int allData= [[logic findAllSportsDataFromCoreData] count];
        dispatch_async(dispatch_get_main_queue(), ^{
            _currentMonthData.text=[NSString stringWithFormat:@"%d",currentMonthData];
            _totalData.text=[NSString stringWithFormat:@"%d",allData];
            
        });
        
    });
    [[SliderViewController sharedSliderController].view.window
      showHUDWithText:@"数据加载中" Type:ShowLoading Enabled:YES];
     
       dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{ daynumber = day;//天数
        optiondaynumber = 1;//选择一个后返回数据对象
        super.calendarMonth = [self getMonthArrayOfDayNumber:daynumber ToDateforString:todate];
        dispatch_async(dispatch_get_main_queue(),^{
            [super.collectionView reloadData];//刷新
            [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];

});
    });
}

//酒店初始化方法
- (void)setHotelToDay:(int)day ToDateforString:(NSString *)todate
{

    daynumber = day;
    optiondaynumber = 2;//选择两个后返回数据对象
    super.calendarMonth = [self getMonthArrayOfDayNumber:daynumber ToDateforString:todate];
    [super.collectionView reloadData];//刷新
}


//火车初始化方法
- (void)setTrainToDay:(int)day ToDateforString:(NSString *)todate
{
    daynumber = day;
    optiondaynumber = 1;//选择一个后返回数据对象
    super.calendarMonth = [self getMonthArrayOfDayNumber:daynumber ToDateforString:todate];
    [super.collectionView reloadData];//刷新
    
}



#pragma mark - 逻辑代码初始化

//获取时间段内的天数数组
- (NSMutableArray *)getMonthArrayOfDayNumber:(int)day ToDateforString:(NSString *)todate
{
    
    NSDate *date = [NSDate date];
    
    NSDate *selectdate  = [NSDate date];
    
    if (todate) {
        
        selectdate = [selectdate dateFromString:todate];
        
    }
    
    super.Logic = [[CalendarLogic alloc]init];
    
    return [super.Logic reloadCalendarView:date selectDate:selectdate  needDays:day];
}



#pragma mark - 设置标题

- (void)setCalendartitle:(NSString *)calendartitle
{

   // [self.navigationItem setTitle:calendartitle];

}

-(void)clickReturnButton
{
//    [self.navigationController popViewControllerAnimated:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    
    // if you have left and right sidebar, you can control the pan gesture by start point.
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint startPoint = [recognizer locationInView:self.view];
        // Left SideBar
        if (startPoint.x < self.view.bounds.size.width / 2.0) {
            //[self.navigationController popViewControllerAnimated:YES];
             [self.navigationController popViewControllerAnimated:YES];
        }
        // Right SideBar
        else
        {
        }
    }
}

//一，二，三，四，五，六，日
-(void)addWeekLabel
{
    CGFloat xOffset = 5.0f;
    CGFloat yOffset = 0.0f;
    
UILabel *dayOfTheWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, CATDayLabelWidth, CATDayLabelHeight)];
[dayOfTheWeekLabel setBackgroundColor:[UIColor clearColor]];
[dayOfTheWeekLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
self.day1OfTheWeekLabel = dayOfTheWeekLabel;
self.day1OfTheWeekLabel.textAlignment = NSTextAlignmentCenter;
self.day1OfTheWeekLabel.textColor = COLOR_THEME;
//_day1OfTheWeekLabel.text=@"日";
 [self.weekView addSubview:self.day1OfTheWeekLabel];

xOffset += CATDayLabelWidth + 5.0f;
dayOfTheWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, CATDayLabelWidth, CATDayLabelHeight)];
[dayOfTheWeekLabel setBackgroundColor:[UIColor clearColor]];
[dayOfTheWeekLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
self.day2OfTheWeekLabel = dayOfTheWeekLabel;
self.day2OfTheWeekLabel.textAlignment=NSTextAlignmentCenter;
self.day2OfTheWeekLabel.textColor = COLOR_THEME;
[self.weekView addSubview:self.day2OfTheWeekLabel];

xOffset += CATDayLabelWidth + 5.0f;
dayOfTheWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, CATDayLabelWidth, CATDayLabelHeight)];
[dayOfTheWeekLabel setBackgroundColor:[UIColor clearColor]];
[dayOfTheWeekLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
self.day3OfTheWeekLabel = dayOfTheWeekLabel;
self.day3OfTheWeekLabel.textAlignment=NSTextAlignmentCenter;
self.day3OfTheWeekLabel.textColor = COLOR_THEME;
[self.weekView addSubview:self.day3OfTheWeekLabel];

xOffset += CATDayLabelWidth + 5.0f;
dayOfTheWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, CATDayLabelWidth, CATDayLabelHeight)];
[dayOfTheWeekLabel setBackgroundColor:[UIColor clearColor]];
[dayOfTheWeekLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
self.day4OfTheWeekLabel = dayOfTheWeekLabel;
self.day4OfTheWeekLabel.textAlignment=NSTextAlignmentCenter;
self.day4OfTheWeekLabel.textColor = COLOR_THEME;
 [self.weekView addSubview:self.day4OfTheWeekLabel];

xOffset += CATDayLabelWidth + 5.0f;
dayOfTheWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, CATDayLabelWidth, CATDayLabelHeight)];
[dayOfTheWeekLabel setBackgroundColor:[UIColor clearColor]];
[dayOfTheWeekLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
self.day5OfTheWeekLabel = dayOfTheWeekLabel;
self.day5OfTheWeekLabel.textAlignment=NSTextAlignmentCenter;
self.day5OfTheWeekLabel.textColor = COLOR_THEME;
[self.weekView addSubview:self.day5OfTheWeekLabel];

xOffset += CATDayLabelWidth + 5.0f;
dayOfTheWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, CATDayLabelWidth, CATDayLabelHeight)];
[dayOfTheWeekLabel setBackgroundColor:[UIColor clearColor]];
[dayOfTheWeekLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
self.day6OfTheWeekLabel = dayOfTheWeekLabel;
self.day6OfTheWeekLabel.textAlignment=NSTextAlignmentCenter;
self.day6OfTheWeekLabel.textColor = COLOR_THEME;
[self.weekView addSubview:self.day6OfTheWeekLabel];

xOffset += CATDayLabelWidth + 5.0f;
dayOfTheWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, CATDayLabelWidth, CATDayLabelHeight)];
[dayOfTheWeekLabel setBackgroundColor:[UIColor clearColor]];
[dayOfTheWeekLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
self.day7OfTheWeekLabel = dayOfTheWeekLabel;
self.day7OfTheWeekLabel.textAlignment=NSTextAlignmentCenter;
self.day7OfTheWeekLabel.textColor = COLOR_THEME;
[self.weekView addSubview:self.day7OfTheWeekLabel];

[self updateWithDayNames:@[@"日",@"一",@"二", @"三", @"四", @"五", @"六"]];
}


//设置 @"日", @"一", @"二", @"三", @"四", @"五", @"六"
- (void)updateWithDayNames:(NSArray *)dayNames
{
    for (int i = 0 ; i < dayNames.count; i++) {
        switch (i) {
            case 0:
                self.day1OfTheWeekLabel.text = dayNames[i];
                break;
                
            case 1:
                self.day2OfTheWeekLabel.text = dayNames[i];
                break;
                
            case 2:
                self.day3OfTheWeekLabel.text = dayNames[i];
                break;
                
            case 3:
                self.day4OfTheWeekLabel.text = dayNames[i];
                break;
                
            case 4:
                self.day5OfTheWeekLabel.text = dayNames[i];
                break;
                
            case 5:
                self.day6OfTheWeekLabel.text = dayNames[i];
                break;
                
            case 6:
                self.day7OfTheWeekLabel.text = dayNames[i];
                break;
                
            default:
                break;
        }
    }
}
@end
