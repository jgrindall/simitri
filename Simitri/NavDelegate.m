//
//  NavDelegate.m
//  Simitri
//
//  Created by John on 17/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "NavDelegate.h"
#import "TransitionAnimator.h"
#import <UIKit/UIKit.h>

@implementation NavDelegate

- (void) navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
	
}

- (void) navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
	
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
	return [[TransitionAnimator alloc] init];
}

@end
