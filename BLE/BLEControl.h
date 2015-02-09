//
//  BLEControl.h
//  XingAi02
//
//  Created by Lihui on 14/11/14.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBService.h>

#import "BLEDefine.h"
#import "SportsDataDAO.h"

#import "BLEDevice.h"
@protocol BleControlDelegate
@optional
-(void)autoPopCurrentVC;
-(void)setTimerFire;
-(void)setTimerRun;
-(void)setZeroTimerFire;
-(void)setZeroTimerRun;

//-(void)ScanStop;
//-(void)reloadUI;
-(void)addCountNum:(NSInteger)num
         Intensity:(float)intensity
                Hz:(float)hz;
-(void)renewSportsTime;
@end

@protocol BleDataDelegate
@optional
-(void)addCountData:(float)data;
@end

@protocol BLEDeviceControlDelegate <NSObject>
-(void)removeLinkingHUDImageView;
-(void)addPeripherals:(CBPeripheral*)peripheral;
//-(void)addPeripherals:(BLEDevice*) device;
//-(void)refreshDeviceList;//刷新硬件列表
-(void)synButteryPercent:(int)percent;
@end


@interface BLEControl : NSObject<CBCentralManagerDelegate, CBPeripheralDelegate,CBPeripheralManagerDelegate>

@property (nonatomic,weak) id <BleControlDelegate> delegate;
@property (nonatomic,weak) id <BleDataDelegate> delegate1;
@property (nonatomic,weak) id <BLEDeviceControlDelegate> delegate2;

@property (strong, nonatomic)  NSMutableArray *peripherals;
@property (strong ,nonatomic) NSMutableArray * arrayRSSI;
@property (strong, nonatomic) CBCentralManager *CM;
@property (strong, nonatomic)CBPeripheralManager * manager;
@property (strong, nonatomic) CBPeripheral *activePeripheral;

@property (strong, nonatomic) NSMutableArray *services;
@property (strong, nonatomic) NSMutableArray *characteristics;
@property (strong ,nonatomic) CBCharacteristic *writeCharacteristic;
@property(nonatomic,assign) NSInteger dataCounter;
@property(nonatomic,retain)NSTimer *sportsTimer;
@property(nonatomic,assign)NSInteger sportsSeconds;
//@property(nonatomic,assign)CBPeripheralState activePeripheralState;
@property(nonatomic,assign)int butteryPercent;
-(void) scanClick;
-(void) connectPeripheral:(CBPeripheral *)peripheral;
-(void) disconnect:(CBPeripheral*)peripheral;//断开连接
-(CBService *) findServiceFromUUID:(CBUUID *)UUID p:(CBPeripheral *)p;

-(CBCharacteristic *) findCharacteristicFromUUID:(CBUUID *)UUID service:(CBService*)service;
-(int) findBLEPeripherals:(int) timeout;
-(void) synTime;
+(BLEControl*)sharedBLEControl;
-(void)getRealTimeData;
-(void)endReciveRealTimeData;
-(void)synHistoryData;
-(void)finishRealTimeSports;
@end
