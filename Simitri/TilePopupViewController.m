//
//  ContentsViewController.m
//  AlertStuff
//
//  Created by John on 28/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "TilePopupViewController.h"
#import "Appearance.h"
#import "SymmNotifications.h"
#import "LayoutConsts.h"
#import "TilePopupMenu.h"
#import "AnimationUtils.h"
#import "TileConfirmPopupMenu.h"
#import "UIImage+RoundedCorner.h"

@interface TilePopupViewController ()

@property UIView* menu;
@property UIView* confirmMenu;
@property NSString* imgFileName;
@property UIImageView* imgView;
@end

@implementation TilePopupViewController

- (id) initWithImage:(NSString*)img{
	self = [super init];
	if(self){
		_imgFileName = img;
		self.view.clipsToBounds = YES;
	}
	return self;
}

- (void) viewWillDisappear:(BOOL)animated{
	[self hideMenu];
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (void) viewDidDisappear:(BOOL)animated{
	[self.menu.layer removeAllAnimations];
	[self.confirmMenu.layer removeAllAnimations];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"Title";
	self.view.backgroundColor = [UIColor whiteColor];
	[self addMenu];
	[self addImage];
	[self layoutMenu];
	[self layoutConfirmMenu];
	[self layoutImg];
}

- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[self showMenu:self.menu show:YES withKey:@"albumMenuBounce"];
	[self showMenu:self.confirmMenu show:NO withKey:@"albumConfirmMenuBounce"];
}

- (void) addMenu{
	self.menu = [[TilePopupMenu alloc] init];
	[self.view addSubview:self.menu];
	self.confirmMenu = [[TileConfirmPopupMenu alloc] init];
	[self.view addSubview:self.confirmMenu];
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

- (void) delClicked{
	[self showMenu:self.menu show:NO withKey:@"albumMenuBounce"];
	[self showMenu:self.confirmMenu show:YES withKey:@"albumConfirmMenuBounce"];
}

- (void) openClicked{
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_HIDE_POPUP object:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_OPEN_FILE object:nil];
}

- (void) yesClicked{
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_HIDE_POPUP object:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_DELETE_FILE object:nil];
}

- (void) noClicked{
	[self showMenu:self.menu show:YES withKey:@"albumMenuBounce"];
	[self showMenu:self.confirmMenu show:NO withKey:@"albumConfirmMenuBounce"];
}

- (void) hideMenu{
	[self showMenu:self.menu show:NO withKey:@"albumMenuBounce"];
	[self showMenu:self.confirmMenu show:NO withKey:@"albumConfirmMenuBounce"];
}

- (void) addImage{
	UIImage* img = [UIImage imageWithContentsOfFile:self.imgFileName];
	self.imgView = [[UIImageView alloc] initWithImage:img];
	self.imgView.contentMode = UIViewContentModeScaleAspectFit;
	[self.view addSubview:self.imgView];
}

- (void) layoutImg{
	self.imgView.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:5];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:5];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-LAYOUT_DEFAULT_BUTTON_HEIGHT];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_FILE_THUMB_MED_SIZE];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutMenu{
	self.menu.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.menu attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.menu attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.menu attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.menu attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_DEFAULT_BUTTON_HEIGHT];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutConfirmMenu{
	self.confirmMenu.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.confirmMenu attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.confirmMenu attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.confirmMenu attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.confirmMenu attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:LAYOUT_DEFAULT_BUTTON_HEIGHT];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) dealloc{
	[self.menu removeFromSuperview];
	self.menu = nil;
	[self.confirmMenu removeFromSuperview];
	self.confirmMenu = nil;
	[self.imgView removeFromSuperview];
	self.imgView = nil;
}

@end


