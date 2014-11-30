//
//  CurveViewController.h
//  RealTimeCurve
//
//  Created by wu xiaoming on 13-1-24.
//  Copyright (c) 2013年 wu xiaoming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurveViewController : UIViewController<UIWebViewDelegate,UITextFieldDelegate>
@property(retain,nonatomic)UIButton* closeBtn;
@property(retain,nonatomic)UIWebView* webViewForSelectDate;
@property(retain,nonatomic)NSTimer* timer;
@end
