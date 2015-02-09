//
//  HistoryDataVC.h
//  XingAi02
//
//  Created by Lihui on 14/11/13.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultDataDAO.h"
typedef void(^HISblock) (void);

@interface HistoryDataVC : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *cancelViewButton;

@property (strong,nonatomic) ResultData *data;

- (IBAction)clickCancelViewButton:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *dataCount;
@property (strong, nonatomic) IBOutlet UILabel *dataTime;
@property (strong, nonatomic) IBOutlet UILabel *dataIn;
@property (strong, nonatomic) IBOutlet UILabel *dataHeat;
@property (strong, nonatomic) IBOutlet UILabel *dataHz;
@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;
@property (strong, nonatomic) IBOutlet UIButton *returnButton;
@property(nonatomic,assign)   int flag;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (nonatomic,copy)    HISblock  block;
@property (strong, nonatomic) IBOutlet UILabel *bottomTimeLable;
@property(nonatomic,assign) NSString *bottomTimeLableData;
- (IBAction)clickRrtun:(id)sender;
- (IBAction)clickDeleteButton:(id)sender;

@end
