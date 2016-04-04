//
//  PVController.m
//  PageVCTesting
//
//  Created by John on 23/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "GalleryViewController.h"
#import "SymmNotifications.h"
#import "GalleryPageViewController.h"

@interface GalleryViewController ()

@end

@implementation GalleryViewController

- (void) viewDidLoad{
	[super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDidRotate:) name:SYMM_NOTIF_DID_ROTATE object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onWillRotate:) name:SYMM_NOTIF_WILL_ROTATE object:nil];
}

- (void) onDidRotate:(NSNotification*) notification{
	[self relayout];
}

- (void) relayout{
	NSInteger num = self.dataProvider.dataArray.count;
	GalleryPageViewController* child;
	NSInteger i0 = [self getSelectedIndex] - 1;
	NSInteger i1 = [self getSelectedIndex];
	NSInteger i2 = [self getSelectedIndex] + 1;
	for (GalleryPageViewController* p in self.childViewControllers) {
		[p layoutAll];
	}
	if(i0 >= 0 && i0 < num){
		child = (GalleryPageViewController*)[self.dataProvider viewControllerAtIndex:i0];
		[child layoutAll];
	}
	if(i1 >= 0 && i1 < num){
		child = (GalleryPageViewController*)[self.dataProvider viewControllerAtIndex:i1];
		[child layoutAll];
	}
	if(i2 >= 0 && i2 < num){
		child = (GalleryPageViewController*)[self.dataProvider viewControllerAtIndex:i2];
		[child layoutAll];
	}
}

- (void) onWillRotate:(NSNotification*) notification{
	[self relayout];
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (void) dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_DID_ROTATE object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SYMM_NOTIF_WILL_ROTATE object:nil];
}

@end

