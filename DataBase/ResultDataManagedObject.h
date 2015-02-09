//
//  ResultDataManagedObject.h
//  XingAi02
//
//  Created by Lihui on 14/12/4.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ResultDataManagedObject : NSManagedObject

@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSNumber * totalTime;
@property (nonatomic, retain) NSNumber * totalCount;
@property (nonatomic, retain) NSNumber * totalHeat;
@property (nonatomic, retain) NSNumber * averageIn;
@property (nonatomic, retain) NSNumber * maxIn;
@property (nonatomic, retain) NSNumber * averageHz;
@property (nonatomic, retain) NSNumber * maxHz;

@end
