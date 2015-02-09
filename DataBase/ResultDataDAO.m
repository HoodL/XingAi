//
//  ResultDataDAO.m
//  XingAi02
//
//  Created by Lihui on 14/12/4.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//

#import "ResultDataDAO.h"

@implementation ResultDataDAO
static ResultDataDAO *shareManager;
+(ResultDataDAO*)shareManager {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shareManager=[[self alloc]init];
        shareManager.listData=[[NSMutableArray alloc]init];
    });
    return shareManager;
}

-(int)create:(ResultData*)model
{
    NSManagedObjectContext *cxt=[self managedObjectContext];
    
    ResultDataManagedObject *data=[NSEntityDescription insertNewObjectForEntityForName:@"ResultData" inManagedObjectContext:cxt];
    [data setValue:model.startDate forKey:@"startDate"];
    [data setValue:model.totalTime forKey:@"totalTime"];
    [data setValue:model.totalHeat forKey:@"totalHeat"];
    [data setValue:model.totalCount forKey:@"totalCount"];
    [data setValue:model.averageIn forKey:@"averageIn"];
    [data setValue:model.maxIn forKey:@"maxIn"];
    [data setValue:model.averageHz forKey:@"averageHz"];
    [data setValue:model.maxHz forKey:@"maxHz"];
    
    NSError *saveingError=nil;
    if ([self.managedObjectContext save:&saveingError]) {
        NSLog(@"插入ResultData数据成功");
    }
    else {
        NSLog(@"插入ResultData数据失败");
        return -1;
    }
    return 0;
}
//查找所有
-(NSMutableArray*) findAll
{
    NSManagedObjectContext *cxt=[self managedObjectContext];
    NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"ResultData" inManagedObjectContext:cxt];
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    //制定排序字段和排序方式
    NSSortDescriptor *sortDescriptor=[[NSSortDescriptor alloc]initWithKey:@"startDate" ascending:YES];
    
    [request setSortDescriptors:@[sortDescriptor]];
    NSError *error=nil;
    NSArray *listData=[cxt executeFetchRequest:request error:&error];
    
    NSMutableArray *resListData=[[NSMutableArray alloc]init];
    
    for (ResultDataManagedObject *mo in listData) {
        ResultData *data=[[ResultData alloc]init];
        data.startDate=mo.startDate;
        data.totalTime=mo.totalTime;
        data.totalCount=mo.totalCount;
        data.totalHeat=mo.totalHeat;
        data.averageIn=mo.averageIn;
        data.maxIn=mo.maxIn;
        data.averageHz=mo.averageHz;
        data.maxHz=mo.maxHz;
        
        [resListData addObject:data];
    }
    return resListData;
}
//按条件查询
-(ResultData*)findById:(ResultData*)model
{
    NSManagedObjectContext *cxt=[self managedObjectContext];
    NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"ResultData" inManagedObjectContext:cxt];
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"date = %@",model.startDate];
    [request setPredicate:predicate];
    NSError *error=nil;
    NSArray *listData=[cxt executeFetchRequest:request error:&error];
    if ([listData count]>0) {
        ResultDataManagedObject *mo=[listData lastObject];
        ResultData *data=[[ResultData alloc]init];
        data.startDate=mo.startDate;
        return data;
    }
    return nil;
}
#pragma mark--按照年和月查找
-(NSMutableArray*)findResultDataWithYearAndMonth:(int)year
                                           Month:(int)month
{
    NSManagedObjectContext *cxt=[self managedObjectContext];
    NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"ResultData" inManagedObjectContext:cxt];
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    NSDateComponents *comps1 = [[NSDateComponents alloc]init];
    comps1.year=year;comps1.month=month;
    comps1.day=1; comps1.hour=0;comps1.minute=0;comps1.second=0;
    NSCalendar *calendar1 = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *startDate1 = [calendar1 dateFromComponents:comps1];

    NSDateComponents *comps2 = [[NSDateComponents alloc]init];
    if(month<12) {
    comps2.month=month+1; comps2.year=year;
    }
    else{
        comps2.month=1;comps2.year=year+1;
    }
    comps2.day=1; comps2.hour=0;comps2.minute=0;comps2.second=0;
    NSCalendar *calendar2 = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *startDate2 = [calendar2 dateFromComponents:comps2];
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"startDate >= %@ AND startDate < %@",startDate1,startDate2];
    
    [request setPredicate:predicate];
    NSError *error=nil;
    NSArray *listData=[cxt executeFetchRequest:request error:&error];
    if ([listData count]>0) {
        NSMutableArray *dataList=[[NSMutableArray alloc]initWithCapacity:0];
        for ( ResultDataManagedObject *mo in listData) {
            ResultData *data=[[ResultData alloc]init];
            data.startDate=mo.startDate;
            data.totalTime=mo.totalTime;
            data.totalCount=mo.totalCount;
            data.totalHeat=mo.totalHeat;
            data.averageIn=mo.averageIn;
            data.maxIn=mo.maxIn;
            data.averageHz=mo.averageHz;
            data.maxHz=mo.maxHz;
            [dataList addObject:data];
        }
        return dataList;
    }
    return nil;

}
#pragma mark--按照某一天的查找数据
-(NSMutableArray*)findResultDataWithYearAndMonthAndDay:(int)year
                                           Month:(int)month
                                             Day:(int)day
{
    NSManagedObjectContext *cxt=[self managedObjectContext];
    NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"ResultData" inManagedObjectContext:cxt];
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    NSDateComponents *comps1 = [[NSDateComponents alloc]init];
    comps1.year=year;comps1.month=month;
    comps1.day=day; comps1.hour=0;comps1.minute=0;comps1.second=0;
    NSCalendar *calendar1 = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *startDate1 = [calendar1 dateFromComponents:comps1];
    
    NSDateComponents *comps2 = [[NSDateComponents alloc]init];
    comps2.month=month; comps2.year=year;
    comps2.day=day; comps2.hour=23;comps2.minute=59;comps2.second=59;
    NSCalendar *calendar2 = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *startDate2 = [calendar2 dateFromComponents:comps2];
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"startDate >= %@ AND startDate <= %@",startDate1,startDate2];
    
    [request setPredicate:predicate];
    NSError *error=nil;
    NSArray *listData=[cxt executeFetchRequest:request error:&error];
    if ([listData count]>0) {
        NSMutableArray *dataList=[[NSMutableArray alloc]initWithCapacity:0];
        for ( ResultDataManagedObject *mo in listData) {
            ResultData *data=[[ResultData alloc]init];
            data.startDate=mo.startDate;
            data.totalTime=mo.totalTime;
            data.totalCount=mo.totalCount;
            data.totalHeat=mo.totalHeat;
            data.averageIn=mo.averageIn;
            data.maxIn=mo.maxIn;
            data.averageHz=mo.averageHz;
            data.maxHz=mo.maxHz;
            [dataList addObject:data];
        }
        return dataList;
    }
    return nil;
    
}
-(int) remove:(ResultData *)model
{
    NSManagedObjectContext *cxt=[self managedObjectContext];
    
    NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"ResultData" inManagedObjectContext:cxt];
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"startDate = %@",model.startDate];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData=[cxt executeFetchRequest:request error:&error];
    if ([listData count]>0) {
        ResultDataManagedObject *data= [listData lastObject];
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

-(int) removeDataWithDay:(ResultData *)model
{
    NSManagedObjectContext *cxt=[self managedObjectContext];
    
    NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"ResultData" inManagedObjectContext:cxt];
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"startDate = %@",model.startDate];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData=[cxt executeFetchRequest:request error:&error];
    if ([listData count]>0) {
        ResultDataManagedObject *data= [listData lastObject];
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

-(int)removeAllResultData
{
    NSManagedObjectContext *cxt=[self managedObjectContext];
    
    NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"ResultData" inManagedObjectContext:cxt];
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    
//    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"count = %@",model.startDate];
//    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData=[cxt executeFetchRequest:request error:&error];
    if ([listData count]>0) {
        for (ResultDataManagedObject *data in listData)
        {
            [self.managedObjectContext deleteObject:data];
        }
        NSError *saveError = nil;
        if ([self.managedObjectContext save:&saveError]) {
            NSLog(@"删除所有ResultDat数据成功");
        }
        else {
            NSLog(@"删除所有ResultDat数据失败");
            return -1;
        }
    }
    return 0;
}

@end
