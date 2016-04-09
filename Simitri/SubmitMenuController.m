//
//  TabViewController.m
//  Symmetry
//
//  Created by John on 19/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "SubmitMenuController.h"
#import "SymmNotifications.h"
#import "Appearance.h"
#import "LayoutConsts.h"
#import "DisplayUtils.h"
#import "GallerySubmitViewController.h"
#import "SoundManager.h"

@interface SubmitMenuController ()

@property UIButton* yesButton;
@property UIButton* backButton;

@end

@implementation SubmitMenuController

- (void) addItems{
	self.backButton = [self addButtonWithLabel:@"Back to the drawing" clickSelector:@selector(backClicked) withTrailingSpace:YES withLeadingSpace:YES withSize:CGSizeMake(LAYOUT_LONG_BUTTON_WIDTH, LAYOUT_DEFAULT_BUTTON_HEIGHT) withIcon:@"multiply 2.png" withTheme:FlatButtonThemeDefault];
	self.yesButton = [self addButtonWithLabel:@"Yes, submit!" clickSelector:@selector(yesClicked) withTrailingSpace:YES withLeadingSpace:YES withSize:CGSizeMake(LAYOUT_LONG_BUTTON_WIDTH, LAYOUT_DEFAULT_BUTTON_HEIGHT) withIcon:@"correct7.png" withTheme:FlatButtonThemePositive];
	self.yesButton.enabled = NO;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptChange:) name:SYMM_NOTIF_ACCEPT_TERMS object:nil];
}

- (void) enableButtonAtIndex:(NSInteger)i enabled:(BOOL)enable{
	if(i==0){
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.backButton setEnabled:enable];
			[self.backButton setHighlighted:!enable];
		});
	}
	else if(i==1){
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.yesButton setEnabled:enable];
			[self.yesButton setHighlighted:!enable];
		});
	}
}

- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self.yesButton setEnabled:NO];
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (void)yesClicked {
	[[SoundManager sharedInstance] playClick];
	[DisplayUtils bubbleActionFrom:self toClass:[GallerySubmitViewController class] withSelector:@"yesClicked" withObject:nil];
}

- (void)backClicked {
	[[SoundManager sharedInstance] playClick];
	[DisplayUtils bubbleActionFrom:self toClass:[GallerySubmitViewController class] withSelector:@"backClicked" withObject:nil];
}

- (void) acceptChange:(NSNotification*) notification{
	BOOL on = [[((NSDictionary*)notification.userInfo) valueForKey:@"on"] boolValue];
	self.yesButton.enabled = on;
}

- (void) dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_ACCEPT_TERMS object:nil];
	[self.yesButton removeTarget:self action:@selector(yesClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.yesButton removeFromSuperview];
	[self.backButton removeFromSuperview];
	self.yesButton = nil;
	self.backButton = nil;
}

@end
