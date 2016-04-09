//
//  TemplateMenuControllerViewController.m
//  Symmetry
//
//  Created by John on 30/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "TemplateMenuController.h"
#import "FilesMenuController.h"
#import "DisplayUtils.h"
#import "SymmNotifications.h"
#import "Appearance.h"
#import "MyFilesScreenController.h"
#import "SymmNotifications.h"
#import "TemplateScreenController.h"
#import "AnimationUtils.h"
#import "LayoutConsts.h"
#import "SoundManager.h"
#import "TemplateConfig.h"

@interface TemplateMenuController ()

@property UIButton* startButton;
@property UIButton* infoButton;
@property UIButton* egButton;

@end

@implementation TemplateMenuController

- (void) viewDidLoad{
	[super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTpl:) name:SYMM_NOTIF_SHOW_TPL_INFO object:nil];
}

- (void) addItems{
	self.egButton = [self addButtonWithLabel:@"Show example" clickSelector:@selector(egClicked) withTrailingSpace:YES withLeadingSpace:YES withSize:CGSizeMake(LAYOUT_LONG_BUTTON_WIDTH, LAYOUT_DEFAULT_BUTTON_HEIGHT) withIcon:@"eye44.png" withTheme:FlatButtonThemeDefault];
	self.startButton = [self addButtonWithLabel:@"Choose this template" clickSelector:@selector(startClicked) withTrailingSpace:YES withLeadingSpace:YES withSize:CGSizeMake(LAYOUT_LONG_BUTTON_WIDTH, LAYOUT_DEFAULT_BUTTON_HEIGHT) withIcon:@"correct7.png" withTheme:FlatButtonThemePositive];
	self.infoButton = [self addButtonWithLabel:@"Show info" clickSelector:@selector(infoClicked) withTrailingSpace:YES withLeadingSpace:YES withSize:CGSizeMake(LAYOUT_LONG_BUTTON_WIDTH, LAYOUT_DEFAULT_BUTTON_HEIGHT) withIcon:@"info.png" withTheme:FlatButtonThemeDefault];
}

- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[self showInfo: ![[TemplateConfig sharedInstance] getShowMathConfig]];
}

- (void) showTpl:(NSNotification*) notification{
	BOOL show = [[((NSDictionary*)notification.userInfo) valueForKey:@"show"] boolValue];
	[self showInfo:!show];
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (void) showInfo:(BOOL)show{
	NSString* label;
	if(show){
		label = @"Show info";
	}
	else{
		label = @"Hide info";
	}
	[self.infoButton setTitle:label forState:UIControlStateNormal];
}

- (void) startClicked{
	[[SoundManager sharedInstance] playClick];
	[DisplayUtils bubbleActionFrom:self toClass:[TemplateScreenController class] withSelector:@"tplChosen" withObject:nil];
}

- (void) egClicked{
	[[SoundManager sharedInstance] playClick];
	[DisplayUtils bubbleActionFrom:self toClass:[TemplateScreenController class] withSelector:@"egChosen" withObject:nil];
}

- (void) infoClicked{
	[[SoundManager sharedInstance] playClick];
	[DisplayUtils bubbleActionFrom:self toClass:[TemplateScreenController class] withSelector:@"infoChosen" withObject:nil];
}

- (void) dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_SHOW_TPL_INFO object:nil];
	if(self.startButton){
		[self.startButton removeTarget:self action:@selector(startClicked) forControlEvents:UIControlEventTouchUpInside];
		[self.startButton removeFromSuperview];
		self.startButton = nil;
	}
	if(self.infoButton){
		[self.infoButton removeTarget:self action:@selector(infoClicked) forControlEvents:UIControlEventTouchUpInside];
		[self.infoButton removeFromSuperview];
		self.infoButton = nil;
	}
}

@end
