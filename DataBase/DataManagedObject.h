//
//  DataManagedObject.h
//  XingAi02
//
//  Created by Lihui on 14/11/23.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DataManagedObject : NSManagedObject

@property (nonatomic, retain) NSNumber * hz;
@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSNumber * intensity;
@property (nonatomic, retain) NSNumber * heat;
@property (nonatomic, retain) NSDate   * date;

@end
