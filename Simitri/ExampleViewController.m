//
//  ExampleViewController.m
//  Simitri
//
//  Created by John on 21/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ExampleViewController.h"
#import "Appearance.h"
#import "ImageUtils.h"
#import "PolaroidView.h"
#import "LayoutConsts.h"
#import "UIColor+Utils.h"
#import "RoundRectBg.h"
#import "SymmNotifications.h"
#import "DrawerFactory.h"

@interface ExampleViewController ()

@property NSInteger index;
@property PolaroidView* imgView;
@property UIView* bgView;
@property UIButton* closeButton;
@property UISwipeGestureRecognizer* swipeLeftGesture;
@property UISwipeGestureRecognizer* swipeRightGesture;
@end

@implementation ExampleViewController

- (id) initWithIndex:(NSInteger) i{
	self = [super init];
	if(self){
		self.index = i;
		self.view.backgroundColor = [UIColor getGray:0.85 withAlpha:0.85];
	}
	return self;
}

- (void) loadIndex:(NSInteger) i{
	self.index = i;
	[self loadImageInfo];
}

- (void) addBg{
	self.bgView = [[RoundRectBg alloc] initWithFrame:CGRectMake(0, 0, 100, 100) withColor:[Colors symmGrayBgColor]];
	[self.view addSubview:self.bgView];
}

- (void) addButton{
	UIImage* iconImg = [ImageUtils iconWithName:@"multiply 2.png" andSize:CGSizeMake(30,30)];
	self.closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
	self.closeButton.tintColor = [Colors symmGrayButtonColor];
	[self.closeButton setTitle:@" " forState:UIControlStateNormal];
	[self.closeButton setImage:iconImg forState:UIControlStateNormal];
	[self.closeButton addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.closeButton];
}

- (void) clickClose{
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_CLOSE_EXAMPLE object:nil];
}

- (void) addImage{
	self.imgView = [[PolaroidView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) hasDes:YES];
	[self.view addSubview:self.imgView];
	[self loadImageInfo];
}

- (void) loadImageInfo{
	NSString* urlString = [DrawerFactory imageUrlForIndex:self.index];
	NSString* desc = [DrawerFactory imageDesForIndex:self.index];
	[self.imgView loadImage:[ImageUtils loadImageNamed:urlString] withDescription:desc];
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (void) layoutBg{
	self.bgView.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.bgView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.bgView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.bgView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_EXAMPLE_WIDTH + 50];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.bgView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_EXAMPLE_HEIGHT + 50];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutButton{
	self.closeButton.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.closeButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.bgView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.closeButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.bgView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.closeButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:40];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.closeButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:40];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutImage{
	self.imgView.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:10];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_EXAMPLE_WIDTH];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_EXAMPLE_HEIGHT];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void)viewDidLoad{
    [super viewDidLoad];
	[self addBg];
	[self addImage];
	[self addButton];
	[self layoutImage];
	[self layoutBg];
	[self layoutButton];
	self.swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedLeft:)];
	self.swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
	self.swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedRight:)];
	self.swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
	[self.view addGestureRecognizer:self.swipeLeftGesture];
	[self.view addGestureRecognizer:self.swipeRightGesture];
}

- (void)swipedLeft:(UISwipeGestureRecognizer*)gesture{
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_EXAMPLE_SWIPE_LEFT object:nil];
}

- (void)swipedRight:(UISwipeGestureRecognizer*)gesture{
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_EXAMPLE_SWIPE_RIGHT object:nil];
}

- (void) dealloc{
	[self.closeButton removeTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
	[self.view removeGestureRecognizer:self.swipeLeftGesture];
	self.swipeLeftGesture = nil;
	[self.view removeGestureRecognizer:self.swipeRightGesture];
	self.swipeRightGesture = nil;
	[self.imgView removeFromSuperview];
	self.imgView = nil;
	[self.bgView removeFromSuperview];
	self.bgView = nil;
	[self.closeButton removeFromSuperview];
	self.closeButton = nil;
}

@end
