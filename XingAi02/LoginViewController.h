//
//  LoginViewController.h
//  XingAi02
//
//  Created by Lihui on 14/11/10.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//
#import <UIKit/UIKit.h>
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetPwd;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
- (IBAction)clickLoginButton:(id)sender;
- (IBAction)clickForgetPwd:(id)sender;
- (IBAction)clickRegisterButton:(id)sender;

@end
