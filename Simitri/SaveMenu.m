//
//  TilePopupMenu.m
//  Symmetry
//
//  Created by John on 09/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "SaveMenu.h"
#import "SymmNotifications.h"
#import "Appearance.h"
#import "LayoutConsts.h"
#import "DisplayUtils.h"
#import "TilePopupViewController.h"
#import "SaveCurrentViewController.h"
#import "SoundManager.h"

@interface SaveMenu()

@property UIButton* yesButton;
@property UIButton* noButton;

@end

@implementation SaveMenu

- (id)init{
    self = [super init];
    if (self) {
        [self addButtons];
		[self layoutYes];
		[self layoutNo];
    }
    return self;
}

- (void) addButtons{
	self.yesButton = [Appearance flatButtonWithLabel:@"Yes please" withIcon:@"floppy disk.png" withTheme:FlatButtonThemePositive withSize:CGSizeMake(LAYOUT_DEFAULT_BUTTON_WIDTH, LAYOUT_DEFAULT_BUTTON_HEIGHT)];
	self.noButton = [Appearance flatButtonWithLabel:@"No thanks" withIcon:@"multiply 2.png" withTheme:FlatButtonThemeDanger withSize:CGSizeMake(LAYOUT_LONG_BUTTON_WIDTH, LAYOUT_DEFAULT_BUTTON_HEIGHT)];
	[self addSubview:self.yesButton];
	[self addSubview:self.noButton];
	[self.yesButton addTarget:self action:@selector(yesClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.noButton addTarget:self action:@selector(noClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)yesClicked {
	[[SoundManager sharedInstance] playClick];
	[DisplayUtils bubbleActionFrom:self toProtocol:@protocol(PYesNoMenuResponder) withSelector:@"yesClicked" withObject:self];
}

- (void)noClicked {
	[[SoundManager sharedInstance] playClick];
	[DisplayUtils bubbleActionFrom:self toProtocol:@protocol(PYesNoMenuResponder) withSelector:@"noClicked" withObject:self];
}

- (void) layoutYes{
	self.yesButton.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.yesButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.yesButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.yesButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_DEFAULT_BUTTON_WIDTH];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.yesButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_DEFAULT_BUTTON_HEIGHT];
	[self addConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutNo{
	self.noButton.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.noButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.noButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.noButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_LONG_BUTTON_WIDTH];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.noButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_DEFAULT_BUTTON_HEIGHT];
	[self addConstraints:@[c1, c2, c3, c4]];
}

- (void) dealloc{
	[self.yesButton removeTarget:self action:@selector(yesClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.noButton removeTarget:self action:@selector(noClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.yesButton removeFromSuperview];
	[self.noButton removeFromSuperview];
	self.yesButton = nil;
	self.noButton = nil;
}


@end



