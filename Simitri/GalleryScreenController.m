//
//  GalleryScreenController.m
//  Simitri
//
//  Created by John on 11/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "GalleryScreenController.h"
#import "GalleryViewController.h"
#import "GalleryPageViewController.h"
#import "GalleryDataProvider.h"
#import "GalleryViewerController.h"
#import "GalleryService.h"
#import "ToastUtils.h"
#import "GalleryScreenController.h"

@interface GalleryScreenController ()

@property NSArray* files;

@end

@implementation GalleryScreenController

- (UIViewController*) getChildControllerAt:(NSInteger)i{
	UIViewController* viewer;
	if(i == 0){
		viewer = [[GalleryViewerController alloc] init];
	}
	return viewer;
}

- (NSInteger) numChildren{
	return self.files.count;
}

- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[self loadFiles];
}

- (void) showFiles{
	[self showChild:0];
	GalleryViewerController* gallery = (GalleryViewerController*)self.currentChildController;
	[gallery setFiles:self.files];
}

- (void) refresh{
	[[GalleryService sharedInstance] clear];
	[self loadFiles];
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (void) loadFiles{
	self.files = [[GalleryService sharedInstance] getFiles];
	if(self.files && self.files.count >= 2){
		[self showFiles];
	}
	else{
		[[GalleryService sharedInstance] getFilesWithCallback:^(GalleryResults result) {
			if(result == GalleryResultOk){
				self.files = [[GalleryService sharedInstance] getFiles];
				[self showFiles];
			}
			else {
				NSString* message;
				TSMessageNotificationType type = TSMessageNotificationTypeError;
				if(result == GalleryResultUnreachable){
					message = [ToastUtils getGalleryViewNoInternetMessage];
				}
				else if(result == GalleryResultInsufficientFilesError){
					message = [ToastUtils getGalleryViewInsuffFilesMessage];
				}
				else{
					message = [ToastUtils getGalleryViewErrorMessage];
				}
				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
					[ToastUtils showToastInController:self withMessage:message withType:type];
				});
			}
		}];
	}
}

@end;
