//
//  CalendarViewController.m
//  Calendar
//
//  Created by 张凡 on 14-8-21.
//  Copyright (c) 2014年 张凡. All rights reserved.
//

#import "CalendarViewController.h"
//UI
#import "CalendarMonthCollectionViewLayout.h"
#import "CalendarMonthHeaderView.h"
#import "CalendarDayCell.h"
//MODEL
#import "CalendarDayModel.h"
#import "HistoryDataVC.h"
#import "ResultDataDAO.h"

@interface CalendarViewController ()
<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate>
{


}

@property(nonatomic,retain) UITableView *  dayDataTableView;
@property(nonatomic,retain) UIView *tableHeaderView;
@property(nonatomic,retain) UILabel *headerLabel;
@property(nonatomic,retain) NSMutableArray *resultDataList;
//被选中的那一天的年月日
@property(nonatomic,strong) NSDateComponents *selectedDayDate;

@end

@implementation CalendarViewController

static NSString *MonthHeader = @"MonthHeaderView";

static NSString *DayCell = @"DayCell";


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
   /* if(!self)*/ {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initData];
        [self initView];
    }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initTableHeaderView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}



- (void)initView{
    
    
    [self setTitle:@"选择日期"];
    CalendarMonthCollectionViewLayout *layout = [CalendarMonthCollectionViewLayout new];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout]; //初始化网格视图大小
    [self.collectionView registerClass:[CalendarDayCell class] forCellWithReuseIdentifier:DayCell];//cell重用设置ID
    
    [self.collectionView registerClass:[CalendarMonthHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader];
    [self.collectionView registerClass:[CalendarMonthHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"kfooterIdentifier"];
    
//    self.collectionView.bounces = NO;//将网格视图的下拉效果关闭
    
    self.collectionView.delegate = self;//实现网格视图的delegate
    
    self.collectionView.dataSource = self;//实现网格视图的dataSource
    
    [self.collectionView setFrame:CGRectMake(0, 94, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor=[UIColor clearColor];

}

-(void)initData{
    
    self.calendarMonth = [[NSMutableArray alloc]init];//每个月份的数组
    self.resultDataList=[[NSMutableArray alloc]initWithCapacity:0];
}
//设置表头
-(void)initTableHeaderView
{
    _tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 44)];
    [_dayDataTableView addSubview:_tableHeaderView];
    _headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 30)];
    _headerLabel.textAlignment=NSTextAlignmentCenter;
    [_tableHeaderView addSubview:_headerLabel];
    //[_dayDataTableView setTableHeaderView:_tableHeaderView];
}

#pragma mark - CollectionView代理方法

//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView

{
    //1.
    NSLog(@"calendarMonth.count=%lu",(unsigned long)_calendarMonth.count);
    return self.calendarMonth.count;
}

//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //2,3,4,5,6,7,8...13. 每个section都要执行一遍这个回调
    NSMutableArray *monthArray = [self.calendarMonth objectAtIndex:section];
   // NSLog(@"有%d各月",[monthArray count]);
    return monthArray.count;
}


//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //14.
    CalendarDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DayCell forIndexPath:indexPath];
    
    NSMutableArray *monthArray = [self.calendarMonth objectAtIndex:indexPath.section];
   // NSLog(@"monthArray%d=%@",indexPath.section,monthArray);
    CalendarDayModel *model = [monthArray objectAtIndex:indexPath.row];
    
    cell.model = model;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier;
    if ([kind isEqualToString: UICollectionElementKindSectionFooter ]){
        reuseIdentifier = @"kfooterIdentifier";
    }else{
        reuseIdentifier = @"kheaderIdentifier";
    }
//    UICollectionReusableView *view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    UICollectionReusableView *reusableview = nil;

    if (kind == UICollectionElementKindSectionHeader){
        
        NSMutableArray *month_Array = [self.calendarMonth objectAtIndex:indexPath.section];
        CalendarDayModel *model = [month_Array objectAtIndex:15];

        CalendarMonthHeaderView *monthHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader forIndexPath:indexPath];
        monthHeader.masterLabel.text = [NSString stringWithFormat:@"%lu年 %lu月",(unsigned long)model.year,(unsigned long)model.month];//@"日期";
//        monthHeader.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.8f];
        monthHeader.backgroundColor=[UIColor clearColor];
        reusableview = monthHeader;
    }
//    else([kind isEqual:UICollectionElementKindSectionFooter])
        //(kind == UICollectionElementKindSectionFooter)
    else
    {
        CalendarMonthHeaderView *monthHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"kfooterIdentifier" forIndexPath:indexPath];
        monthHeader.backgroundColor=[UIColor clearColor];
        reusableview = monthHeader;
    }
    return reusableview;
    
}


//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableArray *month_Array = [self.calendarMonth objectAtIndex:indexPath.section];
    NSLog(@"选中了section=%d,row=%d",indexPath.section,indexPath.row);
    CalendarDayModel *model = [month_Array objectAtIndex:indexPath.row];
    
    if (model.style == CellDayExistData) {
        dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSLog(@"[model.resultDataList count]=%d",[model.resultDataList count]);
            _resultDataList=model.resultDataList;
            NSDate *date=model.date;
            _selectedDayDate = [date YMDComponents];//今天日期的年月日
            int year=[_selectedDayDate year];
            int month=[_selectedDayDate month];
            int day=[_selectedDayDate day];
            dispatch_async(dispatch_get_main_queue(), ^{
                _headerLabel.text=[NSString stringWithFormat:@"%d年%d月%d日",year,month,day];
                [_dayDataTableView reloadData];
               // NSLog(@"_dayModelCellData.group=%d",_dayModelCellData.group);
            });
        });
        
        //[self.Logic selectLogic:model];
        
        if (self.calendarblock) {
            
            self.calendarblock(model);//传递数组给上级
            //[self.collectionView reloadData];
            [self clickCalendarDayCell];
            
        }
       
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
}
//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={320,35};
    return size;
}
//返回头footerView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize size={320,35};
    return size;
}
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(320/7,35);
}
//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 25;
}
//每个item之间的间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 100;
//}
//选择了某个cell
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    [cell setBackgroundColor:[UIColor greenColor]];
//}

//取消选择了某个cell
//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    [cell setBackgroundColor:[UIColor redColor]];
//}

- (void)clickCalendarDayCell{
    
   // [timer invalidate];//定时器无效
    
//    RecordsViewController *vc=[[RecordsViewController alloc]initWithNibName:@"RecordsViewController" bundle:nil];
    //[self.navigationController pushViewController:vc animated:YES];
    //[self.navigationController popViewControllerAnimated:YES];
    _recordView=[[[NSBundle mainBundle] loadNibNamed:@"DetailsRecordsView" owner:self options:nil] lastObject];
    
     _dayDataTableView=(UITableView*)[_recordView viewWithTag:1];
    _dayDataTableView.delegate=self;
    _dayDataTableView.dataSource=self;
    _dayDataTableView.backgroundColor=[UIColor clearColor];
    _dayDataTableView.separatorStyle=UITableViewCellAccessoryNone;
    //设置表头
     //[_dayDataTableView setTableHeaderView:_tableHeaderView];
    UIView *headerView=(UIView*)[_recordView viewWithTag:2];
    [headerView addSubview:_tableHeaderView];
    headerView.backgroundColor=[UIColor clearColor];
    //_recordTableView=tableView;
     _dayDataTableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_recordView];
    //[self presentViewController:vc animated:NO completion:^{}];
    UIButton *cancelButton=[[UIButton alloc]initWithFrame:CGRectMake(300-25,64+10,25,25)];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"日历-弹出-删除"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [_recordView addSubview:cancelButton];
}
#pragma -mark UITableView方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_resultDataList count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ID=[NSString stringWithFormat:@"%ld%ld",(long)[indexPath section],(long)[indexPath row]];
//    static NSString *reuseIdetify = @"SvTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.showsReorderControl = NO;
        NSInteger row=[indexPath row];
        UILabel *OnCellLabel=[[UILabel alloc]initWithFrame:CGRectMake(90, 7, 120, 30)];
        OnCellLabel.textAlignment=NSTextAlignmentCenter;
        [cell.contentView addSubview:OnCellLabel];
       
        ResultData *data=[_resultDataList objectAtIndex:row];
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"HH:mm:ss"];
        OnCellLabel.text
        =[formatter stringFromDate:data.startDate];
        //NSLog(@"OnCellLabel.text=%@",OnCellLabel.text);
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"日历弹出框-横条"]];
        cell.selectedBackgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"日历弹出框-横条点击效果"]];
    }
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
//{
//    return @"哈哈哈哈哈哈哈哈哈哈哈";
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row= [indexPath row];
    
    ResultData *data=[_resultDataList objectAtIndex:row];
    
    HistoryDataVC *vc=[[HistoryDataVC alloc]initWithNibName:@"HistoryDataVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    vc.bottomTimeLableData=
    [NSString stringWithFormat:@"%d.%d.%d",_selectedDayDate.year,_selectedDayDate.month,_selectedDayDate.day];
    
    vc.data=data;
    vc.block=^{
        [_resultDataList removeObjectAtIndex:row];
        [_dayDataTableView reloadData];
        //[_collectionView reloadData];
    };
}

-(void)clickCancelButton {
    [_recordView removeFromSuperview];
}

@end
