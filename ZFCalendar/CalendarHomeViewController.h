//
//  CalendarHomeViewController.h
//  Calendar
//
//  Created by 张凡 on 14-6-23.
//  Copyright (c) 2014年 张凡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarViewController.h"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


@interface CalendarHomeViewController : CalendarViewController

//@property (weak, nonatomic) IBOutlet UIBarButtonItem *returnButton;

- (void)setAirPlaneToDay:(int)day ToDateforString:(NSString *)todate;//飞机初始化方法

- (void)setHotelToDay:(int)day ToDateforString:(NSString *)todate;//酒店初始化方法

- (void)setTrainToDay:(int)day ToDateforString:(NSString *)todate;//火车初始化方法

@end
