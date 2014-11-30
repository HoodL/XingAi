//
//  DeviceVC.h
//  XingAi02
//
//  Created by Lihui on 14/11/13.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLEControl.h"
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


@interface DeviceVC : UIViewController<BleControlDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;
@property (strong, nonatomic) IBOutlet UIButton *returnButton;
- (IBAction)clickReturnButton:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *deviceTabView;
@property (nonatomic,assign)  int tagComingFromWhichVC;
@property(nonatomic,retain)  NSMutableArray *deviceList;
@property(nonatomic,retain)  BLEControl *bleControl;
- (IBAction)clickScanButton:(id)sender;
- (IBAction)shishiButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *scanButton;

@end
