//
//  FilesViewController.m
//  Symmetry
//
//  Created by John on 19/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "MyFilesScreenController.h"
#import "FileLoader.h"
#import "TilesCollectionController.h"
#import "SymmNotifications.h"
#import "TSMessage.h"
#import "AlbumScreenViewController.h"
#import "PFileViewer.h"
#import "FilesTabViewController.h"
#import "FilesMenuController.h"
#import "Appearance.h"
#import "DrawingScreenController.h"
#import "FileCell.h"
#import "TemplateScreenController.h"
#import "AlbumDataProvider.h"
#import "LayoutConsts.h"
#import "UIColor+Utils.h"
#import "SaveCurrentViewController.h"
#import "ToastUtils.h"
#import "ImageUtils.h"
#import "PrevFileController.h"

@interface MyFilesScreenController ()

@property UIView* filesContainer;
@property UIViewController<FileManagerDelegate>* fileControllerDelegate;
@property UILabel* message;
@property UIPopoverController* pop;
@property NSArray* files;

@end

@implementation MyFilesScreenController

- (void)viewDidLoad{
	[super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startFileClicked) name:SYMM_NOTIF_START_NEW_FILE object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openFileClicked) name:SYMM_NOTIF_OPEN_FILE object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delFileClicked) name:SYMM_NOTIF_DELETE_FILE object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCurrent:) name:SYMM_NOTIF_CURRENT_SAVE object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(skipCurrent:) name:SYMM_NOTIF_CURRENT_SKIP object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prevYes:) name:SYMM_NOTIF_PREV_YES object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prevNo) name:SYMM_NOTIF_PREV_NO object:nil];
	[self addFiles];
	[self addMessage];
	[self layoutFiles];
	[self layoutMessage];
	[self addChildInto:self.filesContainer withController:self.fileControllerDelegate];
}

- (void) prevYes:(NSNotification*) notification{
	NSURL* url = (NSURL*)[((NSDictionary*)notification.userInfo) valueForKey:@"url"];
	NSInteger index = [[FileLoader sharedInstance] fileExists:url];
	if(index >= 0){
		[self openFileAtIndex:index withForce:NO];
	}
	[self hidePop];
}

- (void) prevNo{
	[self hidePop];
}

- (void) openPrevFileOnLaunch:(NSString*)urlString{
	NSURL* url = [NSURL URLWithString:urlString];
	NSInteger index = [[FileLoader sharedInstance] fileExists:url];
	if(index >= 0){
		CGRect frame = CGRectMake((self.view.frame.size.width - LAYOUT_POPUP_WIDTH)/2,(self.view.frame.size.height - LAYOUT_TILE_POPUP_HEIGHT)/2, LAYOUT_POPUP_WIDTH, LAYOUT_TILE_POPUP_HEIGHT);
		UIViewController* contents = [[PrevFileController alloc] initWithUrl:url];
		self.pop = [[UIPopoverController alloc] initWithContentViewController:contents];
		[[[self.pop contentViewController] view] setBackgroundColor:[Colors symmGrayBgColor]];
		self.pop.popoverContentSize = CGSizeMake(LAYOUT_POPUP_WIDTH, LAYOUT_TILE_POPUP_HEIGHT);
		[self.pop presentPopoverFromRect:frame inView:self.view permittedArrowDirections:0 animated:YES];
	}
}

- (void) checkSaveForNewFile:(BOOL)newFile{
	CGRect frame = CGRectMake((self.view.frame.size.width - LAYOUT_POPUP_WIDTH)/2,(self.view.frame.size.height - LAYOUT_TILE_POPUP_HEIGHT)/2, LAYOUT_POPUP_WIDTH, LAYOUT_TILE_POPUP_HEIGHT);
	UIViewController* contents = [[SaveCurrentViewController alloc] initWithNewFile:newFile];
	self.pop = [[UIPopoverController alloc] initWithContentViewController:contents];
	[[[self.pop contentViewController] view] setBackgroundColor:[Colors symmGrayBgColor]];
	self.pop.popoverContentSize = CGSizeMake(LAYOUT_POPUP_WIDTH, LAYOUT_CURRENT_POPUP_HEIGHT);
	[self.pop presentPopoverFromRect:frame inView:self.view permittedArrowDirections:0 animated:YES];
}

- (void) hidePop{
	if(self.pop){
		[self.pop dismissPopoverAnimated:NO];
		self.pop = nil;
	}
}

- (void) saveCurrent:(NSNotification*) notification{
	BOOL newFile = [[((NSDictionary*)notification.userInfo) valueForKey:@"newFile"] boolValue];
	[self hidePop];
	[[FileLoader sharedInstance] saveCurrentFileWithCallback:^(FileLoaderResults result) {
		if(result == FileLoaderResultOk){
			[[NSNotificationCenter defaultCenter] postNotificationName:SYMM_NOTIF_FILE_SAVE_SUCCESS object:nil userInfo:nil];
			[ToastUtils showToastInController:self withMessage:[ToastUtils getFileSaveSuccessMessage] withType:TSMessageNotificationTypeSuccess];
			if(newFile){
				[self startFileWithForce:YES];
			}
			else{
				[self openFileWithForce:YES];
			}
		}
		else if(result == FileLoaderResultCheckSaveWanted){
			
		}
		else{
			[ToastUtils showToastInController:self withMessage:[ToastUtils getFileSaveErrorMessage] withType:TSMessageNotificationTypeError];
		}
	}];
}

- (void) skipCurrent:(NSNotification*) notification{
	BOOL newFile = [[((NSDictionary*)notification.userInfo) valueForKey:@"newFile"] boolValue];
	[self hidePop];
	if(newFile){
		[self startFileWithForce:YES];
	}
	else{
		[self openFileWithForce:YES];
	}
}

- (void) addMessage{
	self.message = [Appearance labelWithFontSize:SYMM_FONT_SIZE_LARGE];
	self.message.text = @"Choose a file to open, or start a new file";
	self.message.textAlignment = NSTextAlignmentCenter;
	[self.view addSubview: self.message];
}

- (void) openFileClicked{
	[self openFileWithForce:NO];
}

- (void) openFileAtIndex:(NSInteger)i withForce:(BOOL)force{
	[[FileLoader sharedInstance] openFileWithIndex:i withForce:force withCallback:^(FileLoaderResults result) {
		if(result == FileLoaderResultOk || result == FileLoaderResultAlreadyOpen){
			DrawingScreenController* v = [[DrawingScreenController alloc] init];
			[self.navigationController pushViewController:v animated:YES];
		}
		else if(result == FileLoaderResultCheckSaveWanted){
			[self checkSaveForNewFile:NO];
		}
		else{
			[ToastUtils showToastInController:self withMessage:[ToastUtils getOpenFileErrorMessage] withType:TSMessageNotificationTypeSuccess];
		}
	}];
}

- (void) openFileWithForce:(BOOL)force{
	NSInteger i = [self.fileControllerDelegate getSelectedIndex];
	if(i >= 0){
		[self openFileAtIndex:i withForce:force];
	}
}

- (void) addFiles{
	CGSize iconSize = CGSizeMake(LAYOUT_SMALLER_ICON_SIZE, LAYOUT_SMALLER_ICON_SIZE);
	NSArray* leftImgs = @[[ImageUtils iconWithName:@"layout 3.png" andSize:iconSize], [ImageUtils disabledIconWithName:@"layout 3.png" andSize:iconSize]];
	NSArray* rightImgs = @[[ImageUtils iconWithName:@"layout 6.png" andSize:iconSize], [ImageUtils disabledIconWithName:@"layout 6.png" andSize:iconSize]];
	self.fileControllerDelegate = [[FilesTabViewController alloc] initWithTitles:@[leftImgs, rightImgs]];
	self.filesContainer = [[UIView alloc] init];
	[self.view addSubview:self.filesContainer];
}

- (void) updateFileList{
	self.files = [[FileLoader sharedInstance] getYourFiles];
	[self.fileControllerDelegate loadFiles:self.files];
}

-  (void) performDelete:(NSIndexPath*) path{
	[self performDeleteAtItem:[NSNumber numberWithInteger:path.item]];
}

-  (void) performDeleteAtItem:(NSNumber*)num{
	NSInteger i = [num integerValue];
	if(i >= 0){
		[[FileLoader sharedInstance] deleteFileAtItem:i withCallback:^(FileLoaderResults result) {
			if(result == FileLoaderResultOk){
				[ToastUtils showToastInController:self withMessage:[ToastUtils getFileDeleteSuccessMessage] withType:TSMessageNotificationTypeSuccess];
				[self updateFileList];
			}
			else{
				[ToastUtils showToastInController:self withMessage:[ToastUtils getFileDeleteErrorMessage] withType:TSMessageNotificationTypeSuccess];
			}
		}];
	}
}

- (void) delFileClicked{
	NSInteger i = [self.fileControllerDelegate getSelectedIndex];
	[self performDeleteAtItem:[NSNumber numberWithInteger:i]];
}

- (void) startFileClicked{
	[self startFileWithForce:NO];
}

- (void) startFileWithForce:(BOOL)force{
	[[FileLoader sharedInstance] startNewFileWithForce:force withCallback:^(FileLoaderResults result) {
		if(result == FileLoaderResultOk){
			TemplateScreenController* v = [[TemplateScreenController alloc]init];
			[self.navigationController pushViewController:v animated:YES];
		}
		else if(result == FileLoaderResultCheckSaveWanted){
			[self checkSaveForNewFile:YES];
		}
		else{
			[ToastUtils showToastInController:self withMessage:[ToastUtils getStartFileErrorMessage] withType:TSMessageNotificationTypeSuccess];
		}
	}];
}

- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[self updateFileList];
	NSString* urlString = [[FileLoader sharedInstance] getStoredState];
	if(urlString){
		[self openPrevFileOnLaunch:urlString];
		[[FileLoader sharedInstance] clearStoredState];
	}
}

- (void) layoutMessage{
	self.message.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.message attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:5];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.message attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:150];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.message attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-150];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.message attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:50];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) layoutFiles{
	self.filesContainer.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.filesContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.filesContainer attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.filesContainer attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
	NSLayoutConstraint* c4 = [NSLayoutConstraint constraintWithItem:self.filesContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	[self.view addConstraints:@[c1, c2, c3, c4]];
}

- (void) dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_START_NEW_FILE object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_OPEN_FILE object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_DELETE_FILE object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_CURRENT_SAVE object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_CURRENT_SKIP object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_PREV_YES object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_PREV_NO object:nil];
	[self removeChildFrom:self.filesContainer withController:self.fileControllerDelegate];
	[self.filesContainer removeFromSuperview];
	self.fileControllerDelegate = nil;
	self.filesContainer = nil;
	[self hidePop];
	[self.message removeFromSuperview];
	self.message = nil;
	self.files = nil;
}

@end

