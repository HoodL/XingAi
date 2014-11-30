//
//  LeftViewController.m
//  XingAi
//
//  Created by Lihui on 14/11/5.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//

#import "LeftViewController.h"
#import "SliderViewController.h"
#import "LoginViewController.h"
#import "calendarViewController.h"
#import "CalendarHomeViewController.h"
#import "DeviceVC.h"
#import "SetVC.h"
#import "InstructionsVC.h"
#import "CalendarViewController.h"

@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_data;
    NSDictionary *_dicData;
    UITableView *_tableView;
    NSArray *_imageNameList;
}

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _imageNameList=[[NSArray alloc]initWithObjects:@"战力icon",@"设备icon",@"记录icon",@"设置icon",@"说明icon",nil];
    _data=[[NSArray alloc]initWithObjects:@"主页", @"设备",@"记录",@"设置",@"说明",nil];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:self.view.frame];
    [imageView setImage:[UIImage imageNamed:@"侧边栏背景图-568h"]];
    [self.view addSubview:imageView];
    
    _contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    _contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_contentView];
    NSLog(@"_contentView.layer.anchorPoint.x=%f", _contentView.layer.anchorPoint.x);
    //人物头像
    UIImageView *headerIV = [[UIImageView alloc] initWithFrame:CGRectMake(70, 40, 75, 75)];
    headerIV.layer.masksToBounds=YES;
    headerIV.layer.cornerRadius = headerIV.width/2;
    headerIV.tag = 20;
    UIImage *headerI = [UIImage imageNamed:@"侧滑栏上默认头像"];
    [headerIV setImage:headerI];
    [_contentView addSubview:headerIV];
//    UIImageView *headerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(3, 3, 74, 74)];
//    headerImageView.image=[UIImage imageNamed:@"9.jpg"];
//    headerImageView.layer.masksToBounds=YES;
//    headerImageView.layer.cornerRadius=37;
//    [headerIV addSubview:headerImageView];
    //设置点击区域,点击后立即登陆
    UIButton *loginButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 40, 234, 80+50)];
    loginButton.backgroundColor=[UIColor clearColor];
    [loginButton addTarget:self action:@selector(clickLoginButton) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:loginButton];
    //加入“点击后立即登陆标签”
    UILabel *loginLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 130, 120, 30)];
    loginLabel.textAlignment=NSTextAlignmentCenter;
    loginLabel.text=@"点击立即登录";
    loginLabel.textColor=[UIColor whiteColor];
    [_contentView addSubview:loginLabel];
    
//    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headerIV.bottom + 50, self.view.width, self.view.height - headerIV.bottom - 80) style:UITableViewStylePlain];
    
     _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headerIV.bottom + 50, self.view.width, 222) style:UITableViewStylePlain];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setBackgroundColor:[UIColor clearColor]];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_contentView addSubview:_tableView];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    //底下加入推荐星爱按钮
//    UIButton *recommend=[[UIButton alloc]initWithFrame:CGRectMake(22, _tableView.bounds.origin.y+self.view.height - headerIV.bottom - 80+44,175,45)];
    
    UIButton *recommend=[[UIButton alloc]initWithFrame:CGRectMake(22, _tableView.frame.origin.y+_tableView.frame.size.height+30,175,45)];
    
    [recommend setBackgroundImage:[UIImage imageNamed:@"推荐星爱按钮"] forState:UIControlStateNormal];
    [recommend setBackgroundImage:[UIImage imageNamed:@"推荐星爱按钮-点击"] forState:UIControlStateHighlighted];
    
    [recommend setTitle:@"推荐星爱" forState:UIControlStateNormal];
    [recommend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    recommend.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [_contentView addSubview:recommend];
    UIImageView *redStar=[[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 30, 30)];
    
    redStar.image=[UIImage imageNamed:@"推荐星爱icon"];
    [recommend addSubview:redStar];
    
}
- (void)backAction:(UIButton *)btn
{
    [[SliderViewController sharedSliderController] closeSideBar];
}
//点击头像区域可以登录
-(void)clickLoginButton {
    [self backAction:nil];
//    LoginViewController *vc=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    LoginViewController *vc=[[LoginViewController alloc]initWithCoder:nil];

    [self.navigationController pushViewController:vc animated:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdetify = @"left";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];;
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        UIImageView *cellView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 44)];
        NSInteger selectRow=[indexPath row];
        //要使用到的背景图
        UIImage *cellImage=[UIImage imageNamed:@"横条"];
        [cellView setImage:cellImage];
        cell.backgroundView=cellView;
        if (selectRow==4) {
            UIImageView *view=[[UIImageView alloc]initWithFrame:CGRectMake(0, 44, 235, 2)];
            [view setImage:[UIImage imageNamed:@"底部横线"]];
            [cell addSubview:view];
        }
        //图标
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(50, 7, 30, 30)];
        [imageView setImage:[UIImage imageNamed:[_imageNameList objectAtIndex:selectRow]]];
        [cell addSubview:imageView];
        //文字
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(120, 7, 100, 30)];
        label.text=[_data objectAtIndex:selectRow];
        label.textColor=[UIColor whiteColor];
        label.textAlignment=NSTextAlignmentLeft;
        [cell addSubview:label];
        cell.selectedBackgroundView=[[UIImageView alloc] initWithImage:
                                     [UIImage imageNamed:@"菜单-好友-点击"]];
        cell.selectedBackgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"横条-点击"]];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row)
    {
        case 0:
        {
            [self backAction:nil];
            break;
        }
        case 1:
        {
            [self backAction:nil];
            DeviceVC *vc=[[DeviceVC alloc]initWithNibName:@"DeviceVC" bundle:nil];
            vc.tagComingFromWhichVC=2;
            [self.navigationController pushViewController:vc animated:YES];
//            [self presentViewController:vc animated:NO completion:^{}];
            break;
        }
        case 2:
        {
            // [self backAction:nil];
             CalendarHomeViewController *chvc;
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
//            CalendarViewController *vc=[[CalendarViewController alloc]init];
            [[SliderViewController sharedSliderController].navigationController
             pushViewController:chvc animated:YES];
            //[self.navigationController pushViewController:chvc animated:YES];
            break;
        }
        case 3:
        {
            SetVC *vc=[[SetVC alloc]initWithNibName:@"SetVC" bundle:nil];
            vc.modalTransitionStyle=UIModalTransitionStylePartialCurl;
            [self .navigationController pushViewController:vc animated:YES];
            break;
        }
        case 4:
        {
            InstructionsVC *vc=[[InstructionsVC alloc]initWithNibName:@"InstructionsVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}


@end
