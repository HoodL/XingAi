//
//  LoginViewController.m
//  XingAi02
//
//  Created by Lihui on 14/11/10.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController

//-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    if (self) {
//    }
//    return self;
//}

-(void)awakeFromNib {
    
}
-(id)initWithCoder:(NSCoder *)aDecoder {
    if(self =[super init]){
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.accountField.delegate=self;
    self.accountField.textColor=[UIColor whiteColor];
    self.pwdField.delegate=self;
    self.pwdField.textColor=[UIColor whiteColor];

    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"登录注册按钮-点击"] forState: UIControlStateHighlighted];
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

- (IBAction)clickLoginButton:(id)sender {
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请输入账号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];

}

- (IBAction)clickForgetPwd:(id)sender {
}

- (IBAction)clickRegisterButton:(id)sender {
    RegisterViewController *vc=[[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)clickReturnButton {
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
