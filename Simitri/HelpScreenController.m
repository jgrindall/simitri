//
//  HelpScreenController.m
//  Symmetry
//
//  Created by John on 29/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "HelpScreenController.h"
#import "HelpViewController.h"
#import "HelpPageViewController.h"
#import "HelpDataProvider.h"
#import "ImageUtils.h"
#import "SymmNotifications.h"
#import "Colors.h"
#import "UIColor+Utils.h"
#import "RoundRectBg.h"
#import "Appearance.h"

@interface HelpScreenController ()

@property HelpViewController* help;
@property UIButton* closeButton;
@property UIView* container;
@property UIView* bg;
@property UILabel* header;
@end

@implementation HelpScreenController


- (void)viewDidLoad{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor getGray:0.7 withAlpha:0.7];
	[self addBg];
	[self addButton];
	[self addLabel];
	[self addHelp];
	[self layoutButton];
	[self layoutHelp];
	[self layoutBg];
	[self layoutLabel];
	[self addChildInto:self.container withController:self.help];
}

-  (void) addButton{
	UIImage* iconImg = [ImageUtils iconWithName:@"multiply 2.png" andSize:CGSizeMake(30,30)];
	self.closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
	self.closeButton.tintColor = [Colors symmGrayButtonColor];
	[self.closeButton setTitle:@" " forState:UIControlStateNormal];
	[self.closeButton setImage:iconImg forState:UIControlStateNormal];
	[self.closeButton addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.closeButton];
}

- (void) clickClose{
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_CLOSE_HELP object:nil];
}

- (void) addLabel{
	self.header = [Appearance labelWithFontSize:SYMM_FONT_SIZE_NAV];
	NSAttributedString* s = [[NSAttributedString alloc] initWithString:@"Help / About" attributes:[Appearance navTextAttributes]];
	[self.header setAttributedText:s];
	self.header.textAlignment = NSTextAlignmentCenter;
	[self.view addSubview:self.header];
}

- (void) addBg{
	self.bg = [[RoundRectBg alloc] initWithColor:[Colors symmGrayBgColor]];
	[self.view addSubview:self.bg];
}

-  (void) addHelp{
	self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
	self.help = [[HelpViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil withDataProvider:[[HelpDataProvider alloc] initWithPageClass:[HelpPageViewController class]]];
	[self.view addSubview:self.container];
}

- (void) layoutBg{
	float f = 0.05;
	self.bg.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.bg attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:f constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.bg attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:f constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.bg attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:(1-2*f) constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.bg attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:(1-2*f) constant:0];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutHelp{
	self.container.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.bg attribute:NSLayoutAttributeTop multiplier:1 constant:40];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.bg attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.bg attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bg attribute:NSLayoutAttributeBottom multiplier:1 constant:-10];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutLabel{
	self.header.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.header attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.bg attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.header attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.bg attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.header attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.bg attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.header attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:40];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutButton{
	self.closeButton.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.closeButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.bg attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.closeButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.bg attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.closeButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:40];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.closeButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:40];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) cleanUpView{
	[self removeChildFrom:self.container withController:self.help];
	[self.container removeFromSuperview];
	self.container = nil;
	self.help = nil;
	[self.closeButton removeFromSuperview];
	[self.closeButton removeTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
	self.closeButton = nil;
	[self.bg removeFromSuperview];
	self.bg = nil;
	[self.header removeFromSuperview];
	self.header = nil;
	[self.view removeFromSuperview];
	self.view = nil;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
	if(self.view && !self.view.window){
		[self cleanUpView];
	}
}

- (void) dealloc{
	[self cleanUpView];
}

@end


