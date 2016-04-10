//
//  SaveCurrentViewController.m
//  Symmetry
//
//  Created by John on 09/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "SaveCurrentViewController.h"
#import "Appearance.h"
#import "LayoutConsts.h"
#import "AnimationUtils.h"
#import "SaveMenu.h"
#import "SymmNotifications.h"

@interface SaveCurrentViewController ()

@property UIView* menu;
@property UITextView* label;
@property BOOL newFile;
@end

@implementation SaveCurrentViewController

- (id) initWithNewFile:(BOOL)newFile{
	self = [super init];
	if(self){
		self.newFile = newFile;
	}
	return self;
}

- (void) viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	[self hideMenu];
}

- (void) viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:animated];
	[self.menu.layer removeAllAnimations];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self addMenu];
	[self addLabel];
	[self layoutMenu];
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
	self.menu = [[SaveMenu alloc] init];
	[self.view addSubview:self.menu];
}

- (void) yesClicked{
	NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:self.newFile], @"newFile", nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_CURRENT_SAVE object:nil userInfo:dic];
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (void) noClicked{
	NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:self.newFile], @"newFile", nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_CURRENT_SKIP object:nil userInfo:dic];
}

- (void) addLabel{
	self.label = [Appearance textViewWithFontSize:SYMM_FONT_SIZE_MED];
	[self.view addSubview:self.label];
	self.label.textAlignment = NSTextAlignmentCenter;
	self.label.text = @"You are trying to open a file but your current file has been modified and not saved.\n\nSave current file?";
}

- (void) layoutLabel{
	self.label.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:110];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

-(void) dealloc{
	[self.menu removeFromSuperview];
	self.menu = nil;
	[self.label removeFromSuperview];
	self.label = nil;
}

@end




