//
//  WaveViewController.h
//  XingAi02
//
//  Created by Lihui on 14/11/14.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawWave.h"
#import "BLEControl.h"
#import "DrawData.h"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface WaveViewController :UIViewController<BleControlDelegate>
@property(nonatomic,retain) DrawWave *wave;
@property(nonatomic,retain)BLEControl *bleControl;
@property(nonatomic,retain) DrawData *wave1;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property(nonatomic,retain)UILabel *label;
@property(nonatomic,assign)BOOL isEndGetReciveData;
- (IBAction)clickStartButton:(id)sender;
- (IBAction)clickReturnButton:(id)sender;


@end
