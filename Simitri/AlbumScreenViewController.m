//
//  AlbumScreenViewController.m
//  Symmetry
//
//  Created by John on 09/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "AlbumScreenViewController.h"
#import "AlbumViewController.h"
#import "Appearance.h"
#import "SymmNotifications.h"
#import "LayoutConsts.h"
#import "AlbumDataProvider.h"
#import "AlbumPageViewController.h"
#import "AlbumButtonsView.h"
#import "AnimationUtils.h"
#import "AlbumConfirmView.h"

@interface AlbumScreenViewController ()

@property UIView* albumContainer;
@property AlbumViewController* albumController;
@property AlbumButtonsView* buttons;
@property AlbumConfirmView* confirm;
@property BOOL showButtons;
@property BOOL showConfirm;
@property NSArray* files;

@end

@implementation AlbumScreenViewController

- (void)viewDidLoad{
	[super viewDidLoad];
	self.showButtons = YES;
	self.showConfirm = NO;
	[self addAll];
	[self layoutAll];
	[self addChildInto:self.albumContainer withController:self.albumController];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDidRotate:) name:SYMM_NOTIF_DID_ROTATE object:nil];
}

- (void) addAll{
	[self addPageView];
	[self addButtons];
	[self addConfirm];
}

- (void) layoutAll{
	[self layoutButtons];
	[self layoutPageView];
	[self layoutConfirm];
}
	 
- (void) onDidRotate:(NSNotification*) notification{
	[self updateViewConstraints];
}

- (void) updateViewConstraints{
	[super updateViewConstraints];
	[self showButtons:self.buttons show:self.showButtons withImmediate:YES];
	[self showButtons:self.confirm show:self.showConfirm withImmediate:YES];
}

- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[self updateViewConstraints];
}

- (void) viewWillDisappear:(BOOL)animated{
	[self showButtons:self.buttons show:NO withImmediate:YES];
	[self showButtons:self.confirm show:NO withImmediate:YES];
}

- (void) viewDidDisappear:(BOOL)animated{
	[self.buttons.layer removeAllAnimations];
	[self.confirm.layer removeAllAnimations];
}

- (void) addPageView{
	self.albumContainer = [[UIView alloc] init];
	[self.view addSubview:self.albumContainer];
	self.albumController = [[AlbumViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil withDataProvider:[[AlbumDataProvider alloc] initWithPageClass:[AlbumPageViewController class]]];
}

- (void) addButtons{
	self.buttons = [[AlbumButtonsView alloc] init];
	[self.view addSubview:self.buttons];
}

- (void) addConfirm{
	self.confirm = [[AlbumConfirmView alloc] init];
	[self.view addSubview:self.confirm];
}

- (void) yesClicked{
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_DELETE_FILE object:nil];
	[self showButtons:self.buttons show:YES withImmediate:NO];
	[self showButtons:self.confirm show:NO withImmediate:YES];
	self.showButtons = YES;
	self.showConfirm = NO;
}

- (void) noClicked{
	[self showButtons:self.buttons show:YES withImmediate:NO];
	[self showButtons:self.confirm show:NO withImmediate:YES];
	self.showButtons = YES;
	self.showConfirm = NO;
}

- (void) delClicked{
	[self showButtons:self.buttons show:NO withImmediate:YES];
	[self showButtons:self.confirm show:YES withImmediate:NO];
	self.showButtons = NO;
	self.showConfirm = YES;
}

- (void) openClicked{
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_OPEN_FILE object:nil];
}

-(void) showButtons:(UIView*) view show:(BOOL)show withImmediate:(BOOL) immediate{
	int from = self.view.frame.size.width + view.frame.size.width/2.0 + 40;
	int to = self.view.frame.size.width - view.frame.size.width/2.0 + 15;
	if(show){
		[AnimationUtils bounceAnimateView:view from:from to:to withKeyPath:@"position.x" withKey:@"albumButtonsBounce" withDelegate:nil withDuration:0.5 withImmediate:immediate];
	}
	else{
		[AnimationUtils bounceAnimateView:view from:to to:from withKeyPath:@"position.x" withKey:@"albumButtonsBounce" withDelegate:nil withDuration:0.5 withImmediate:immediate];
	}
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (void) layoutButtons{
	int len = LAYOUT_LONG_BUTTON_WIDTH + 5;
	self.buttons.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.buttons attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:50];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.buttons attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant: 5];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.buttons attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:len];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.buttons attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:3*LAYOUT_DEFAULT_BUTTON_HEIGHT + 10];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutConfirm{
	int len = LAYOUT_LONG_BUTTON_WIDTH + 5;
	self.confirm.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.confirm attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:-50];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.confirm attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant: len];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.confirm attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:len];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.confirm attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:3*LAYOUT_DEFAULT_BUTTON_HEIGHT + 20];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutPageView{
	self.albumContainer.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.albumContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.albumContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.albumContainer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.albumContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) loadFiles:(NSArray *)files{
	self.files = files;
	[self.albumController loadFiles:files];
}

- (NSInteger) getSelectedIndex{
	return self.albumController.getSelectedIndex;
}

- (void) removeListeners{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_DID_ROTATE object:nil];
}

- (void) dealloc{
	[self removeListeners];
	[self removeChildFrom:self.albumContainer withController:self.albumController];
	[self.albumContainer removeFromSuperview];
	self.albumContainer = nil;
	self.albumController = nil;
	[self.buttons removeFromSuperview];
	self.buttons = nil;
	[self.confirm removeFromSuperview];
	self.confirm = nil;
}

@end

