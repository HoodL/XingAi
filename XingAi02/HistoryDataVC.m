//
//  HistoryDataVC.m
//  XingAi02
//
//  Created by Lihui on 14/11/13.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//

#import "HistoryDataVC.h"
#import "ResultDataDAO.h"
#import "CalendarViewController.h"
@interface HistoryDataVC ()

@end

@implementation HistoryDataVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.data=[[ResultData alloc]init];
        self.bottomTimeLableData=[NSString string];
        _flag=0;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_bgImageView removeFromSuperview];
    
    [self.view insertSubview:_bgImageView atIndex:0];
    self.bottomTimeLable.textColor=[UIColor colorWithRed:224.0/255 green:184.0/255 blue:25.0/255 alpha:1.0];
    self.bottomTimeLable.textAlignment=NSTextAlignmentCenter;
    self.bottomTimeLable.text=self.bottomTimeLableData;
    // Do any additional setup after loading the view from its nib.
    _dataCount.text=[NSString stringWithFormat:@"%ld",(long)[_data.totalCount integerValue]];
    _dataCount.textAlignment=NSTextAlignmentCenter;
    _dataCount.textColor=[UIColor colorWithRed:224.0/255 green:184.0/255 blue:25.0/255 alpha:1.0];
    
    _dataTime.text=[self transformTimeFormat:[_data.totalTime integerValue]];
    _dataTime.textAlignment=NSTextAlignmentCenter;
    _dataTime.textColor=[UIColor colorWithRed:224.0/255 green:184.0/255 blue:25.0/255 alpha:1.0];
    
    _dataIn.text=[NSString stringWithFormat:@"%0.1f",[_data.averageIn floatValue]];
    _dataIn.textAlignment=NSTextAlignmentCenter;
    _dataIn.textColor=[UIColor colorWithRed:224.0/255 green:184.0/255 blue:25.0/255 alpha:1.0];
    
    _dataHeat.text=[NSString stringWithFormat:@"%0.1f",[_data.totalHeat floatValue]];
   _dataHeat.textAlignment=NSTextAlignmentCenter;
    _dataHeat.textColor=[UIColor colorWithRed:224.0/255 green:184.0/255 blue:25.0/255 alpha:1.0];
    
    _dataHz.text=[NSString stringWithFormat:@"%0.1f",[_data.averageHz floatValue]];
   _dataHz.textAlignment=NSTextAlignmentCenter;
    _dataHz.textColor=[UIColor colorWithRed:224.0/255 green:184.0/255 blue:25.0/255 alpha:1.0];
    
}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickCancelViewButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickRrtun:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)clickDeleteButton:(id)sender {
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"你真的要删除本次数据吗?" message:@"删除后将不可恢复哦" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        ResultDataDAO *DAO=[ResultDataDAO shareManager];
        [DAO remove:self.data];
        [self.navigationController popViewControllerAnimated:YES];
       // _flag=1;
        self.block();
    }
    
}
@end
