//
//  CalendarLogic1.h
//  Calendar
//
//  Created by 张凡 on 14-7-3.
//  Copyright (c) 2014年 张凡. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "CalendarDayModel.h"
#import "NSDate+WQCalendarLogic.h"
#import "DataGroup.h"
@interface CalendarLogic : NSObject
@property(nonatomic,retain)NSMutableArray *sportsDateList;

- (NSMutableArray *)reloadCalendarView:(NSDate *)date  selectDate:(NSDate *)date1 needDays:(int)days_number;
- (void)selectLogic:(CalendarDayModel *)day;
//-(NSMutableArray*)findAllSportsDataFromCoreData;
-(NSMutableArray*)findAllResultData;
-(NSMutableArray *) findDataWithYearAndMonth:(NSInteger)year
                                    Month:(NSInteger)month;

-(NSMutableArray*) findDataWithDay:(NSInteger)day
                              Year:(int)year
                             Month:(int)month;
@end
