//
//  Animator.m
//  NavigationTransitionTest
//
//  Created by Chris Eidhof on 9/27/13.
//  Copyright (c) 2013 Chris Eidhof. All rights reserved.
//

#import "TransitionAnimator.h"
#import "SKBounceAnimation.h"
#import "AnimationUtils.h"
#import "ExampleViewController.h"
#import "HelpScreenController.h"

@interface TransitionAnimator()

@property id <UIViewControllerContextTransitioning> transitioningContext;

@end

@implementation TransitionAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
	return 0.5;
}

- (BOOL) isPopup:(UIViewController*) to orFrom:(UIViewController*)from{
	BOOL ex = [to isKindOfClass:[ExampleViewController class]] || [from isKindOfClass:[ExampleViewController class]];
	BOOL help = [to isKindOfClass:[HelpScreenController class]] || [from isKindOfClass:[HelpScreenController class]];
	return ex || help;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [[transitionContext containerView] addSubview:toViewController.view];
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
	float w;
	//float h;
	NSString* keyPath;
	UIInterfaceOrientation orient = [UIApplication sharedApplication].statusBarOrientation;
	BOOL isLandScape = UIInterfaceOrientationIsLandscape(orient);
	BOOL isPopup = [self isPopup:toViewController orFrom:fromViewController];
	float duration = 0.3;
	if(isPopup){
		duration = 0.1;
	}
	if(isLandScape && !isPopup){
		w = window.frame.size.height;
		//h = window.frame.size.width;
		keyPath = @"position.x";
	}
	else{
		w = window.frame.size.width;
		//h = window.frame.size.height;
		keyPath = @"position.x";
	}
	self.transitioningContext = transitionContext;
	[AnimationUtils bounceAnimateView:toViewController.view from:3*w/2 to:w/2 withKeyPath:keyPath withKey:@"viewControllerBounce" withDelegate:self withDuration:duration withImmediate:NO];
}

- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
	if(self.transitioningContext){
		[self.transitioningContext completeTransition:![self.transitioningContext transitionWasCancelled]];
		self.transitioningContext = nil;
	}
}

@end
