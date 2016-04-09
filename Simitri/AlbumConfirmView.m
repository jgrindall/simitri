//
//  AlbumButtonsView.m
//  Symmetry
//
//  Created by John on 09/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "AlbumConfirmView.h"
#import "LayoutConsts.h"
#import "SymmNotifications.h"
#import "Appearance.h"
#import "LayoutConsts.h"
#import "RoundRectBg.h"
#import "UIColor+Utils.h"
#import "AlbumScreenViewController.h"
#import "DisplayUtils.h"
#import "SoundManager.h"

@interface AlbumConfirmView()

@property UIButton* yesButton;
@property UIButton* noButton;
@property UILabel* label;
@property UIView* bg;
@end

@implementation AlbumConfirmView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor clearColor];
        [self addBg];
		[self addLabel];
		[self addButtons];
		[self layoutYes];
		[self layoutNo];
		[self layoutBg];
		[self layoutLabel];
    }
    return self;
}

- (void) addLabel{
	self.label = [Appearance labelWithFontSize:SYMM_FONT_SIZE_MED];
	[self addSubview:self.label];
	self.label.textAlignment = NSTextAlignmentCenter;
	self.label.text = @"Are you sure?";
}

- (void) layoutLabel{
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:5];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_DEFAULT_BUTTON_HEIGHT];
	[DisplayUtils applyConstraints:self withChild: self.label withConstraints:@[c1, c2, c3, c4]];
}

- (void) addButtons{
	CGSize size = CGSizeMake(LAYOUT_DEFAULT_BUTTON_WIDTH, LAYOUT_DEFAULT_BUTTON_HEIGHT);
	self.yesButton = [Appearance flatButtonWithLabel:@"Yes, delete" withIcon:@"right 3.png" withTheme:FlatButtonThemeDanger withSize:size];
	self.noButton = [Appearance flatButtonWithLabel:@"No, cancel" withIcon:@"multiply 2.png" withTheme:FlatButtonThemeDefault withSize:size];
	[self addSubview:self.yesButton];
	[self addSubview:self.noButton];
	[self.yesButton addTarget:self action:@selector(yesClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.noButton addTarget:self action:@selector(noClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void) addBg{
	self.bg = [[RoundRectBg alloc] initWithColor:[UIColor whiteColor]];
	[self addSubview:self.bg];
}

- (void)yesClicked {
	[[SoundManager sharedInstance] playClick];
	[DisplayUtils bubbleActionFrom:self toClass:[AlbumScreenViewController class] withSelector:@"yesClicked" withObject:self];
}

- (void)noClicked {
	[[SoundManager sharedInstance] playClick];
	[DisplayUtils bubbleActionFrom:self toClass:[AlbumScreenViewController class] withSelector:@"noClicked" withObject:self];
}

- (void) layoutBg{
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.bg attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.bg attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.bg attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.bg attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	[DisplayUtils applyConstraints:self withChild: self.bg withConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutYes{
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.yesButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:LAYOUT_DEFAULT_BUTTON_HEIGHT];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.yesButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.yesButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_LONG_BUTTON_WIDTH];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.yesButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_DEFAULT_BUTTON_HEIGHT];
	[DisplayUtils applyConstraints:self withChild: self.yesButton withConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutNo{
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.noButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-4];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.noButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.noButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_LONG_BUTTON_WIDTH];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.noButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_DEFAULT_BUTTON_HEIGHT];
	[DisplayUtils applyConstraints:self withChild: self.noButton withConstraints:@[c1, c2, c3, c4]];
}

- (void) dealloc{
	[self.yesButton removeTarget:self action:@selector(yesClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.noButton removeTarget:self action:@selector(noClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.yesButton removeFromSuperview];
	[self.noButton removeFromSuperview];
	[self.label removeFromSuperview];
	[self.bg removeFromSuperview];
	self.yesButton = nil;
	self.noButton = nil;
	self.bg = nil;
}

@end
