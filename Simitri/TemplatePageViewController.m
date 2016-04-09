
//  Created by John on 22/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "TemplatePageViewController.h"
#import "UIColor+Utils.h"
#import "Appearance.h"
#import "HelpAnimView.h"
#import "HelpAnimViewController.h"
#import "DrawerFactory.h"
#import "SymmNotifications.h"
#import "TemplateConfig.h"
#import "ImageUtils.h"
#import "TemplateScreenController.h"
#import "DisplayUtils.h"

@interface TemplatePageViewController ()

@property UITextView* dataText;
@property UILabel* dataLabelName;
@property UIButton* infoButton;
@property UIView* helpContainer;
@property HelpAnimViewController* helpController;
@property BOOL showMath;
@property NSArray* showConstraints;
@property NSArray* hideConstraints;
@property NSArray* currentConstraints;
@end

@implementation TemplatePageViewController

- (id) init{
	self = [super init];
	if(self){
		
	}
	return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	[self addLabel];
	[self addText];
	[self addHelpAnim];
	[self addInfoButton];
	[self addChildInto:self.helpContainer withController:self.helpController];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMathChange:) name:SYMM_NOTIF_SHOW_TPL_INFO object:nil];
	[self getConstraints];
}

- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self getConstraints];
	[self layoutAnim];
	[self layoutLabel];
	[self layoutInfoButton];
}

- (void) showMathChange:(NSNotification*) notification{
	BOOL show = [[((NSDictionary*)notification.userInfo) valueForKey:@"show"] boolValue];
	[self.helpController showMath:show];
	[self.infoButton setHidden:show];
	[self updateLayoutForShow:show];
}

- (void) getConstraints{
	self.dataText.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.dataText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual			toItem:self.dataLabelName attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.dataText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual		toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:10];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.dataText attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual		toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-10];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.dataText attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual			toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:80];
	
	NSLayoutConstraint* c5 = [NSLayoutConstraint constraintWithItem:self.dataText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual			toItem:self.dataLabelName attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c6 = [NSLayoutConstraint constraintWithItem:self.dataText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual		toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:10];
	NSLayoutConstraint* c7 = [NSLayoutConstraint constraintWithItem:self.dataText attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual		toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-10];
	NSLayoutConstraint* c8 = [NSLayoutConstraint constraintWithItem:self.dataText attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual			toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:1];
	
	self.showConstraints = @[c1, c2, c3, c4];
	self.hideConstraints = @[c5, c6, c7, c8];
}

- (void) layoutInfoButton{
	self.infoButton.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.infoButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual			toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:7];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.infoButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual		toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:30];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.infoButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual		toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-3];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.infoButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual		toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:30];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutLabel{
	self.dataLabelName.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.dataLabelName attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual		toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.dataLabelName attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual	toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:10];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.dataLabelName attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual	toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-10];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.dataLabelName attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual	toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:40];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutAnim{
	self.helpContainer.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.helpContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual		toItem:self.dataText attribute:NSLayoutAttributeBottom multiplier:1 constant:5];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.helpContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual	toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.helpContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual	toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.helpContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual	toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) addLabel{
	self.dataLabelName = [Appearance labelWithFontSize:SYMM_FONT_SIZE_MED];
	[self.view addSubview:self.dataLabelName];
	self.dataLabelName.textAlignment = NSTextAlignmentCenter;
}

- (void) addText{
	self.dataText = [Appearance textViewWithFontSize:SYMM_FONT_SIZE_MED];
	[self.view addSubview:self.dataText];
	self.dataText.textAlignment = NSTextAlignmentCenter;
}

- (void) addInfoButton{
	UIImage* iconImg = [ImageUtils iconWithName:@"info.png" andSize:CGSizeMake(26,26)];
	self.infoButton = [UIButton buttonWithType:UIButtonTypeSystem];
	[self.infoButton setTitle:@" " forState:UIControlStateNormal];
	[self.infoButton setImage:iconImg forState:UIControlStateNormal];
	self.infoButton.tintColor = [Colors symmGrayButtonColor];
	[self.view addSubview:self.infoButton];
	[self.infoButton addTarget:self action:@selector(clickInfo) forControlEvents:UIControlEventTouchUpInside];
}

- (void) addHelpAnim{
	if(!self.helpContainer){
		self.helpContainer = [[UIView alloc] initWithFrame:CGRectIntegral(self.view.frame)];
		[self.view addSubview:self.helpContainer];
		self.helpController = [[HelpAnimViewController alloc] init];
	}
}

-  (void) clickInfo{
	[DisplayUtils bubbleActionFrom:self toClass:[TemplateScreenController class] withSelector:@"infoChosen" withObject:nil];
}

- (void) updateLayoutForShow:(BOOL)showMath{
	if(self.currentConstraints){
		[self.view removeConstraints:self.currentConstraints];
	}
	if(showMath){
		self.currentConstraints = self.showConstraints;
	}
	else{
		self.currentConstraints = self.hideConstraints;
	}
	[self.view addConstraints:self.currentConstraints];
}

- (void) populate{
	[super populate];
	NSInteger num = [self.dataObject integerValue];
    self.dataText.text = [DrawerFactory getMessageForDrawerNum:num];
	self.dataLabelName.text = [DrawerFactory getLabelForDrawerNum:num];
	DrawingObject* obj = [[DrawingObject alloc] init];
	obj.drawerNum = num;
	[obj setSize:self.view.frame.size];
	[obj loadDefaultColors];
	[self.helpController loadDrawingObject:obj];
	BOOL showMath = [[TemplateConfig sharedInstance] getShowMathConfig];
	[self updateLayoutForShow:showMath];
	[self.helpController showMath:showMath];
	[self.infoButton setHidden:showMath];
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (void) dealloc{
	if(self.dataLabelName){
		[self.dataLabelName removeFromSuperview];
		self.dataLabelName = nil;
	}
	if(self.dataText){
		[self.dataText removeFromSuperview];
		self.dataText = nil;
	}
	if(self.infoButton) {
		[self.infoButton removeTarget:self action:@selector(clickInfo) forControlEvents:UIControlEventTouchUpInside];
		[self.infoButton removeFromSuperview];
		self.infoButton = nil;
	}
	if(self.helpContainer){
		[self removeChildFrom:self.helpContainer withController:self.helpController];
		[self.helpContainer removeFromSuperview];
		self.helpContainer = nil;
	}
	self.helpController = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_SHOW_TPL_INFO object:nil];
}

@end


