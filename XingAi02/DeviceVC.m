//
//  DeviceVC.m
//  XingAi02
//
//  Created by Lihui on 14/11/13.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//

#import "DeviceVC.h"
#import "WaveViewController.h"
#import "BDKNotifyHUD.h"
@interface DeviceVC ()<UITableViewDelegate,UITableViewDataSource,BLEDeviceControlDelegate>
{
    BOOL isLink;
    int butteryPercentNum;
}
@property(nonatomic,retain)UIImageView *HUDImageView;
@property(nonatomic,retain)UILabel *waitingLabel;//等待字样。
@property(nonatomic,retain)BDKNotifyHUD *notify;

@end

@implementation DeviceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    // Do any additional setup after loading the view from its nib.
    _deviceTabView.delegate=self;
    _deviceTabView.dataSource=self;
    _deviceTabView.separatorStyle
    =UITableViewCellSeparatorStyleNone;
    if (!iPhone5) {
        _deviceTabView.frame=CGRectMake(15, 99, 290, 300);
        _bgImageView.frame=CGRectMake(15, 99, 290, 300);
        _scanButton.frame=CGRectMake(94, 422, 132, 30);
    }
    _bleControl=[BLEControl sharedBLEControl];
    //_bleControl=[[BLEControl alloc]init];
    [_bleControl scanClick];
    //[_bleControl scanClick];
//    [_bleControl scanClick];
    _deviceList=[[NSMutableArray alloc]initWithCapacity:0];
    [_deviceList removeAllObjects];
    if (_bleControl.activePeripheral!=nil) {
        
        [_deviceList addObject:_bleControl.activePeripheral];
       // [_deviceList addObject:device];
    }
    _bleControl.delegate2=self;
    isLink=NO;
    //旋转图:
    _HUDImageView=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-270)/2, (SCREEN_HEIGHT-270)/2, 270, 270)];
    _HUDImageView.image=[UIImage imageNamed:@"蓝牙-连接中"];
    [self.view addSubview:_HUDImageView];
    _HUDImageView.userInteractionEnabled=NO;
    _HUDImageView.hidden=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_deviceList count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *reuseIdetify = @"SvTableViewCell";
    NSString *reuseIdetify=[NSString stringWithFormat:@"%dcell",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
    if (/*!cell*/1) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdetify];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.showsReorderControl = NO;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        //cell.userInteractionEnabled=NO;
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(40, 0, self.view.bounds.size.width-80, 40)];
        //NSInteger row=[indexPath row];
        cell.accessoryType=UITableViewCellAccessoryNone;
            CBPeripheral *p = [_deviceList objectAtIndex:indexPath.row];
       // BLEDevice *device=[_deviceList objectAtIndex:indexPath.row];
        UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 44, 290, 1)];
        line.image=[UIImage imageNamed:@"个人信息-分割线"];
        [cell addSubview:line];
        
        UIImageView *logo=[[UIImageView alloc]initWithFrame:CGRectMake(15, 9.5, 25, 25)];
        logo.image=[UIImage imageNamed:@"蓝牙-连接黄logo"];
        [cell addSubview:logo];
        
        UILabel *deviceName=[[UILabel alloc]initWithFrame:CGRectMake(50, 9.5, 150, 25)];
        deviceName.font=[UIFont systemFontOfSize:12];
        deviceName.text=p.name;
       // deviceName.text= device.peripheral.name;
        deviceName.textColor=[UIColor whiteColor];
        deviceName.textAlignment=NSTextAlignmentLeft;
        [cell addSubview:deviceName];
        
            label.textColor=[UIColor whiteColor];
            [cell.contentView addSubview:label];
            UIButton *linkButton=[[UIButton alloc]initWithFrame:CGRectMake(230, 10, 56, 25)];
            if (p.state==CBPeripheralStateConnected) {
                NSLog(@"这个设备已经连接了");
                [linkButton setBackgroundImage:[UIImage imageNamed:@"蓝牙-连接断开"] forState:UIControlStateNormal];
                linkButton.tag=(indexPath.row);
                isLink=YES;
                //加电池标签:
                _butteryPercent=[[UILabel alloc]initWithFrame:CGRectMake(170, 10, 100, 25)];
                _butteryPercent.font=[UIFont systemFontOfSize:12];
                _butteryPercent.textAlignment=NSTextAlignmentLeft;
                //_butteryPercent.text=@"";
                _butteryPercent.textColor=[UIColor whiteColor];
               //_butteryPercent.text= [NSString stringWithFormat:@"电量%d%%",butteryPercentNum];
                _butteryPercent.text= [NSString stringWithFormat:@"电量%d%%",self.bleControl.butteryPercent];
                
                [cell.contentView addSubview:_butteryPercent];
            }
        
            else {
                
           [linkButton setBackgroundImage:[UIImage imageNamed:@"蓝牙-连接"] forState:UIControlStateNormal];
                linkButton.tag=(indexPath.row);
            }
            [linkButton addTarget:self action:@selector(clickLinkButton:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:linkButton];

        cell.backgroundColor=[UIColor clearColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // BLEDevice *device=[_deviceList objectAtIndex:indexPath.row];
    CBPeripheral *peripheral=[_deviceList objectAtIndex:indexPath.row];
    [self.bleControl connectPeripheral:peripheral];
    _HUDImageView=[self rotateImageView:_HUDImageView];
    _HUDImageView.hidden=NO;
    _waitingLabel=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, _HUDImageView.frame.origin.y+270+10, 100, 30)];
    _waitingLabel.text=@"连接中";
    _waitingLabel.textColor=[UIColor whiteColor];
    _waitingLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:_waitingLabel];

}

- (IBAction)clickReturnButton:(id)sender {
   
    [self.navigationController popViewControllerAnimated:YES];
    _bleControl.delegate2=nil;
}

#pragma -mark --代理方法
-(void)synButteryPercent:(int)percent {
    butteryPercentNum=percent;
    //_butteryPercent.text= [NSString stringWithFormat:@"电量%d%%",percent];
    [self.deviceTabView reloadData];
}

-(void)addPeripherals:(CBPeripheral *)peripheral {
    if(![self.deviceList containsObject:peripheral])
     {
         [_deviceList addObject:peripheral];
         [_deviceTabView reloadData];
     NSLog(@"cell上的name=%@,state=%d",peripheral.name,peripheral.state);
     }
}

- (IBAction)clickScanButton:(id)sender {
    [_bleControl scanClick];
}

- (IBAction)shishiButton:(id)sender {
    [_bleControl getRealTimeData];
//    uint8_t b[]={0xAA,0x02,0x01,0x00,0x03,0x55};
//    NSMutableData *data=[[NSMutableData alloc]initWithBytes:b length:6];
////    [self writeValue:0x1814 characteristicUUID:0x2A53 p:self.activePeripheral data:data];
//    [_bleControl.activePeripheral writeValue:data forCharacteristic:_bleControl.writeCharacteristic type:CBCharacteristicWriteWithResponse];
}

-(void)clickLinkButton:(id)sender
{
    UIButton *btn=(UIButton*)sender;
//    
//    if ((btn.tag)%97==0) {
//        [self.bleControl disconnect:[_deviceList objectAtIndex:(btn.tag)/97-1]];
//        [sender setBackgroundImage:[UIImage imageNamed:@"蓝牙-连接"] forState:UIControlStateNormal];
//        //[_deviceTable reloadData];
//    }else {
//        [self.bleControl connectPeripheral:[_deviceList objectAtIndex:(btn.tag)/89-1]];
//        [sender setBackgroundImage:[UIImage imageNamed:@"蓝牙-断开"] forState:UIControlStateNormal];
//
//    }
    
   CBPeripheral *peripheral=[_deviceList objectAtIndex:btn.tag];
    if(isLink==YES) {
       // [self.bleControl disconnect:[_deviceList objectAtIndex:btn.tag]];
        [self.bleControl disconnect:peripheral];
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"断开连接成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        isLink=NO;
        [self.deviceTabView reloadData];
        //_bleControl.activePeripheralState=13;
    }
    else {
        [self.bleControl connectPeripheral:peripheral];
//        [self.bleControl connectPeripheral:[_deviceList objectAtIndex:(btn.tag)]];
        _HUDImageView=[self rotateImageView:_HUDImageView];
        _HUDImageView.hidden=NO;
        _waitingLabel=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, _HUDImageView.frame.origin.y+270+10, 100, 30)];
        _waitingLabel.text=@"连接中";
        _waitingLabel.textColor=[UIColor whiteColor];
        _waitingLabel.textAlignment=NSTextAlignmentCenter;
        [self.view addSubview:_waitingLabel];
    }
}
-(void)removeLinkingHUDImageView {
    [self.deviceTabView reloadData];
    [self displayNotification];
    _HUDImageView.hidden=YES;
    [_waitingLabel removeFromSuperview];
    if (self.tagComingFromWhichVC==0) {
        //从START点进来的
        WaveViewController *vc=[[WaveViewController alloc]initWithNibName:@"WaveViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(self.tagComingFromWhichVC==1) {
       //从同步点进来的
        [_bleControl synHistoryData];
    }
    else if (self.tagComingFromWhichVC==2) {
        //从左侧菜单点进来的
    }
}

//-(void)reloadUI {
//    [self.deviceTabView reloadData];
//}
//图片旋转

-(UIImageView*)rotateImageView:(UIImageView*)imageView
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    animation.fromValue=[NSValue valueWithCATransform3D:CATransform3DIdentity];
//    animation.toValue=[NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0)];
    animation.duration=0.5;
    animation.cumulative=YES;
    animation.toValue=@(2*M_PI);
    animation.repeatCount=HUGE_VALF;
//  CGRect imageRect =CGRectMake(0, 0, imageView.frame.size.width,imageView.frame.size.height);
//    CGRect imageRect1=_HUDImageView.frame;
//    UIGraphicsBeginImageContext(imageRect1.size);
//    [imageView.image drawInRect:CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height)];
//    imageView.image=UIGraphicsGetImageFromCurrentImageContext();
    [imageView.layer setAnchorPoint:CGPointMake(0.5,0.5)];
   [imageView.layer addAnimation:animation forKey:@"rotationAnimation"];
//    [imageView.layer setPosition:CGPointMake(0, 0)];
//    imageView.center=CGPointMake(160, 399);
    return imageView;
}

//提醒HUD
- (BDKNotifyHUD *)notify {
    if (_notify != nil) return _notify;
    _notify = [BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:@"Checkmark"] text:@"恭喜您,连接成功"];
    _notify.center = CGPointMake(self.view.center.x, self.view.center.y - 20);
    return _notify;
}

- (void)displayNotification {
    if (self.notify.isAnimating) return;
    
    [self.view addSubview:self.notify];
    [self.notify presentWithDuration:2.0f speed:0.5f inView:self.view completion:^{
        [self.notify removeFromSuperview];
    }];
}

@end
