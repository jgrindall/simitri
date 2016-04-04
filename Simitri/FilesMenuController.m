//
//  FilesMenuControllerViewController.m
//  Symmetry
//
//  Created by John on 20/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "FilesMenuController.h"
#import "DisplayUtils.h"
#import "SymmNotifications.h"
#import "Appearance.h"
#import "MyFilesScreenController.h"
#import "SoundManager.h"
#import "LayoutConsts.h"
#import "AnimationUtils.h"

@interface FilesMenuController ()

@property UIButton* startButton;

@end

@implementation FilesMenuController

- (void) addItems{
	CGSize size = CGSizeMake(LAYOUT_DEFAULT_BUTTON_HEIGHT, LAYOUT_DEFAULT_BUTTON_HEIGHT);
	self.startButton = [Appearance flatButtonWithLabel:@"" withIcon:@"plus.png" withTheme:FlatButtonThemePositive withSize:size];
	[self.view addSubview:self.startButton];
}

- (void)viewDidLoad{
    [super viewDidLoad];
	[self addItems];
	[self layoutItems];
	[self.startButton addTarget:self action:@selector(startClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (void) layoutItems{
	[self layoutStart];
}

- (void) layoutStart{
	self.startButton.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.startButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:3];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.startButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-8];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.startButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_DEFAULT_BUTTON_HEIGHT];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.startButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_DEFAULT_BUTTON_HEIGHT];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void)startClicked {
	[[SoundManager sharedInstance] playClick];
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_START_NEW_FILE object:nil];
}

- (void) dealloc{
	[self.startButton removeTarget:self action:@selector(startClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.startButton removeFromSuperview];
	self.startButton = nil;
}

@end
