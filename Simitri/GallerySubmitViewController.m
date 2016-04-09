//
//  GallerySubmitViewController.m
//  Simitri
//
//  Created by John on 11/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "GallerySubmitViewController.h"
#import "SubmitMenuController.h"
#import "SubmitPageController.h"
#import "LayoutConsts.h"
#import "GalleryService.h"
#import "ToastUtils.h"
#import "GeoService.h"

@interface GallerySubmitViewController ()

@property SubmitMenuController* tabController;
@property SubmitPageController* submitPageController;
@property UIView* tabContainer;
@property UIView* submitContainer;

@end

@implementation GallerySubmitViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupAll];
}

- (void) setupAll{
	self.title = @"Submit to the gallery";
	[self addAll];
	[self layoutAll];
	[self addChildInto: self.tabContainer withController:self.tabController];
	[self addChildInto: self.submitContainer withController:self.submitPageController];
}

- (void)backClicked{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[self enableAll];
}

- (void) enableAll{
	[self.submitPageController enableAll];
	[self.tabController enableButtonAtIndex:0 enabled:YES];
	[self.tabController enableButtonAtIndex:1 enabled:NO];
}

- (void) disableAll{
	[self.submitPageController disableAll];
	[self.tabController enableButtonAtIndex:0 enabled:YES];
	[self.tabController enableButtonAtIndex:1 enabled:NO];
}

- (void)yesClicked{
	NSDictionary* dic = [self.submitPageController getData];
	NSString* country = [dic valueForKey:@"country"];
	if(country == [GeoService getAllCountryNames][0]){
		[self.submitPageController warn];
	}
	else{
		[[GalleryService sharedInstance] submitData:dic withCallback:^(GalleryResults result) {
			NSString* message;
			TSMessageNotificationType type = TSMessageNotificationTypeError;
			if(result == GalleryResultOk){
				message = [ToastUtils getGallerySubmitSuccessMessage];
				type = TSMessageNotificationTypeSuccess;
				[self disableAll];
			}
			else if(result == GalleryResultUnreachable){
				message = [ToastUtils getGallerySubmitNoInternetMessage];
			}
			else{
				message = [ToastUtils getGallerySubmitErrorMessage];
			}
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
				[ToastUtils showToastInController:self withMessage:message withType:type];
			});
		}];
	}
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (void) addAll{
	[self addSubmit];
	[self addTab];
}

- (void) layoutAll{
	[self layoutSubmit];
	[self layoutTab];
}

- (void) layoutSubmit{
	self.submitContainer.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.submitContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.submitContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.submitContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.submitContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-LAYOUT_TAB_HEIGHT];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutTab{
	self.tabContainer.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.tabContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-LAYOUT_TAB_HEIGHT];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.tabContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.tabContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.tabContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_TAB_HEIGHT];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) addTab{
	self.tabContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
	self.tabController = [[SubmitMenuController alloc] init];
	[self.view addSubview:self.tabContainer];
}

- (void) addSubmit{
	self.submitContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
	self.submitContainer.frame = CGRectIntegral(self.view.frame);
	self.submitContainer.backgroundColor = [UIColor clearColor];
	self.submitPageController = [[SubmitPageController alloc] init];
	[self.view addSubview:self.submitContainer];
}

- (void) dealloc{
	[self removeChildFrom: self.tabContainer withController:self.tabController];
	[self removeChildFrom: self.submitContainer withController:self.submitPageController];
	[self.tabContainer removeFromSuperview];
	self.tabContainer = nil;
	[self.submitContainer removeFromSuperview];
	self.submitContainer = nil;
}

@end

