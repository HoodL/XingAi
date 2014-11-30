//
//  RegisterViewController.h
//  XingAi02
//
//  Created by Lihui on 14/11/11.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//
#import <UIKit/UIKit.h>
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@interface RegisterViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *accountField;
@property (strong, nonatomic) IBOutlet UITextField *pwdField;
@property (strong, nonatomic) IBOutlet UITextField *confirmPwdField;
@property (strong, nonatomic) IBOutlet UIButton *agreeNegotiate;
@property (strong, nonatomic) IBOutlet UIButton *provisionButton;
- (IBAction)clickAgreeButton:(id)sender;
- (IBAction)clickProvisionButton:(id)sender;
- (IBAction)clickLoginButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@end
