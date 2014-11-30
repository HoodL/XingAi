//
//  DrawData.h
//  XingAi02
//
//  Created by Lihui on 14/11/14.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLEControl.h"
@interface DrawData : UIView<BleDataDelegate>

@property(nonatomic,retain)NSMutableArray *dataList;
@property(nonatomic,retain)BLEControl *bleControl;

- (void)callDrawWithData:(NSMutableArray*) data;
-(void) addZeroNum;
@end
