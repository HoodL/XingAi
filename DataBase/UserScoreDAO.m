//
//  UserScoreDAO.m
//  XingAi02
//
//  Created by Lihui on 14/11/26.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//

#import "UserScoreDAO.h"

@implementation UserScoreDAO

static UserScoreDAO *shareManager;
+(UserScoreDAO*)shareManager {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shareManager=[[self alloc]init];
        shareManager.listData=[[NSMutableArray alloc]init];
    });
    return shareManager;
}

-(int)create:(UserScore*)model
{
    NSManagedObjectContext *cxt=[self managedObjectContext];
    
    UserScoreManageObject *data=[NSEntityDescription insertNewObjectForEntityForName:@"UserScore" inManagedObjectContext:cxt];
    [data setValue:model.score forKey:@"score"];
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
    NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"UserScore" inManagedObjectContext:cxt];
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    //制定排序字段和排序方式
    NSSortDescriptor *sortDescriptor=[[NSSortDescriptor alloc]initWithKey:@"date" ascending:YES];
    
    [request setSortDescriptors:@[sortDescriptor]];
    NSError *error=nil;
    NSArray *listData=[cxt executeFetchRequest:request error:&error];
    
    NSMutableArray *resListData=[[NSMutableArray alloc]init];
    
    for (UserScoreManageObject *mo in listData) {
        UserScore *data=[[UserScore alloc]init];
        data.score=mo.score;
        [resListData addObject:data];
    }
    return resListData;
}
//按条件查询
-(UserScore*)findById:(UserScore*)model
{
    NSManagedObjectContext *cxt=[self managedObjectContext];
    NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"UserScore" inManagedObjectContext:cxt];
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"date = %@",model.score];
    [request setPredicate:predicate];
    NSError *error=nil;
    NSArray *listData=[cxt executeFetchRequest:request error:&error];
    if ([listData count]>0) {
        UserScoreManageObject *mo=[listData lastObject];
        UserScore *data=[[UserScore alloc]init];
        data.score=mo.score;
        data.date=mo.date;
        return data;
    }
    return nil;
}

-(int) remove:(UserScore *)model
{
    NSManagedObjectContext *cxt=[self managedObjectContext];
    
    NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"UserScore" inManagedObjectContext:cxt];
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"score = %@",model.score];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData=[cxt executeFetchRequest:request error:&error];
    if ([listData count]>0) {
        UserScoreManageObject *data= [listData lastObject];
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

@end
