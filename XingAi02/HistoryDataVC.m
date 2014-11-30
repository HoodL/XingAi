//
//  HistoryDataVC.m
//  XingAi02
//
//  Created by Lihui on 14/11/13.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//

#import "HistoryDataVC.h"

@interface HistoryDataVC ()

@end

@implementation HistoryDataVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.data=[[SportsData alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_bgImageView removeFromSuperview];
    [self.view insertSubview:_bgImageView atIndex:0];
    NSLog(@"data.count=%d",[_data.count integerValue]);
    // Do any additional setup after loading the view from its nib.
    _dataCount.text=[NSString stringWithFormat:@"%d",[_data.count integerValue]];
    _dataCount.textAlignment=NSTextAlignmentCenter;
    _dataCount.textColor=[UIColor colorWithRed:224.0/255 green:184.0/255 blue:25.0/255 alpha:1.0];
    
   
    
     _dataTime.text=[NSString stringWithFormat:@"%d",[_data.time integerValue]];
    _dataTime.textAlignment=NSTextAlignmentCenter;
    _dataTime.textColor=[UIColor colorWithRed:224.0/255 green:184.0/255 blue:25.0/255 alpha:1.0];
    
    _dataIn.text=[NSString stringWithFormat:@"%0.2f",[_data.intensity floatValue]];
    _dataIn.textAlignment=NSTextAlignmentCenter;
    _dataIn.textColor=[UIColor colorWithRed:224.0/255 green:184.0/255 blue:25.0/255 alpha:1.0];
    
    _dataHeat.text=[NSString stringWithFormat:@"%0.2f",[_data.heat floatValue]];
   _dataHeat.textAlignment=NSTextAlignmentCenter;
    _dataHeat.textColor=[UIColor colorWithRed:224.0/255 green:184.0/255 blue:25.0/255 alpha:1.0];
    
    _dataHz.text=[NSString stringWithFormat:@"%0.2f",[_data.hz floatValue]];
   _dataHz.textAlignment=NSTextAlignmentCenter;
    _dataHz.textColor=[UIColor colorWithRed:224.0/255 green:184.0/255 blue:25.0/255 alpha:1.0];
    
    
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
@end
