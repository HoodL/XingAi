//
//  BlueDAO.h
//  CoreData01
//
//  Created by Lihui on 14/11/16.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//

#import "CoreDataDAO.h"
#import "DataManagedObject.h"
#import "SportsData.h"
#import "SportsDataDAO.h"
@interface SportsDataDAO : CoreDataDAO

@property(nonatomic,strong) NSMutableArray *listData;
+(SportsDataDAO*)shareManager;
-(int)create:(SportsData*)model;
-(NSMutableArray*) findAll;
-(int) remove :(SportsData*)model;

@end
