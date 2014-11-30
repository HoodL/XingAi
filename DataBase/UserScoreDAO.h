//
//  UserScoreDAO.h
//  XingAi02
//
//  Created by Lihui on 14/11/26.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//

#import "CoreDataDAO.h"
#import "UserScore.h"
#import "UserScoreManageObject.h"

@interface UserScoreDAO : CoreDataDAO

@property(nonatomic,strong) NSMutableArray *listData;
+(UserScoreDAO*)shareManager;
-(int)create:(UserScore*)model;
-(NSMutableArray*) findAll;
-(int) remove :(UserScore*)model;

@end
