//
//  DataGroupArray.m
//  XingAi02
//
//  Created by Lihui on 14/11/27.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//

#import "DataGroup.h"
#import "SportsData.h"
@implementation DataGroup

//+(DataGroup*)initWithDataList:(NSMutableArray*)list
//{
//    
////    DataGroupArray *dataGroup=[[DataGroupArray alloc]init];
////    dataGroup.dataList=list;
//    return NULL;
//}

//-(id)init
//{
//    if (self=[super init]) {
//        self.group=0;
//    }
//    return self;
//}

-(DataGroup*)initWithDataList:(NSMutableArray*)list
{
    DataGroup* dataGroup=[[DataGroup alloc]init];
    
    NSInteger group=0;//代表有多少个组
    //一个数组代表1所处的index
    NSMutableArray *indexList=[[NSMutableArray alloc]initWithCapacity:0];
//    NSNumber *zeroNum=[NSNumber numberWithInteger:0];
//    [indexList addObject:zeroNum];
    NSLog(@"[list count]=%lu",(unsigned long)[list count]);
    for(NSInteger i=0;i<[list count];i++)
    {
        SportsData *data= [list objectAtIndex:i];
       // NSLog(@"data.count(%ld)=%ld",(long)i,(long)[data.count integerValue]);

        if([data.count integerValue]==1)
        {
            //NSLog(@"遇到1");
            group++;
            [indexList addObject:[NSNumber numberWithInteger:i]];
        }
    }
    
    dataGroup.group=group;//总共有多少组
    dataGroup.indexList=indexList;
    dataGroup.dataList=list;
    return dataGroup;
}

@end
