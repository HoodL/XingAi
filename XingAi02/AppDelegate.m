//
//  AppDelegate.m
//  XingAi02
//
//  Created by Lihui on 14/11/10.
//  Copyright (c) 2014年 Lihui. All rights reserved.
//

#import "AppDelegate.h"
#import "SliderViewController.h"
#import "LeftViewController.h"
#import "UIViewController+MLTransition.h"
#import "MainTabViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    LeftViewController *leftVC = [[LeftViewController alloc] init];
    [SliderViewController sharedSliderController].LeftVC = leftVC;
    [SliderViewController sharedSliderController].MainVC = [[MainTabViewController alloc] initWithNibName:@"MainTabViewController" bundle:nil];
    
    [SliderViewController sharedSliderController].LeftSContentOffset=234;
    [SliderViewController sharedSliderController].LeftContentViewSContentOffset = 90;
    [SliderViewController sharedSliderController].LeftSContentScale=0.77;
    [SliderViewController sharedSliderController].LeftSJudgeOffset=160;
    [SliderViewController sharedSliderController].changeLeftView = ^(CGFloat sca, CGFloat transX)
    {
        //        leftVC.contentView.layer.anchorPoint = CGPointMake(1, 1);
        CGAffineTransform ltransS = CGAffineTransformMakeScale(sca, sca);//缩放
        CGAffineTransform ltransT = CGAffineTransformMakeTranslation(transX, 0);//平移变换
        //使用CGAffineTransformConcact函数组合两个变换效果
        //同时进行平移和缩放
        CGAffineTransform lconT = CGAffineTransformConcat(ltransT, ltransS);//使用CGAffineTransformConcact函数组合两个变换效果
        leftVC.contentView.transform = lconT;
    };
    
    [UIViewController validatePanPackWithMLTransitionGestureRecognizerType:MLTransitionGestureRecognizerTypePan];
    
    UINavigationController *naviC = [[UINavigationController alloc] initWithRootViewController:[SliderViewController sharedSliderController]];
    
    self.window.rootViewController = naviC;
//    [naviC.navigationController pushViewController: [[MainTabViewController alloc] initWithNibName:@"MainTabViewController" bundle:nil]animated:YES];
//    [naviC addChildViewController:[SliderViewController sharedSliderController].MainVC];
    [self.window makeKeyAndVisible];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"%@,%@,%@,%@",keyPath,object,change,context);
}

@end
