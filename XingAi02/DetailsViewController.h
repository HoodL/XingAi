//
//  DetailsViewController.h
//  XingAi02
//
//  Created by Lihui on 14/11/10.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//

#import <UIKit/UIKit.h>
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface DetailsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;
@property (strong, nonatomic) IBOutlet UIButton *returnButton;
@property (strong, nonatomic) IBOutlet UIImageView *logoImageView;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (retain,nonatomic)  UIView *countView;
@property (retain,nonatomic)  UIView *timeView;
@property (retain,nonatomic)  UIView *rangeView;
@property (retain,nonatomic)  UIView *heatView;
@property (retain,nonatomic)  UIView *HzView;

- (IBAction)clickReturnButton:(id)sender;
-(void)scrollToPage:(NSInteger)n ;
@end