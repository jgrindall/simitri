//
//  GalleryViewerController.m
//  Simitri
//
//  Created by John on 11/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "GalleryViewerController.h"
#import "GalleryViewController.h"
#import "LayoutConsts.h"
#import "Appearance.h"
#import "GalleryDataProvider.h"
#import "GalleryPageViewController.h"
#import "DisplayUtils.h"
#import "GalleryScreenController.h"
#import "SoundManager.h"

@interface GalleryViewerController ()
@property UIView* pagesContainer;
@property GalleryViewController* pagesController;
@property UIButton* refreshButton;
@property UILabel* message;
@end

@implementation GalleryViewerController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self addButton];
	[self addPages];
	[self addLabel];
	[self layoutLabel];
	[self layoutButton];
	[self layoutPages];
	[self addChildInto:self.pagesContainer withController:self.pagesController];
}

- (void) addButton{
	self.refreshButton = [Appearance flatButtonWithLabel:@"Load more" withIcon:@"refresh.png" withTheme:FlatButtonThemePositive withSize:CGSizeMake(LAYOUT_LONG_BUTTON_WIDTH, LAYOUT_DEFAULT_BUTTON_HEIGHT)];
	[self.refreshButton addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.refreshButton];
}

- (void) addLabel{
	self.message = [Appearance labelWithFontSize:SYMM_FONT_SIZE_LARGE];
	self.message.text = @"See other peoples' designs!";
	self.message.textAlignment = NSTextAlignmentCenter;
	[self.view addSubview: self.message];
}

- (void) layoutLabel{
	self.message.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.message attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:5];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.message attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.message attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.message attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:50];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) refresh{
	[[SoundManager sharedInstance] playClick];
	[DisplayUtils bubbleActionFrom:self toClass:[GalleryScreenController class] withSelector:@"refresh" withObject:nil];
}

- (void) addPages{
	self.pagesController = [[GalleryViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil withDataProvider:[[GalleryDataProvider alloc] initWithPageClass:[GalleryPageViewController class]]];
	self.pagesContainer = [[UIView alloc] init];
	[self.view addSubview:self.pagesContainer];
}

- (void) layoutPages{
	self.pagesContainer.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.pagesContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.refreshButton attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.pagesContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.pagesContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.pagesContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (void) layoutButton{
	self.refreshButton.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.refreshButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:5];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.refreshButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-5];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.refreshButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_LONG_BUTTON_WIDTH];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.refreshButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_DEFAULT_BUTTON_HEIGHT];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) setFiles:(NSArray*) files{
	[self.pagesController setPageDataArray:files];
}

- (void) dealloc{
	[self removeChildFrom:self.pagesContainer withController:self.pagesController];
	[self.pagesContainer removeFromSuperview];
	self.pagesContainer = nil;
	self.pagesController = nil;
	[self.refreshButton removeTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
	[self.refreshButton removeFromSuperview];
	self.refreshButton = nil;
}

@end


 