//
//  ToolbarTabViewController.m
//  Symmetry
//
//  Created by John on 09/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ToolbarTabViewController.h"
#import "ToolbarController.h"
#import "LayoutConsts.h"

@interface ToolbarTabViewController ()

@property NSArray* buttons;
@property NSArray* icons;
@property ToolbarController* toolbarController;
@property UIView* toolbarContainer;

@end

@implementation ToolbarTabViewController

- (id) initWithButtons:(NSArray*)buttons withIcons:(NSArray*)icons {
	if(self){
		_buttons = buttons;
		_icons = icons;
	}
	return self;
}

- (void) viewDidLoad{
	[super viewDidLoad];
	[self addToolbar];
	[self layoutToolbar];
	[self addChildInto:self.toolbarContainer withController:self.toolbarController];
}

- (void) buttonChosen:(NSNumber*)n{
	[self showChild:[n integerValue]];
}

- (void) addToolbar{
	self.toolbarController = [[ToolbarController alloc] initWithButtons:self.buttons andIcons:self.icons];
	self.toolbarContainer = [[UIView alloc] init];
	[self.view addSubview: self.toolbarContainer];
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (void) layoutToolbar{
	self.toolbarContainer.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.toolbarContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.toolbarContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.toolbarContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.toolbarContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_TAB_HEIGHT];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutContainer{
	self.container.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-LAYOUT_TAB_HEIGHT];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) showChild:(NSInteger)childIndex {
	[super showChild:childIndex];
	[self.toolbarController highlightButton:childIndex];
}

- (void) dealloc{
	self.buttons = nil;
	self.icons = nil;
	[self removeChildFrom:self.toolbarContainer withController:self.toolbarController];
	[self. toolbarContainer removeFromSuperview];
	self.toolbarContainer = nil;
	self.toolbarController = nil;
}

@end
