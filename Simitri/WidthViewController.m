//
//  WidthViewController.m
//  Symmetry
//
//  Created by John on 22/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "WidthViewController.h"
#import "SymmNotifications.h"
#import "UIColor+Utils.h"
#import "Appearance.h"

@interface WidthViewController ()

@property (nonatomic) NSInteger width;
@property UIStepper* stepper;
@property UILabel* widthLabel;
@property WidthIndicator* widthIndicator;

@end

@implementation WidthViewController

@synthesize width = _width;

- (id) initWithWidth:(NSInteger)width{
	self = [super init];
	if(self){
		self.width = width;
		self.view.backgroundColor = [UIColor whiteColor];
	}
	return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(widthChanged:) name:SYMM_NOTIF_CHANGE_WIDTH object:nil];
	[self addStepper];
	[self addLabel];
	[self addIndicator];
	[self layoutStepper];
	[self layoutIndicator];
	[self layoutLabel];
}

- (void) addLabel{
	self.widthLabel = [Appearance labelWithFontSize:SYMM_FONT_SIZE_SMALL];
	self.widthLabel.text = @"Width";
	[self.view addSubview:self.widthLabel];
	self.widthLabel.textAlignment = NSTextAlignmentCenter;
}

-  (void) layoutLabel{
	self.widthLabel.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.widthLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.widthLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.widthLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.widthLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:25];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) widthChanged:(NSNotification*) notification{
	NSInteger val = [notification.object integerValue];
	[self.widthIndicator changeWidth:val];
}

- (void) addStepper{
	self.stepper = [[UIStepper alloc] init];
	self.stepper.tintColor = [Colors symmGrayTextColor];
	[self.stepper addTarget:self action:@selector(stepClicked) forControlEvents:UIControlEventValueChanged];
	self.stepper.minimumValue = 2.0;
	self.stepper.maximumValue = 20.0;
	self.stepper.value = 2.0;
	self.stepper.stepValue = 2.0;
	[Appearance styleStepper:self.stepper];
	[self.view addSubview:self.stepper];
}

- (void) addIndicator{
	self.widthIndicator = [[WidthIndicator alloc] initWithWidth:5];
	[self.view addSubview:self.widthIndicator];
}

- (void)setSelected:(NSInteger)i{
	self.stepper.value = i;
	self.width = i;
}

- (void) layoutStepper{
	self.stepper.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.stepper attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:30];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.stepper attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.stepper attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.stepper attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:40];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutIndicator{
	self.widthIndicator.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.widthIndicator attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:50];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.widthIndicator attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.widthIndicator attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.widthIndicator attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (NSInteger) width{
	return _width;
}

- (void) setWidth:(NSInteger)newWidth{
	_width = newWidth;
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_CHANGE_WIDTH object:[NSNumber numberWithFloat:newWidth]];
}

- (void)stepClicked {
	NSInteger newWidth = (int)self.stepper.value;
	if(self.width != newWidth){
		self.width = newWidth;
	}
}

- (void) dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self.stepper removeTarget:self action:@selector(stepClicked) forControlEvents:UIControlEventValueChanged];
	[self.stepper removeFromSuperview];
	self.stepper = nil;
	[self.widthLabel removeFromSuperview];
	self.widthLabel = nil;
	[self.widthIndicator removeFromSuperview];
	self.widthIndicator = nil;
}

@end
