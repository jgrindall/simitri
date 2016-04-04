//
//  TilePopupMenu.m
//  Symmetry
//
//  Created by John on 09/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "TilePopupMenu.h"
#import "SymmNotifications.h"
#import "Appearance.h"
#import "LayoutConsts.h"
#import "DisplayUtils.h"
#import "TilePopupViewController.h"
#import "SoundManager.h"

@interface TilePopupMenu()

@property UIButton* delButton;
@property UIButton* openButton;

@end

@implementation TilePopupMenu

- (id)init{
    self = [super init];
    if (self) {
        [self addButtons];
		[self layoutDel];
		[self layoutOpen];
    }
    return self;
}

- (void) addButtons{
	self.delButton = [Appearance flatButtonWithLabel:@"Delete" withIcon:@"dustbin.png" withTheme:FlatButtonThemeDanger withSize:CGSizeMake(LAYOUT_DEFAULT_BUTTON_WIDTH, LAYOUT_DEFAULT_BUTTON_HEIGHT)];
	self.openButton = [Appearance flatButtonWithLabel:@"Open this file" withIcon:@"right 3.png" withTheme:FlatButtonThemePositive withSize:CGSizeMake(LAYOUT_LONG_BUTTON_WIDTH, LAYOUT_DEFAULT_BUTTON_HEIGHT)];
	[self addSubview:self.delButton];
	[self addSubview:self.openButton];
	[self.delButton addTarget:self action:@selector(delClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.openButton addTarget:self action:@selector(openClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)delClicked {
	[[SoundManager sharedInstance] playClick];
	[DisplayUtils bubbleActionFrom:self toClass:[TilePopupViewController class] withSelector:@"delClicked" withObject:self];
}

- (void)openClicked {
	[[SoundManager sharedInstance] playClick];
	[DisplayUtils bubbleActionFrom:self toClass:[TilePopupViewController class] withSelector:@"openClicked" withObject:self];
}

- (void) layoutDel{
	self.delButton.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.delButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.delButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.delButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_DEFAULT_BUTTON_WIDTH];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.delButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_DEFAULT_BUTTON_HEIGHT];
	[self addConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutOpen{
	self.openButton.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.openButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.openButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.openButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_LONG_BUTTON_WIDTH];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.openButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_DEFAULT_BUTTON_HEIGHT];
	[self addConstraints:@[c1, c2, c3, c4]];
}

- (void) dealloc{
	[self.delButton removeTarget:self action:@selector(delClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.openButton removeTarget:self action:@selector(openClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.delButton removeFromSuperview];
	[self.openButton removeFromSuperview];
	self.delButton = nil;
	self.openButton = nil;
}


@end



