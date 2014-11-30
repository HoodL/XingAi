//
//  HistoryDataVC.h
//  XingAi02
//
//  Created by Lihui on 14/11/13.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SportsData.h"
@interface HistoryDataVC : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *cancelViewButton;

@property (strong,nonatomic) SportsData *data;

- (IBAction)clickCancelViewButton:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *dataCount;
@property (strong, nonatomic) IBOutlet UILabel *dataTime;
@property (strong, nonatomic) IBOutlet UILabel *dataIn;
@property (strong, nonatomic) IBOutlet UILabel *dataHeat;
@property (strong, nonatomic) IBOutlet UILabel *dataHz;
@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;
@property (strong, nonatomic) IBOutlet UIButton *returnButton;
- (IBAction)clickRrtun:(id)sender;

@end
