//
//  UIViewController+MLTransition.h
//  MLTransitionNavigationController
//
//  Created by molon on 6/28/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <UIKit/UIKit.h>

typedef enum {
    MLTransitionGestureRecognizerTypePan, //拖动模式
	MLTransitionGestureRecognizerTypeScreenEdgePan, //边界拖动模式
} MLTransitionGestureRecognizerType;

@interface UIViewController (MLTransition)<UINavigationControllerDelegate>

+ (void)validatePanPackWithMLTransitionGestureRecognizerType:(MLTransitionGestureRecognizerType)type;

@end
