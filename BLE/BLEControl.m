//
//  BLEControl.m
//  XingAi02
//
//  Created by Lihui on 14/11/14.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//

#import "BLEControl.h"
#import "AppDelegate.h"
#import "SliderViewController.h"
#import "ResultDataDAO.h"

@interface BLEControl()
{
}
@property(retain,nonatomic)ResultData *syncResultData;
@property(retain,nonatomic)NSDate *theSecondthStartDate;
@end
@implementation BLEControl

+(BLEControl*)sharedBLEControl
{
    static BLEControl *sharedBLE;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedBLE = [[self alloc] init];
    });//检测每次调用时，block是否执行完毕,是一种多线程技术 这个是只执行一次的。
    //保证只调用API一次
    return sharedBLE;
}

-(id)init {
    if (self=[super init]) {
        
        _CM = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        _peripherals = [[NSMutableArray alloc]init];
        _services = [[NSMutableArray alloc]init];
        _characteristics = [[NSMutableArray alloc]init];
        //_activePeripheralState=_activePeripheral.state;
        _dataCounter=0;
        _syncResultData=[[ResultData alloc]init];
        _sportsSeconds=0;
        _butteryPercent=100;
//        [self.activePeripheral addObserver:[SliderViewController sharedSliderController].MainVC  forKeyPath:@"state" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"statechanged"];
        
    }
    return self;
}
//扫描
-(void)scanClick
{
    NSArray *uuidArray = [NSArray arrayWithObjects:[CBUUID UUIDWithString:@"0x1899"],nil];
    [_CM scanForPeripheralsWithServices:uuidArray options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @NO }];
//    double delayInSeconds = 10.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [self.CM stopScan];
//        [self.delegate reloadUI];
        //[self.peripherals removeAllObjects];
    //});
    //[self.peripherals removeAllObjects];
}

-(void) connectPeripheral:(CBPeripheral *)peripheral;
{
    [self.CM connectPeripheral:peripheral options:nil];

}

-(void) disconnect:(CBPeripheral*)peripheral;//断开连接
{
    [self.CM cancelPeripheralConnection:peripheral];
    NSLog(@"断开连接成功");
    _dataCounter=0;
}

//开始查看服务，蓝牙开启
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
        {
            NSLog(@"蓝牙已经开启，请扫描外设!");
            if (self.delegate&&self.activePeripheral) {
                [self.CM connectPeripheral:self.activePeripheral options:nil];

            }
        }
            break;
        case CBCentralManagerStatePoweredOff:
        {
            NSLog(@"手机蓝牙关闭了,建议你打开!");
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"手机蓝牙关闭了,建议你打开!" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            [alertView show];
        }
            break;
        default:
            break;
    }
}

//查到外设后，停止扫描，连接设备
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    if(![self.peripherals containsObject:peripheral])
    {
        [self.peripherals addObject:peripheral];
       // [self.delegate addPeripherals:peripheral];
        NSLog(@"%@",[NSString stringWithFormat:@"已发现 peripheral: %@ rssi: %@, UUID: %@ advertisementData: %@ ", peripheral, RSSI,
                     peripheral.identifier.UUIDString,advertisementData]);
        NSLog(@"%@",peripheral);
        NSLog(@"name=%@",peripheral.name);
    }
//    BLEDevice *device=[[BLEDevice alloc]init];
//    device.peripheral=peripheral;
//    device.isConnected=[peripheral isConnected];
//    device.butteryPercent=101;
    [self.delegate2 addPeripherals:peripheral];
        /*BOOL replace = NO;
    //    // Match if we have this device from before
        for (int i=0; i < _peripherals.count; i++) {
            CBPeripheral *p = [_peripherals objectAtIndex:i];
            if ([p isEqual:peripheral]) {
                [_peripherals replaceObjectAtIndex:i withObject:peripheral];
                replace = YES;
           }
        }
        if (!replace) {
            NSLog(@"%@",[NSString stringWithFormat:@"已发现 peripheral: %@ rssi: %@, UUID: %@ advertisementData: %@ ", peripheral, RSSI,
                         peripheral.identifier.UUIDString,advertisementData]);
            NSLog(@"name=%@,state=%d",peripheral.name,peripheral.state);
            [_peripherals addObject:peripheral];
            [self.delegate addPeripherals:peripheral];
            [self.delegate reloadUI];
        }*/
}

//连接外设成功，开始发现服务
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    NSLog(@"%@",[NSString stringWithFormat:@"成功连接 peripheral: %@ with UUID: %@",peripheral,peripheral.identifier.UUIDString]);
    self.activePeripheral= peripheral;
    [_CM stopScan];
    [self.activePeripheral setDelegate:self];
    [self.activePeripheral discoverServices:nil];
    NSLog(@"扫描服务");
   // [self synTime];

}

//连接外设失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%@",error);
}

-(void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    //NSLog(@"%s,%@",__PRETTY_FUNCTION__,peripheral);
    int rssi = abs([peripheral.RSSI intValue]);
    float ci = (rssi - 49) / (10 * 4.);
    NSString *length = [NSString stringWithFormat:@"发现BLT4.0热点:%@,距离:%.1fm",_activePeripheral,pow(10,ci)];
    NSLog(@"距离：%@",length);
}

//已发现服务
-(void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    
   // NSLog(@"发现服务.");
    int i=0;
    for (CBService *s in peripheral.services) {
        [self.services addObject:s];

    }
    for (CBService *s in peripheral.services) {
        NSLog(@"%@",[NSString stringWithFormat:@"发现服务%d:服务 UUID: %@(%@)",i,s.UUID.data,s.UUID]);
        if([s.UUID isEqual:[CBUUID UUIDWithString:@"180a"]]) {
            NSLog(@"发现无用的服务180a");
            NSLog(@"s.UUID.UUIDString=%@",s.UUID.UUIDString);
        continue;
        }
        i++;
        [peripheral discoverCharacteristics:nil forService:s];
    }
}

//已搜索到Characteristics
-(void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    NSLog(@"%@",[NSString stringWithFormat:@"下面的特征属于服务:%@ (%@)",service.UUID.data ,service.UUID]);
    for (CBCharacteristic *c in service.characteristics) {
        NSLog(@"\n发现特征值:characteristics=%@",c);
        NSLog(@"%@",[NSString stringWithFormat:@"特征UUID:%@(%@)",c.UUID.data,c.UUID]);
         if (![c.UUID isEqual:[CBUUID UUIDWithString:@"2A99"]])
         {
             return ;
         }
        
        if (c.isNotifying==NO) {
            NSLog(@"蓝牙不广播!");
            //return ;
        }
        
        if ([c.UUID isEqual:[CBUUID UUIDWithString:@"2A99"]]) {
            _writeCharacteristic = c;
           // NSLog(@"c=%@",c);
           // NSLog(@"characteristic.properties=%u",c.properties);
            [_activePeripheral setNotifyValue:YES forCharacteristic:_writeCharacteristic];
        }
        
        if ([c.UUID isEqual:[CBUUID UUIDWithString:@"2A19"]]) {
            [_activePeripheral readValueForCharacteristic:c];
        }
        
        if ([c.UUID isEqual:[CBUUID UUIDWithString:@"2A99"]]) {
            [_activePeripheral readRSSI];
        }
        [_characteristics addObject:c];
    }
   // [self synTime];
    //[self  synHistoryData];
    /*NSLog(@"self.delegate=%@",self.delegate);
    if (!self.delegate) {
        [self.delegate2 removeLinkingHUDImageView];
    }
    else {
        [self.delegate setTimerRun];
    }*/
    if (self.delegate) {
        [self getRealTimeData];
    }
}

//获取外设发来的数据，不论是read和notify,获取数据都是从这个方法中读取。
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    //NSLog(@"\n收到:characteristic=%@",characteristic);
    UInt16 characteristicUUID = [self CBUUIDToInt:characteristic.UUID];
    //NSLog(@"\n收到:characteristicUUID=%d",characteristicUUID);
    NSLog(@"\n收到蓝牙发来的数据包:%@",characteristic.value);
//    _dataCounter++;
//    if (_dataCounter==2) {
//        [self synTime];
//    }
//    if (_dataCounter<=2) {
//        return;
//    }
    
    if (!error) {
        switch (characteristicUUID) {
            case 65433:
            {
                uint8_t buf[4096] = {0};
                [characteristic.value getBytes:buf];
                if (buf[0]!=0xBB) {
                    return;
                }
                if (buf[2]==0x00) {
                    if (buf[3]==0x01) {
                        NSLog(@"同步时间成功!");
                    }
                    else NSLog(@"同步时间失败");
                }
                
                else  if (buf[2]==0x01) {
                    if (buf[3]==0x00) {
                        [self.delegate setTimerFire];
                        [self buildSportsTimer];
                        [self setsportsTimerRun];
                        // buf[4]开始为加速度值
                        uint8_t count1=buf[4];
                        uint8_t count2=buf[5];
                        NSInteger count=count1*16*16+count2;
                        NSLog(@"self.delegate=%@",_delegate);
                        if (!self.delegate) {
                            NSLog(@"self.delegate=%@",_delegate);
                            NSLog(@"我还没请求实时呢就发实时数据干嘛?");
                            return;
                        }
                        [self.delegate setTimerFire];
                        //[self.delegate setZeroTimerFire];
                        float A1=(float)buf[6]*30/1024;//强度G
                        float heat=((float)_sportsSeconds/8.0)*104;
                        float Hz=100.0/((buf[7]<<8)+buf[8]);
                        [self saveSportsDataWithCoreData:A1 Hz:Hz Count:count Time:_sportsSeconds Heat:heat Date:[NSDate date] Group:0];
                        [self.delegate addCountNum:count Intensity:A1 Hz:Hz];
                        NSLog(@"实时次数为:%ld",(long)count);
                        NSLog(@"实时强度为:%f",A1);
                        NSLog(@"实时频率为:%f", Hz);
                        [self.delegate1 addCountData:A1];
                        //[self.delegate setTimerRun];
                    }
                    
                    else if(buf[3]==0x01) {
                        NSLog(@"实时传输暂停了,并不一定战斗结束");
                    }
                    
                    else if(buf[3]==0x02)
                    {
                        NSLog(@"本次运动结束,会收到两个数据包");
                        if(buf[1]==0x0A) {
                            NSLog(@"收到第一个运动结束包");
                            NSDateComponents *comps = [[NSDateComponents alloc]init];
                            comps.year=((int)buf[4]+2000);comps.month=buf[5];comps.day=buf[6];
                            comps.hour=buf[7];
                            comps.minute=buf[8];comps.second=buf[9];
                            NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
                            NSDate *startDate = [calendar dateFromComponents:comps];
                            _syncResultData.startDate=startDate;
                            _syncResultData.totalTime
                            =[NSNumber numberWithInteger:((buf[10]<<8)+buf[11])];
                        }
                        
                        else{
                            NSLog(@"收到第二个运动结束包");
                            
                            if(_syncResultData.startDate==nil) {
                                NSLog(@"咦?怎么直接就收到第二个运动结束包了?");
                                return ;
                            }
                            
                            NSInteger countData=(buf[4]<<8)+buf[5];
                            
                            _syncResultData.totalCount=[NSNumber numberWithInteger:countData];
                            if (countData==0) {
                                _syncResultData.totalHeat=
                                [NSNumber numberWithFloat:0.0f];
                            }
                            else {
_syncResultData.totalHeat=[NSNumber numberWithFloat:(buf[6]<<24)+(buf[7]<<16)+(buf[8]<<8)+buf[9]];
                            }
                            _syncResultData.averageIn
                            =[NSNumber numberWithFloat
                              :(float)buf[10]*30/1024];
                            _syncResultData.maxIn
                            =[NSNumber numberWithFloat
                              :(float)buf[11]*30/1024];
                            
//                            int averagerHz=((buf[12]<<8)+buf[13]);
//                            int maxHz=((buf[14]<<8)+buf[15]);
//                            if (averagerHz==0) {
//                                _syncResultData.averageHz=
//                                [NSNumber numberWithFloat:100.0/((buf[12]<<8)+buf[13])];
//                            }
                            _syncResultData.averageHz=
                            [NSNumber numberWithFloat:100.0/((buf[12]<<8)+buf[13])];
                            _syncResultData.maxHz=
                            [NSNumber numberWithFloat:100.0/((buf[14]<<8)+buf[15])];
                            [self saveResultData:_syncResultData];
                            if (self.delegate) {
                                [self.delegate autoPopCurrentVC];
                                self.delegate=nil;
                                [_sportsTimer setFireDate:[NSDate distantFuture]];
                                _sportsSeconds=0;
                            }
                        }
                    }
                    else {NSLog(@"进入未知领域");}
                }
                
                else if (buf[2]==0x02)
                {
                    if (buf[3]==0x00)
                    {
                        NSLog(@"没有需要同步的数据哦");
                        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"没有需要同步的数据哦" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                        [alertView show];
                    }
                    
                    else if (buf[3]==0x01)
                    {
                        if (buf[1]==0x10) {
                        NSLog(@"收到第一个数据包");
                            _syncResultData.totalTime=[NSNumber numberWithInteger:(buf[10]<<8)+buf[11]];
                            _syncResultData.totalCount=[NSNumber numberWithInteger:(buf[12]<<8)+buf[13]];
                            _syncResultData.totalHeat=[NSNumber numberWithFloat:(buf[14]<<24)+(buf[15]<<16)+(buf[16]<<8)+buf[17]];
                        }
                        else if(buf[1]==0x0E) {
                           if(_syncResultData.totalTime==nil)
                           {
                               NSLog(@"同步历史的时候你怎么直接发第二个数据包过来了?");
                               return;
                           }
                            NSDateComponents *comps = [[NSDateComponents alloc]init];
                            comps.year=((int)buf[4]+2000);comps.month=buf[5];
                            comps.day=buf[6];
                            
                            comps.hour=buf[7];
                            comps.minute=buf[8];comps.second=buf[9];
                            NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
                            NSDate *startDate = [calendar dateFromComponents:comps];
                            //_theSecondthStartDate=startDate;
                            
                            if(_syncResultData.averageIn!=nil&&[_syncResultData.startDate isEqual:startDate])
                            {
                                NSLog(@"又收到第二个数据包,重复了,return");
                                return;
                            } NSLog(@"收到第二个数据包,没有重复");
                            
                NSNumber *averageIn=[NSNumber numberWithFloat:(float)buf[10]*30/1024];
                NSNumber *maxIn=[NSNumber numberWithFloat:(float)buf[11]*30/1024];
                NSNumber *averageHz=[NSNumber numberWithFloat:100.0/((buf[12]<<8)+buf[13])];
                NSNumber *maxHz=[NSNumber numberWithFloat:100.0/((buf[14]<<8)+buf[15])];
                if ([_syncResultData.startDate isEqual:startDate]&&[_syncResultData.averageIn
                    isEqual:averageIn]&&[_syncResultData.maxIn isEqual:maxIn]&&
                    [_syncResultData.averageHz isEqual:averageHz]&&
                    [_syncResultData.maxHz isEqual:maxHz])
                {
                    NSLog(@"又收到第二个数据包,重复了,return");
                    return;
                    
                }
                            
                _syncResultData.startDate=startDate;
                _syncResultData.averageIn=averageIn;
                _syncResultData.maxIn=maxIn;
                _syncResultData.averageHz=averageHz;
                _syncResultData.maxHz=maxHz;
                            
                [self saveResultData:_syncResultData];
                            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"同步成功" message:nil delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
                            [alertView show];
                        }
                    }
                }
                
                else if(buf[2]==0x03)
                {
                    NSLog(@"同步当前电量,电池电量百分比为:%d%%",buf[3]);
                    self.butteryPercent=buf[3];
                    if (self.delegate2) {
                        [self.delegate2 synButteryPercent:buf[3]];

                    }
                    
                    if (_sportsSeconds==0) {
                        [self synTime];
                        //[self  synHistoryData];
                        if (!self.delegate) {
                            [self.delegate2 removeLinkingHUDImageView];
                        }
                        else {
                            [self.delegate setTimerRun];
                        }
                    }
                }
            }
               /* case 0x180f:
            {
                uint8_t buf[4096] = {0};
                [characteristic.value getBytes:buf];
                if (buf[0]!=0xBB) {
                    return;
                }
                NSLog(@"同步当前电量");
                NSLog(@"\n收到蓝牙发来的数据包:%@",characteristic.value);
                NSLog(@"同步当前电量,电池电量百分比为:%d%%",buf[3]);
            }
        break;
            default:
                break;*/
        }
    }
   // [self.delegate setTimerRun];
}

    -(UInt16) CBUUIDToInt:(CBUUID *) UUID {
        char b1[16];
        [UUID.data getBytes:b1];
        return ((b1[0] << 8) | b1[1]);
    }

//中心读取外设实时数据

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"收到通知:%@,%@",characteristic,characteristic.value);
    NSLog(@"Error changing notification state: %@", error.localizedDescription);
    
    if (error) {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
    }
    // Notification has started
    if (characteristic.isNotifying) {
        [peripheral readValueForCharacteristic:characteristic];
        
    } else { // Notification has stopped
        // so disconnect from the peripheral
        NSLog(@"Notification stopped on %@.  Disconnecting", characteristic);
        [self.CM cancelPeripheralConnection:self.activePeripheral];
    }
}

//用于检测中心向外设写数据是否成功
-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"error=%@",error);
    if (error)
    {
        NSLog(@"发送数据失败");
        NSLog(@"error=======%@",error.userInfo);
    }else{
        NSLog(@"发送数据成功");
    }
}
-(void)NowDate
{
    NSString* date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    date = [formatter stringFromDate:[NSDate date]];
}
#pragma mark--同步时间

-(void) synTime
{
    if((_activePeripheral.state==CBPeripheralStateConnected))
    {
        NSDate * Now = [NSDate date];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags = NSYearCalendarUnit |
        NSMonthCalendarUnit |
        NSDayCalendarUnit |
        NSWeekdayCalendarUnit |
        NSHourCalendarUnit |
        NSMinuteCalendarUnit |
        NSSecondCalendarUnit;
        comps = [calendar components:unitFlags fromDate:Now];
        int year = [comps year]%100;//year=14
        NSInteger month = [comps month];
        NSInteger day = [comps day];
        NSInteger hour = [comps hour];
        NSInteger min = [comps minute];
        NSInteger sec =  [comps second];
        uint8_t  SetYear = (year/16)*16+year%16;
        uint8_t SetMonth = (month/16)*16+month%16;
        uint8_t SetDay = (day/16)*16+day%16;
        uint8_t SetHour = (hour/16)*16+hour%16;
        uint8_t SetMin = (min/16)*16+min%16;
        uint8_t SetSec = (sec/16)*16+sec%16;
        uint8_t b[] = {0xAA,0x07,0x00,SetYear,SetMonth,SetDay,SetHour,SetMin,SetSec,0x07+0x00+SetYear+SetMonth+SetDay+SetHour+SetSec+SetMin,0x55};
        NSMutableData *data = [[NSMutableData alloc] initWithBytes:b length:11];
        [self writeValue:0x1899 characteristicUUID:0x2A99 p:_activePeripheral data:data];
    }
}

#pragma mark--开始实时数据传输
-(void)getRealTimeData
{
    SportsDataDAO *DAO=[SportsDataDAO shareManager];
    if([DAO removeAllSportsData]==0)
    {
        NSLog(@"删除实时数据缓存成功");
    }
    uint8_t b[]={0xAA,0x02,0x01,0x00,0x03,0x55};
    NSMutableData *data=[[NSMutableData alloc]initWithBytes:b length:6];
    
    [self writeValue:0x1899 characteristicUUID:0x2A99 p:self.activePeripheral data:data];
    [_sportsTimer setFireDate:[NSDate distantPast]];
    //[self.delegate setZeroTimerRun];
    [self.delegate setTimerRun];
}

#pragma mark--暂停实时数据传输
-(void)endReciveRealTimeData
{
    uint8_t b[]={0xAA,0x02,0x01,0x01,0x04,0x55};
    NSMutableData *data=[[NSMutableData alloc]initWithBytes:b length:6];
    [self writeValue:BLE_SERVICE characteristicUUID:BLE_CHARACTERISTICS p:self.activePeripheral data:data];
//    SportsDataDAO *DAO=[SportsDataDAO shareManager];
//    [DAO updateLastDataTime:(int)_sportsSeconds];
  //  _sportsSeconds=0;
    [_sportsTimer setFireDate:[NSDate distantFuture]];
    //[self.delegate setZeroTimerFire];
    [self.delegate setTimerFire];
}

#pragma mark--结束实时数据传输
-(void)finishRealTimeSports
{
    uint8_t b[]={0xAA,0x02,0x01,0x02,0x05,0x55};
    NSMutableData *data=[[NSMutableData alloc]initWithBytes:b length:6];
    [self writeValue:BLE_SERVICE characteristicUUID:BLE_CHARACTERISTICS p:self.activePeripheral data:data];
    SportsDataDAO *DAO=[SportsDataDAO shareManager];
    [DAO updateLastDataTime:(int)_sportsSeconds];
    _sportsSeconds=0;
    [_sportsTimer setFireDate:[NSDate distantFuture]];
}

#pragma mark--同步历史数据
-(void)synHistoryData
{
    uint8_t b[]={0xAA,0x01,0x02,0x03,0x55};
    NSMutableData *data=[[NSMutableData alloc]initWithBytes:b length:5];
    [self writeValue:BLE_SERVICE characteristicUUID:BLE_CHARACTERISTICS p:self.activePeripheral data:data];
}

#pragma mark--同步当前电量
-(void)synCurrentBatteryQuantity
{
    uint8_t b[]={0xAA,0x02,0x03,0x05,0x55};
    NSMutableData *data=[[NSMutableData alloc]initWithBytes:b length:6];
    [self writeValue:BLE_BATTERY_SERVICE characteristicUUID:BLE_BATTERY_CHARACTERISTICS p:self.activePeripheral data:data];
}

-(CBService *) findServiceFromUUID:(CBUUID *)UUID p:(CBPeripheral *)p
{
    for(int i = 0; i < p.services.count; i++) {
        CBService *s = [p.services objectAtIndex:i];
        if ([self compareCBUUID:s.UUID UUID2:UUID]) return s;
    }
    return nil; //Service not found on this peripheral
}

-(CBCharacteristic *) findCharacteristicFromUUID:(CBUUID *)UUID service:(CBService*)service {
    for(int i=0; i < service.characteristics.count; i++) {
        CBCharacteristic *c = [service.characteristics objectAtIndex:i];
        if ([self compareCBUUID:c.UUID UUID2:UUID]) return c;
    }
    return nil; //Characteristic not found on this service
}





- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    if (error==nil) {
        NSLog(@"用户手动断开的");
    }
    else {
        NSLog(@"意外断开连接了%@",error);
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"与硬件断开连接了!" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alertView show];
        if (self.delegate) {
            [self.CM connectPeripheral:self.activePeripheral options:nil];
        }
    }
}



-(void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
    
}

-(void)retrieveConnect:(CBUUID*)uuid
{
    
}



- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error {
}




- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    
}


-(void)writeValue:(int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p data:(NSData *)data
{
    //NSLog(@"WRITE:====:%04X, %04X", serviceUUID, characteristicUUID);
    
    UInt16 s = [self swap:serviceUUID];
    UInt16 c = [self swap:characteristicUUID];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUID:su p:p];
    if (!service) {
        NSLog(@"Could not find service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:su],[self UUIDToString:p.UUID]);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:cu service:service];
    if (!characteristic) {
        NSLog(@"Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:cu],[self CBUUIDToString:su],[self UUIDToString:p.UUID]);
        return;
    }
    //    [p writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse]; //TI
    [p writeValue:data forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];  //ISSC
    NSLog(@"手机给外设发送数据:%@",data);
}

-(void)readValue: (int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p
{
    //NSLog(@"READ:====:%04X, %04X", serviceUUID, characteristicUUID);
    
    UInt16 s = [self swap:serviceUUID];
    UInt16 c = [self swap:characteristicUUID];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUID:su p:p];
    if (!service) {
        NSLog(@"Could not find service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:su],[self UUIDToString:p.UUID]);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:cu service:service];
    if (!characteristic) {
        NSLog(@"Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:cu],[self CBUUIDToString:su],[self UUIDToString:p.UUID]);
        return;
    }
    [p readValueForCharacteristic:characteristic];
}

-(UInt16) swap:(UInt16)s {
    UInt16 temp = s << 8;
    temp |= (s >> 8);
    return temp;
}

- (int) findBLEPeripherals:(int) timeout
{
    
    NSLog(@"%s",[self centralManagerStateToString:self.CM .state]);
    //   [NSTimer scheduledTimerWithTimeInterval:(float)timeout target:self selector:@selector(scanTimer:) userInfo:nil repeats:NO];
    [self.CM scanForPeripheralsWithServices:nil options:0];
    //    [self.delegate setButtonState];
    return 0;
}

/*
- (void) connectPeripheral:(CBPeripheral *)peripheral {
    //Print("Connecting to peripheral with UUID : %s\r\n",[self UUIDToString:peripheral.UUID]);
    activePeripheral = peripheral;
    activePeripheral.delegate = self;
    [CM connectPeripheral:activePeripheral options:nil];
    //    [self.delegate  setButtonState];
}

-(void)disconnect:(CBPeripheral *)peripheral
{
    activePeripheral = peripheral;
    activePeripheral.delegate = self;
    [CM cancelPeripheralConnection:activePeripheral];
    
}
*/


- (const char *) centralManagerStateToString: (int)state {
    
    switch(state) {
        case CBCentralManagerStateUnknown:
            return "State unknown";
        case CBCentralManagerStateResetting:
            return "State resetting";
        case CBCentralManagerStateUnsupported:
            return "State BLE unsupported";
        case CBCentralManagerStateUnauthorized:
            return "State unauthorized";
        case CBCentralManagerStatePoweredOff:
            
            return "State BLE powered off";
            
            
        case CBCentralManagerStatePoweredOn:
            return "State powered up and ready";
        default:
            return "State unknown";
    }
    return "Unknown state";
    
}

- (int) UUIDSAreEqual:(CFUUIDRef)u1 u2:(CFUUIDRef)u2 {
    CFUUIDBytes b1 = CFUUIDGetUUIDBytes(u1);
    CFUUIDBytes b2 = CFUUIDGetUUIDBytes(u2);
    if (memcmp(&b1, &b2, 16) == 0) {
        return 1;
    }
    else return 0;
}

-(void) getAllServicesFromKeyfob:(CBPeripheral *)p{
    [p discoverServices:nil]; // Discover all services without filter
    
}

-(void) getAllCharacteristicsFromKeyfob:(CBPeripheral *)p{
    for (int i=0; i < p.services.count; i++) {
        NSLog(@"servive = %@",[p.services objectAtIndex:i]);
        //过滤不需要的uuid
        
        CBService *s = [p.services objectAtIndex:i];
        NSString * str = [NSString stringWithFormat:@"%s",[self CBUUIDToString:s.UUID]];
        if([str isEqualToString:@"<fff0>"])
            //        NSLog(@"Fetching characteristics for service with UUID : %s\r",[self CBUUIDToString:s.UUID]);
            [p discoverCharacteristics:nil forService:s];
    }
}

-(const char *) CBUUIDToString:(CBUUID *) UUID {
    return [[UUID.data description] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
}

-(const char *) UUIDToString:(CFUUIDRef)UUID {
    if (!UUID) return "NULL";
    CFStringRef s = CFUUIDCreateString(NULL, UUID);
    return CFStringGetCStringPtr(s, 0);
    
}

-(char*)ProcessUUIDString:(const char*)uuid_str Result:(char*)str
{
    const char *p = uuid_str;
    int len = strlen(p);
    int i = 0;
    
    for (; i < len; i++) {
        if (p[i] == '<' || p[i] == '>' || p[i] == ' ' || p[i] == '-') {
            continue;
        }
        *str++ = toupper(p[i]);
    }
    
    return str;
}

-(int) compareCBUUID:(CBUUID *) UUID1 UUID2:(CBUUID *)UUID2 {
    char b1[16];
    char b2[16];
    [UUID1.data getBytes:b1];
    [UUID2.data getBytes:b2];
    int n = memcmp(b1, b2, UUID1.data.length);
    if (n == 0)return 1;
    else return 0;
}

-(int) compareCBUUIDToInt:(CBUUID *)UUID1 UUID2:(UInt16)UUID2 {
    char b1[16];
    [UUID1.data getBytes:b1];
    UInt16 b2 = [self swap:UUID2];
    if (memcmp(b1, (char *)&b2, 2) == 0) return 1;
    else return 0;
}



-(CBUUID *) IntToCBUUID:(UInt16)UUID {
    char t[16];
    t[0] = ((UUID >> 8) & 0xff); t[1] = (UUID & 0xff);
    NSData *data = [[NSData alloc] initWithBytes:t length:16];
    return [CBUUID UUIDWithData:data];
}
#pragma -mark 计时器
-(void)buildSportsTimer {
    static dispatch_once_t buildSportsTimerOnce;
    dispatch_once(&buildSportsTimerOnce, ^{
        [self initTimer];
    });
//    dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(queue, ^{
//        [self initTimer];
//    });
}
-(void)initTimer {
    _sportsTimer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sportsTimeSconds) userInfo:nil repeats:YES];
    _sportsSeconds=0;
}
-(void)sportsTimeSconds {
    _sportsSeconds++;
    [self.delegate renewSportsTime];
}
//开启定时
-(void)setsportsTimerRun {
    static dispatch_once_t setsportsTimerRunOnce;
    dispatch_once(&setsportsTimerRunOnce, ^{
        [_sportsTimer setFireDate:[NSDate distantPast]];
    });
}
#pragma -mark 数据库
-(BOOL)saveSportsDataWithCoreData:(NSInteger)intensity
                               Hz:(float)hz
                            Count:(NSInteger)count
                             Time:(NSInteger)time
                             Heat:(float)heat
                             Date:(NSDate*)date
                             Group:(NSInteger)group
{
    SportsDataDAO *DAO=[SportsDataDAO shareManager];
    SportsData *sportsData=[[SportsData alloc]init];
    sportsData.intensity=[NSNumber numberWithInteger:intensity];
    sportsData.hz=[NSNumber numberWithFloat:hz];
    sportsData.count=[NSNumber numberWithInteger:count];
    sportsData.time=[NSNumber numberWithInteger:time];
    sportsData.heat=[NSNumber numberWithFloat:heat];
    sportsData.date=date;
    if ([DAO create:sportsData]==0) {
        NSLog(@"实时数据保存到CoreDate成功了");
        return YES;
    }
    else return NO;
}
-(BOOL)saveResultData:(NSDate*)startDate
            TotalTime:(NSInteger)time
           TotalCount:(NSInteger)count
            TotalHeat:(float)heat
            AverageIn:(float)intesity
                MaxIn:(float)maxIn
            AverageHz:(float)averageHz
                MaxHz:(float)maxHz
{
    
    ResultDataDAO *DAO=[ResultDataDAO shareManager];
    ResultData *resultData=[[ResultData alloc]init];
    resultData.startDate=startDate;
    resultData.totalTime=[NSNumber numberWithInteger:time];
    resultData.totalCount=[NSNumber numberWithInteger:count];
    resultData.totalHeat=[NSNumber numberWithFloat:heat];
    resultData.averageIn=[NSNumber numberWithFloat:intesity];
    resultData.maxIn=[NSNumber numberWithFloat:maxIn];
    resultData.averageHz=[NSNumber numberWithFloat:averageHz];
    resultData.maxHz=[NSNumber numberWithFloat:maxHz];

    if ([DAO create:resultData]==0) {
        NSLog(@"历史数据保存到CoreDate成功了");
        return YES;
    }
    else return NO;

}

-(BOOL)saveResultData:(ResultData*)model
{
    ResultDataDAO *DAO=[ResultDataDAO shareManager];
    if ([DAO create:model]==0) {
        NSLog(@"历史数据保存到CoreDate成功了");
        return YES;
    }
    else return NO;
}
@end
