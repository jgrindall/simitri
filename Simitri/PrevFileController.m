//
//  SaveCurrentViewController.m
//  Symmetry
//
//  Created by John on 09/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "PrevFileController.h"
#import "Appearance.h"
#import "LayoutConsts.h"
#import "AnimationUtils.h"
#import "SaveMenu.h"
#import "SymmNotifications.h"
#import "FileLoader.h"

@interface PrevFileController ()

@property UIView* menu;
@property UITextView* label;
@property UIImageView* imgView;
@property NSURL* url;
@end

@implementation PrevFileController

- (id) initWithUrl:(NSURL*)url{
	self = [super init];
	if(self){
		self.url = url;
	}
	return self;
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (void) viewWillDisappear:(BOOL)animated{
	[self hideMenu];
}

- (void) viewDidDisappear:(BOOL)animated{
	[self.menu.layer removeAllAnimations];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self addMenu];
	[self addImage];
	[self addLabel];
	[self layoutMenu];
	[self layoutImage];
	[self layoutLabel];
}

- (void) layoutMenu{
	self.menu.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.menu attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.menu attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.menu attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.menu attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_DEFAULT_BUTTON_HEIGHT];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) viewDidAppear:(BOOL)animated{
	[self showMenu:self.menu show:YES withKey:@"saveMenuBounce"];
}

- (void) moveMenu:(UIView*) menu from:(int) fromPos to:(int)toPos withKey:(NSString*)key{
	[AnimationUtils bounceAnimateView:menu from:fromPos to:toPos withKeyPath:@"position.y" withKey:key withDelegate:nil withDuration:0.5 withImmediate:NO];
}

- (void) showMenu:(UIView*) menu show:(BOOL)show withKey:(NSString*)key{
	int fromPos = self.view.bounds.size.height + menu.frame.size.height/2;
	int toPos = self.view.bounds.size.height - menu.frame.size.height/2;
	if(show){
		[self moveMenu:menu from:fromPos to:toPos withKey:key];
	}
	else {
		[self moveMenu:menu from:toPos to:fromPos withKey:key];
	}
}

- (void) hideMenu{
	[self showMenu:self.menu show:NO withKey:@"saveMenuBounce"];
}

- (void) addMenu{
	self.menu = [[SaveMenu alloc] init];
	[self.view addSubview:self.menu];
}

- (void) yesClicked{
	NSDictionary* dic = @{@"url":self.url};
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_PREV_YES object:nil userInfo:dic];
}

- (void) noClicked{
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_PREV_NO object:nil userInfo:nil];
}

- (void) addImage{
	self.imgView = [[UIImageView alloc] init];
	[self.view addSubview:self.imgView];
	NSString* imgFileName = [[FileLoader sharedInstance] getMedImgFilenameForUrl:self.url];
	UIImage* img = [UIImage imageWithContentsOfFile:imgFileName];
	self.imgView.image = img;
}

- (void) layoutImage{
	self.imgView.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem: self.label attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:5];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-5];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.menu attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	[self.view addConstraints:@[c1, c2, c3, c4]];

}

- (void) addLabel{
	self.label = [Appearance textViewWithFontSize:SYMM_FONT_SIZE_MED];
	[self.view addSubview:self.label];
	self.label.textAlignment = NSTextAlignmentCenter;
	self.label.text = @"Do you want to open the file\nyou were working on?";
}

- (void) layoutLabel{
	self.label.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:65];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

-(void) dealloc{
	self.imgView.image = nil;
	[self.imgView removeFromSuperview];
	self.imgView = nil;
	self.url = nil;
	[self.menu removeFromSuperview];
	self.menu = nil;
	[self.label removeFromSuperview];
	self.label = nil;
}

@end




