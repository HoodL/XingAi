//
//  RegisterViewController.m
//  XingAi02
//
//  Created by Lihui on 14/11/11.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//

#import "RegisterViewController.h"
#import "EditUserInfoVC.h"

@interface RegisterViewController ()<UITextFieldDelegate>

@end

@implementation RegisterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.accountField.delegate=self;
    self.accountField.textColor=[UIColor whiteColor];
    self.pwdField.delegate=self;
    self.pwdField.textColor=[UIColor whiteColor];
    self.confirmPwdField.delegate=self;
    self.confirmPwdField.textColor=[UIColor whiteColor];
    
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"登录注册按钮-点击"] forState:UIControlStateHighlighted];
    
    UIImageView *bgImageView=[[UIImageView alloc]initWithFrame:self.view.frame];
    if (iPhone5) {
        bgImageView.image=[UIImage imageNamed:@"功能页面背景"];
        
    }
    else bgImageView.image=[UIImage imageNamed:@"功能页面背景960"];
    [self.view insertSubview:bgImageView atIndex:0];
    UIImageView *logoView=[[UIImageView alloc]initWithFrame:CGRectMake(126, 25, 68, 68)];
    logoView.image=[UIImage imageNamed:@"全局logo"];
    [self.view addSubview:logoView];
    UIButton *returButton=[[UIButton alloc]initWithFrame:CGRectMake(20, 25, 44, 44)];
    [returButton setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [returButton addTarget:self action:@selector(clickReturnButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returButton];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickAgreeButton:(id)sender {
}

- (IBAction)clickProvisionButton:(id)sender {
}

- (IBAction)clickLoginButton:(id)sender {
    
    EditUserInfoVC *vc=[[EditUserInfoVC alloc]initWithNibName:@"EditUserInfoVC" bundle:nil];
    //[self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)clickReturnButton {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
