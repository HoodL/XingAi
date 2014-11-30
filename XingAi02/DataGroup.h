//
//  DataGroupArray.h
//  XingAi02
//
//  Created by Lihui on 14/11/27.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//
//数据分组器皿
#import <Foundation/Foundation.h>

@interface DataGroup : NSObject
@property(nonatomic,assign)NSInteger group;
@property(nonatomic,retain)NSMutableArray *indexList;
@property(nonatomic,retain)NSMutableArray *dataList;
//-(DataGroup*)getDataGroupAndIndex:(NSArray*)list;
-(DataGroup*)initWithDataList:(NSArray*)list;

@end
