//
//  ResultDataDAO.h
//  XingAi02
//
//  Created by Lihui on 14/12/4.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//

#import "CoreDataDAO.h"
#import "ResultData.h"
#import "ResultDataDAO.h"
#import "ResultDataManagedObject.h"

@interface ResultDataDAO : CoreDataDAO

@property(nonatomic,strong) NSMutableArray *listData;
+(ResultDataDAO*)shareManager;
-(int)create:(ResultData*)model;
-(NSMutableArray*) findAll;
-(int) remove :(ResultData*)model;
-(NSMutableArray*)findResultDataWithYearAndMonth:(int)year
                                           Month:(int)month;
-(NSMutableArray*)findResultDataWithYearAndMonthAndDay:(int)year
                                                 Month:(int)month
                                                   Day:(int)day;
@end
