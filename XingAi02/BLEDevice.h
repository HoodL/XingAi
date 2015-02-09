//
//  BLEDevice.h
//  XingAi02
//
//  Created by Lihui on 14/12/30.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBService.h>

@interface BLEDevice : NSObject

@property(nonatomic,strong) CBPeripheral *peripheral;
@property(nonatomic,assign) int  butteryPercent;
@property(nonatomic,assign) BOOL isConnected;

@end
