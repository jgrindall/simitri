//
//  AlbumButtonsView.m
//  Symmetry
//
//  Created by John on 09/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "AlbumButtonsView.h"
#import "LayoutConsts.h"
#import "SymmNotifications.h"
#import "Appearance.h"
#import "LayoutConsts.h"
#import "RoundRectBg.h"
#import "DisplayUtils.h"
#import "AlbumScreenViewController.h"
#import "SoundManager.h"

@interface AlbumButtonsView()

@property UIButton* delButton;
@property UIButton* openButton;
@property UIButton* startNewButton;
@property UIView* bg;
@end

@implementation AlbumButtonsView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor clearColor];
        [self addBg];
		[self addButtons];
		[self layoutDel];
		[self layoutOpen];
		[self layoutNew];
		[self layoutBg];
    }
    return self;
}

- (void) addButtons{
	CGSize size = CGSizeMake(LAYOUT_DEFAULT_BUTTON_WIDTH, LAYOUT_DEFAULT_BUTTON_HEIGHT);
	self.delButton = [Appearance flatButtonWithLabel:@"Delete this file" withIcon:@"dustbin.png" withTheme:FlatButtonThemeDanger withSize:size];
	self.openButton = [Appearance flatButtonWithLabel:@"Open this file" withIcon:@"right 3.png" withTheme:FlatButtonThemePositive withSize:size];
	self.startNewButton = [Appearance flatButtonWithLabel:@"Start a new file" withIcon:@"plus.png" withTheme:FlatButtonThemePositive withSize:size];
	[self addSubview:self.delButton];
	[self addSubview:self.openButton];
	[self addSubview:self.startNewButton];
	[self.delButton addTarget:self action:@selector(delClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.openButton addTarget:self action:@selector(openClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.startNewButton addTarget:self action:@selector(newClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void) addBg{
	self.bg = [[RoundRectBg alloc] initWithColor:[UIColor whiteColor]];
	[self addSubview:self.bg];
}

- (void)newClicked {
	[[SoundManager sharedInstance] playClick];
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_START_NEW_FILE object:nil];
}

- (void)delClicked {
	[[SoundManager sharedInstance] playClick];
	[DisplayUtils bubbleActionFrom:self toClass:[AlbumScreenViewController class] withSelector:@"delClicked" withObject:self];
}

- (void)openClicked {
	[[SoundManager sharedInstance] playClick];
	[DisplayUtils bubbleActionFrom:self toClass:[AlbumScreenViewController class] withSelector:@"openClicked" withObject:self];
}

- (void) layoutBg{
	self.bg.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.bg attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.bg attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.bg attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.bg attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	[self addConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutDel{
	self.delButton.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.delButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:4];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.delButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.delButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_LONG_BUTTON_WIDTH];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.delButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_DEFAULT_BUTTON_HEIGHT];
	[self addConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutOpen{
	self.openButton.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.openButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.openButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.openButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_LONG_BUTTON_WIDTH];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.openButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_DEFAULT_BUTTON_HEIGHT];
	[self addConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutNew{
	self.startNewButton.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.startNewButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-4];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.startNewButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.startNewButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_LONG_BUTTON_WIDTH];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.startNewButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_DEFAULT_BUTTON_HEIGHT];
	[self addConstraints:@[c1, c2, c3, c4]];
}

- (void) dealloc{
	[self.delButton removeTarget:self action:@selector(delClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.openButton removeTarget:self action:@selector(openClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.startNewButton removeTarget:self action:@selector(newClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.delButton removeFromSuperview];
	[self.openButton removeFromSuperview];
	[self.startNewButton removeFromSuperview];
	self.delButton = nil;
	self.openButton = nil;
	self.startNewButton = nil;
	[self.bg removeFromSuperview];
	self.bg = nil;
}

@end
