//
//  TabViewController.m
//  Symmetry
//
//  Created by John on 19/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "DrawingMenuViewController.h"
#import "SymmNotifications.h"
#import "Appearance.h"
#import "SoundManager.h"
#import "LaunchOptions.h"

@interface DrawingMenuViewController ()

@property UIButton* undoButton;
@property UIButton* redoButton;
@property UIButton* saveButton;
@property UIButton* clrButton;
@property UIButton* shareButton;
@property UIButton* infoButton;
@property BOOL infoShown;
@end

@implementation DrawingMenuViewController

- (void) addItems{
	self.undoButton = [self addButtonWithLabel:@"Undo" clickSelector:@selector(undoClicked) withTrailingSpace:YES withLeadingSpace:YES withSize:CGSizeZero withIcon:@"arrow 19.png" withTheme:FlatButtonThemeDefault];
	self.redoButton = [self addButtonWithLabel:@"Redo" clickSelector:@selector(redoClicked) withTrailingSpace:YES withLeadingSpace:NO withSize:CGSizeZero withIcon:@"arrow 20.png" withTheme:FlatButtonThemeDefault];
	self.saveButton = [self addButtonWithLabel:@"Save" clickSelector:@selector(saveClicked) withTrailingSpace:YES withLeadingSpace:NO withSize:CGSizeZero withIcon:@"floppy disk.png" withTheme:FlatButtonThemePositive];
	self.clrButton = [self addButtonWithLabel:@"Clear" clickSelector:@selector(clrClicked) withTrailingSpace:YES withLeadingSpace:NO withSize:CGSizeZero withIcon:@"multiply.png" withTheme:FlatButtonThemeDanger];
	self.shareButton = [self addButtonWithLabel:@"Share" clickSelector:@selector(shareClicked) withTrailingSpace:YES withLeadingSpace:NO withSize:CGSizeZero withIcon:@"share.png" withTheme:FlatButtonThemeDefault];
	self.infoButton = [self addButtonWithLabel:@"Show" clickSelector:@selector(infoClicked) withTrailingSpace:YES withLeadingSpace:NO withSize:CGSizeZero withIcon:@"info.png" withTheme:FlatButtonThemeDefault];
	[self.saveButton setEnabled:NO];
}

- (void)viewDidLoad{
    [super viewDidLoad];
	self.infoShown = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUndo:) name:SYMM_NOTIF_ENABLE_UNDO object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRedo:) name:SYMM_NOTIF_ENABLE_REDO object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileChanged) name:SYMM_NOTIF_FILE_CHANGED object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileSaved) name:SYMM_NOTIF_FILE_SAVE_SUCCESS object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoShowChange:) name:SYMM_NOTIF_PERFORM_INFO object:nil];
	[[self redoButton] setEnabled:NO];
	[[self undoButton] setEnabled:NO];
}

- (void) infoShowChange:(NSNotification*) notification{
	BOOL infoShown = [[((NSDictionary*)notification.userInfo) valueForKey:@"infoShown"] boolValue];
	NSString* label;
	if(!infoShown){
		label = @"Hide";
	}
	else{
		label = @"Show";
	}
	self.infoShown = !infoShown;
	[self.infoButton setTitle:label forState:UIControlStateNormal];
	[self.infoButton setNeedsDisplay];
}

-  (void) fileChanged{
	[self.saveButton setEnabled:YES];
}

-  (void) fileSaved{
	[self.saveButton setEnabled:NO];
}

- (void) updateUndo:(id) data{
	BOOL enabled = [((NSNotification*)data).object boolValue];
	[[self undoButton] setEnabled:enabled];
}

- (void) updateRedo:(id) data{
	BOOL enabled = [((NSNotification*)data).object boolValue];
	[[self redoButton] setEnabled:enabled];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)redoClicked {
	[[SoundManager sharedInstance] playClick];
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_PERFORM_REDO object:nil];
}

- (void)undoClicked {
	[[SoundManager sharedInstance] playClick];
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_PERFORM_UNDO object:nil];
}

- (void)infoClicked {
	[[SoundManager sharedInstance] playClick];
	NSDictionary* dic = @{@"infoShown":[NSNumber numberWithBool:self.infoShown]};
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_PERFORM_INFO object:nil userInfo:dic];
}

- (void)shareClicked {
	[[SoundManager sharedInstance] playClick];
	BOOL isKids = [[LaunchOptions sharedInstance] getIsKids];
	if(isKids){
		[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_ALERT object:nil userInfo:@{@"message":@"No!"}];
	}
	else{
		[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_PERFORM_SHARE object:nil];
	}
}

- (void)saveClicked {
	[[SoundManager sharedInstance] playClick];
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_PERFORM_SAVE object:nil];
}

- (void)clrClicked {
	[[SoundManager sharedInstance] playClick];
	[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_PERFORM_CLR object:nil];
}

- (void) dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_ENABLE_UNDO object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_ENABLE_REDO object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_FILE_CHANGED object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_FILE_SAVE_SUCCESS object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_PERFORM_INFO object:nil];
	[self.undoButton removeTarget:self action:@selector(undoClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.redoButton removeTarget:self action:@selector(redoClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.saveButton removeTarget:self action:@selector(saveClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.clrButton removeTarget:self action:@selector(clrClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.shareButton removeTarget:self action:@selector(shareClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.infoButton removeTarget:self action:@selector(infoClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.undoButton removeFromSuperview];
	[self.redoButton removeFromSuperview];
	[self.saveButton removeFromSuperview];
	[self.clrButton removeFromSuperview];
	[self.infoButton removeFromSuperview];
	[self.shareButton removeFromSuperview];
	self.undoButton = nil;
	self.redoButton = nil;
	self.infoButton = nil;
	self.shareButton = nil;
	self.saveButton = nil;
	self.clrButton = nil;
}

@end
