//
//  TilePopupMenu.m
//  Symmetry
//
//  Created by John on 09/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ShareMenu.h"
#import "SymmNotifications.h"
#import "Appearance.h"
#import "LayoutConsts.h"
#import "DisplayUtils.h"
#import "TilePopupViewController.h"
#import "SaveCurrentViewController.h"
#import "ShareViewController.h"
#import "SoundManager.h"

@interface ShareMenu()

@property UIButton* fbButton;
@property UIButton* twitterButton;
@property UIButton* galleryButton;
@property UIButton* cameraButton;

@end

@implementation ShareMenu

- (id)init{
    self = [super init];
    if (self) {
        [self addButtons];
		[self layoutFb];
		[self layoutGallery];
		[self layoutCamera];
		[self layoutTwitter];
    }
    return self;
}

- (void) addButtons{
	self.fbButton = [Appearance flatButtonWithLabel:@"Share on Facebook" withIcon:@"facebook.png" withTheme:FlatButtonThemeDefault withSize:CGSizeMake(LAYOUT_LONG_BUTTON_WIDTH, LAYOUT_DEFAULT_BUTTON_HEIGHT)];
	self.galleryButton = [Appearance flatButtonWithLabel:@"Submit to the gallery" withIcon:@"pic.png" withTheme:FlatButtonThemeDefault withSize:CGSizeMake(LAYOUT_LONG_BUTTON_WIDTH, LAYOUT_DEFAULT_BUTTON_HEIGHT)];
	self.cameraButton = [Appearance flatButtonWithLabel:@"Save to camera roll" withIcon:@"camera.png" withTheme:FlatButtonThemeDefault withSize:CGSizeMake(LAYOUT_LONG_BUTTON_WIDTH, LAYOUT_DEFAULT_BUTTON_HEIGHT)];
	self.twitterButton = [Appearance flatButtonWithLabel:@"Share on Twitter" withIcon:@"twitter.png" withTheme:FlatButtonThemeDefault withSize:CGSizeMake(LAYOUT_LONG_BUTTON_WIDTH, LAYOUT_DEFAULT_BUTTON_HEIGHT)];
	
	[self addSubview:self.fbButton];
	[self addSubview:self.galleryButton];
	[self addSubview:self.cameraButton];
	[self addSubview:self.twitterButton];
	
	[self.fbButton addTarget:self action:@selector(fbClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.cameraButton addTarget:self action:@selector(cameraClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.galleryButton addTarget:self action:@selector(galleryClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.twitterButton addTarget:self action:@selector(twitterClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)fbClicked {
	[[SoundManager sharedInstance] playClick];
	[DisplayUtils bubbleActionFrom:self toClass:[ShareViewController class] withSelector:@"fbClicked" withObject:self];
}

- (void)twitterClicked {
	[[SoundManager sharedInstance] playClick];
	[DisplayUtils bubbleActionFrom:self toClass:[ShareViewController class] withSelector:@"twitterClicked" withObject:self];
}

- (void)cameraClicked {
	[[SoundManager sharedInstance] playClick];
	[DisplayUtils bubbleActionFrom:self toClass:[ShareViewController class] withSelector:@"cameraClicked" withObject:self];
}

- (void)galleryClicked {
	[[SoundManager sharedInstance] playClick];
	[DisplayUtils bubbleActionFrom:self toClass:[ShareViewController class] withSelector:@"galleryClicked" withObject:self];
}

- (void) layoutFb{
	self.fbButton.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.fbButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.fbButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:34];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.fbButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_LONG_BUTTON_WIDTH];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.fbButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_DEFAULT_BUTTON_HEIGHT];
	[self addConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutTwitter{
	self.twitterButton.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.twitterButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:-LAYOUT_DEFAULT_BUTTON_HEIGHT/2 + 6];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.twitterButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:25];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.twitterButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_LONG_BUTTON_WIDTH];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.twitterButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_DEFAULT_BUTTON_HEIGHT];
	[self addConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutGallery{
	self.galleryButton.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.galleryButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:LAYOUT_DEFAULT_BUTTON_HEIGHT/2];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.galleryButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:39];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.galleryButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_LONG_BUTTON_WIDTH];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.galleryButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_DEFAULT_BUTTON_HEIGHT];
	[self addConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutCamera{
	self.cameraButton.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.cameraButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.cameraButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:36];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.cameraButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_LONG_BUTTON_WIDTH];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.cameraButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_DEFAULT_BUTTON_HEIGHT];
	[self addConstraints:@[c1, c2, c3, c4]];
}

- (void) dealloc{
	[self.fbButton removeTarget:self action:@selector(fbClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.galleryButton removeTarget:self action:@selector(galleryClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.twitterButton removeTarget:self action:@selector(twitterClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.cameraButton removeTarget:self action:@selector(cameraClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.fbButton removeFromSuperview];
	[self.galleryButton removeFromSuperview];
	[self.twitterButton removeFromSuperview];
	[self.cameraButton removeFromSuperview];
	self.fbButton = nil;
	self.cameraButton = nil;
	self.galleryButton = nil;
	self.twitterButton = nil;
}


@end



