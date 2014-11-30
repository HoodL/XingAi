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

@protocol BleControlDelegate
@optional
-(void)setTimerFire;
-(void)setTimerRun;
-(void)setZeroTimerFire;
-(void)setZeroTimerRun;

-(void)ScanStop;
-(void)addPeripherals:(CBPeripheral*)peripheral;
-(void)reloadUI;
-(void)addCountNum:(NSInteger)num
         Intensity:(NSInteger)intensity
                Hz:(float)hz;
-(void)removeLinkingHUDImageView;
-(void)renewSportsTime;
@end

@protocol BleDataDelegate
@optional
-(void)addCountData:(NSInteger)data;
@end
@interface BLEControl : NSObject<CBCentralManagerDelegate, CBPeripheralDelegate,CBPeripheralManagerDelegate>

@property (nonatomic,strong) id <BleControlDelegate> delegate;
@property (nonatomic,strong) id <BleDataDelegate> delegate1;

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
@property(nonatomic,assign)CBPeripheralState activePeripheralState;
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

//-(void) writeValue:(int)serviceUUID characteristicUUID:(int)characteristicUUID  p:(CBPeripheral *)p data:(NSData *)data;
//-(void) readValue: (int)serviceUUID characteristicUUID:(int)characteristicUUID  p:(CBPeripheral *)p;

@end
