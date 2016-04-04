//
//  SaveCurrentViewController.m
//  Symmetry
//
//  Created by John on 09/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ShareViewController.h"
#import "Appearance.h"
#import "LayoutConsts.h"
#import "AnimationUtils.h"
#import "ShareMenu.h"
#import "SymmNotifications.h"

@interface ShareViewController ()

@property UIView* menu;
@property UITextView* label;
@property BOOL newFile;

@end

@implementation ShareViewController

- (void) viewWillDisappear:(BOOL)animated{
	[self hideMenu];
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (void) viewDidDisappear:(BOOL)animated{
	[self.menu.layer removeAllAnimations];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self addMenu];
	[self layoutMenu];
}

- (void) layoutMenu{
	self.menu.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.menu attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.menu attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.menu attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.menu attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
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
	self.menu = [[ShareMenu alloc] init];
	[self.view addSubview:self.menu];
}

- (void) fbClicked{
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_FACEBOOK object:nil];
}

- (void) twitterClicked{
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_TWITTER object:nil];
}

- (void) cameraClicked{
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_CAMERA object:nil];
}

- (void) galleryClicked{
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_GALLERY object:nil];
}

- (void) dealloc{
	[self.menu removeFromSuperview];
	self.menu = nil;
	[self.label removeFromSuperview];
	self.label = nil;
}

@end




