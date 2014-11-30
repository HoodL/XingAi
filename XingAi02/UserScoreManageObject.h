//
//  UserScoreManageObject.h
//  XingAi02
//
//  Created by Lihui on 14/11/26.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserScoreManageObject : NSManagedObject

@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSDate * date;

@end
