//
//  TransitionDelegate.m
//  Simitri
//
//  Created by John on 17/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "TransitionDelegate.h"
#import "TransitionAnimator.h"

@implementation TransitionDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
	TransitionAnimator *animator = [TransitionAnimator new];
	return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
	TransitionAnimator *animator = [TransitionAnimator new];
	return animator;
}

@end


