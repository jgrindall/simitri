//
//  NavController.m
//  Simitri
//
//  Created by John on 12/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "NavController.h"
#import "SymmNotifications.h"
#import "TransitionDelegate.h"
#import "NavDelegate.h"
#import "SpinnerView.h"

@interface NavController ()

typedef enum  {
	SpinnerStatusNone = 0,
	SpinnerStatusShown,
	SpinnerStatusShowing,
	SpinnerStatusHiding
} SpinnerStatus;

typedef enum{
	ShowSpinner = 0,
	HideSpinner
} SpinnerCommand;

@property id<UIViewControllerTransitioningDelegate> transDelegate;
@property id<UINavigationControllerDelegate> navDelegate;
@property SpinnerStatus spinnerShown;
@property NSMutableArray* commands;
@property UIView* spinnerView;
@property NSArray* spinnerConstraints;

@end

@implementation NavController

- (id) initWithRootViewController:(UIViewController *)rootViewController{
	self = [super initWithRootViewController:rootViewController];
	if(self){
		self.spinnerShown = SpinnerStatusNone;
		self.navDelegate = [[NavDelegate alloc] init];
		self.delegate = self.navDelegate;
		self.commands = [NSMutableArray array];
	}
	return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSpinner) name:SYMM_NOTIF_SHOW_SPINNER object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideSpinner) name:SYMM_NOTIF_HIDE_SPINNER object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alert:) name:SYMM_NOTIF_ALERT object:nil];
}

- (void) alert:(NSNotification*) notification{
	NSString* val = (NSString*)[((NSDictionary*)notification.userInfo) valueForKey:@"message"];
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"No!" message:val delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
	[alertView show];
}

- (void) nextCommand{
	if(self.spinnerShown == SpinnerStatusHiding || self.spinnerShown == SpinnerStatusShowing){
		return;
	}
	else if(self.commands.count == 0){
		return;
	}
	else {
		NSInteger top = self.commands.count - 1;
		SpinnerCommand c = [[self.commands objectAtIndex:top] intValue];
		if(c == ShowSpinner && self.spinnerShown == SpinnerStatusNone){
			self.spinnerShown = SpinnerStatusShowing;
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
				[self performShowSpinner];
			});
		}
		else if(c == HideSpinner && self.spinnerShown == SpinnerStatusShown){
			self.spinnerShown = SpinnerStatusHiding;
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
				[self performHideSpinner];
			});
		}
	}
}

- (void) performShowSpinner{
	self.spinnerView = [[SpinnerView alloc] initWithFrame:self.view.frame];
	[self.view addSubview:self.spinnerView];
	[self layoutSpinner];
	self.spinnerShown = SpinnerStatusShown;
	[self.commands removeObjectAtIndex:self.commands.count - 1];
	[self nextCommand];
}

- (void) layoutSpinner{
	self.spinnerView.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.spinnerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.spinnerView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.spinnerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.spinnerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	self.spinnerConstraints = @[c1, c2, c3, c4];
	[self.view addConstraints:self.spinnerConstraints];
}

- (void) performHideSpinner{
	[self.view removeConstraints:self.spinnerConstraints];
	[self.spinnerView removeFromSuperview];
	self.spinnerView = nil;
	self.spinnerShown = SpinnerStatusNone;
	[self.commands removeObjectAtIndex:self.commands.count - 1];
	[self nextCommand];
}

- (void) showSpinner{
	[self.commands insertObject:[NSNumber numberWithInteger:ShowSpinner] atIndex:0];
	[self nextCommand];
}

- (void) hideSpinner{
	[self.commands insertObject:[NSNumber numberWithInteger:HideSpinner] atIndex:0];
	[self nextCommand];
}

- (void) dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_SHOW_SPINNER object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_HIDE_SPINNER object:nil];
}


@end

