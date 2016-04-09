//
//  ATabbedViewController.m
//  Symmetry
//
//  Created by John on 08/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ATabbedViewController_Protected.h"
#import "LayoutConsts.h"

@interface ATabbedViewController ()

@end

@implementation ATabbedViewController

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (void)viewDidLoad{
    [super viewDidLoad];
	self.childShown = -1;
	[self addContainer];
	[self layoutContainer];
}

- (NSInteger) getSelectedIndex{
	return -1;
}

- (void) addContainer{
	self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
	[self.view addSubview:self.container];
}

- (void) layoutContainer{
	self.container.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (UIViewController*) getChildControllerAt:(NSInteger)i{
	return nil;
}

- (NSInteger) numChildren{
	return 0;
}

- (void) onViewAdded{
	
}

- (void) showChild:(NSInteger)childIndex {
	if(self.childShown == childIndex){
		return;
	}
	if(self.currentChildController){
		[self removeChildFrom:self.container withController:self.currentChildController];
		self.currentChildController.view = nil;
		self.currentChildController = nil;
	}
	if(childIndex >= 0 && childIndex < [self numChildren]){
		self.currentChildController = [self getChildControllerAt:childIndex];
		[self addChildInto:self.container withController:self.currentChildController];
		self.childShown = childIndex;
		[self onViewAdded];
	}
}

- (void) dealloc{
	[self showChild:-1];
	[self.container removeFromSuperview];
	self.container = nil;
	self.currentChildController = nil;
}

@end
