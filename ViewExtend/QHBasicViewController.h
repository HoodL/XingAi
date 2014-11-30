//
//  QHBasicViewController.h
//  helloworld
//
//  Created by chen on 14/6/30.
//  Copyright (c) 2014年 chen. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <UIKit/UIKit.h>
#import "UIView+KGViewExtend.h"

@interface QHBasicViewController : UIViewController

@property (nonatomic, strong) UIImageView *statusBarView;
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, assign, readonly) int nMutiple;
@property (nonatomic, strong) NSArray *arParams;
@property (nonatomic, strong) UIView *rightV;

- (id)initWithFrame:(CGRect)frame param:(NSArray *)arParams;

- (void)createNavWithTitle:(NSString *)szTitle createMenuItem:(UIView *(^)(int nIndex))menuItem;

- (void)reloadImage;

- (void)reloadImage:(NSNotificationCenter *)notif;

- (void)subReloadImage;

- (void)addObserver;

@end
