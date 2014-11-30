//
//  MLTransitionAnimation.h
//  MLTransitionNavigationController
//
//  Created by molon on 6/29/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>

typedef enum {
    MLTransitionAnimationTypePush, //push
	MLTransitionAnimationTypePop, //pop
} MLTransitionAnimationType;

@interface MLTransitionAnimation : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) MLTransitionAnimationType type;

@end
