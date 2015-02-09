//
//  BlueDAO.m
//  CoreData01
//
//  Created by Lihui on 14/11/16.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//

#import "SportsDataDAO.h"

@implementation SportsDataDAO

static SportsDataDAO *shareManager;
+(SportsDataDAO*)shareManager {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shareManager=[[self alloc]init];
        shareManager.listData=[[NSMutableArray alloc]init];
    });
    return shareManager;
}

-(int)create:(SportsData*)model
{
    NSManagedObjectContext *cxt=[self managedObjectContext];
    
    DataManagedObject *data=[NSEntityDescription insertNewObjectForEntityForName:@"SportsData" inManagedObjectContext:cxt];
    [data setValue:model.count forKey:@"count"];
    [data setValue:model.hz forKey:@"hz"];
    [data setValue:model.time forKey:@"time"];
    [data setValue:model.heat forKey:@"heat"];
    [data setValue:model.intensity forKey:@"intensity"];
    [data setValue:model.date forKey:@"date"];
    NSError *saveingError=nil;
    if ([self.managedObjectContext save:&saveingError]) {
        NSLog(@"插入数据成功");
    }
    else {
        NSLog(@"插入数据失败");
        return -1;
    }
    return 0;
}
//查找所有
-(NSMutableArray*) findAll
{
    NSManagedObjectContext *cxt=[self managedObjectContext];
    NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"SportsData" inManagedObjectContext:cxt];
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    //制定排序字段和排序方式
    NSSortDescriptor *sortDescriptor1=[[NSSortDescriptor alloc]initWithKey:@"count" ascending:YES];
    NSSortDescriptor *sortDescriptor2=[[NSSortDescriptor alloc]initWithKey:@"date" ascending:YES];

    [request setSortDescriptors:@[sortDescriptor2,sortDescriptor1]];
    NSError *error=nil;
    NSArray *listData=[cxt executeFetchRequest:request error:&error];
    
    NSMutableArray *resListData=[[NSMutableArray alloc]init];
    
    for (DataManagedObject *mo in listData) {
        SportsData *data=[[SportsData alloc]init];
        data.count=mo.count;
        data.intensity=mo.intensity;
        data.hz=mo.hz;
        data.date=mo.date;
        data.heat=mo.heat;
        data.time=mo.time;
        [resListData addObject:data];
    }
    return resListData;
}
//按条件查询
-(SportsData*)findById:(SportsData*)model
{
    NSManagedObjectContext *cxt=[self managedObjectContext];
    NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"SportsData" inManagedObjectContext:cxt];
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"date = %@",model.date];
    [request setPredicate:predicate];
    NSError *error=nil;
    NSArray *listData=[cxt executeFetchRequest:request error:&error];
    if ([listData count]>0) {
        DataManagedObject *mo=[listData lastObject];
        SportsData *data=[[SportsData alloc]init];
        data.date=mo.date;
        return data;
    }
    return nil;
}
-(int) remove:(SportsData *)model
{
    NSManagedObjectContext *cxt=[self managedObjectContext];
    
    NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"SportsData" inManagedObjectContext:cxt];
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"count = %@",model.count];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData=[cxt executeFetchRequest:request error:&error];
    if ([listData count]>0) {
        DataManagedObject *data= [listData lastObject];
        [self.managedObjectContext deleteObject:data];
        
        NSError *saveError = nil;
        if ([self.managedObjectContext save:&saveError]) {
            NSLog(@"删除数据成功");
        }
        else {
            NSLog(@"删除数据失败");
            return -1;
        }
    }
    return 0;
}

-(int)removeAllSportsData
{
    NSManagedObjectContext *cxt=[self managedObjectContext];
    
    NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"SportsData" inManagedObjectContext:cxt];
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    
    //    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"count = %@",model.startDate];
    //    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData=[cxt executeFetchRequest:request error:&error];
    if ([listData count]>0) {
        for (DataManagedObject *data in listData)
        {
            [self.managedObjectContext deleteObject:data];
        }
        NSError *saveError = nil;
        if ([self.managedObjectContext save:&saveError]) {
            NSLog(@"删除所有SportsData数据成功");
        }
        else {
            NSLog(@"删除所有SportsData数据失败");
            return -1;
        }
    }
    return 0;
}
//修改最后一条的数据的时间
-(BOOL)updateLastDataTime:(int)time
{
    NSManagedObjectContext *cxt=[self managedObjectContext];
    
    NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"SportsData" inManagedObjectContext:cxt];
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    
    NSError *error = nil;
    NSArray *listData=
    [cxt executeFetchRequest:request error:&error];
    DataManagedObject *data=[listData lastObject];
    data.time=[NSNumber numberWithInt:time];
    
    if ([cxt save:&error]) {
        //更新成功
       // NSLog(@"更新时间成功");
        return YES;
    }
    
    return NO;
}

@end
