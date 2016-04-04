//
//  AHelpContentsViewController.m
//  Simitri
//
//  Created by John on 18/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "AHelpContentsViewController.h"

@interface AHelpContentsViewController ()

@end

@implementation AHelpContentsViewController

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
	if(self.view && !self.view.window){
		[self cleanUpView];
	}
}

- (void) cleanUpView{
	[self.view removeFromSuperview];
	self.view = nil;
}

- (void) dealloc{
	[self cleanUpView];
}

@end
