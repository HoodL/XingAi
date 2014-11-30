//
//  calendarViewController.h
//  xingai01
//
//  Created by Lihui on 14-10-21.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface calendarViewController : UIViewController<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *returnButton;
- (IBAction)clickReturn:(id)sender;

@end
