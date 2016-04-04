//
//  PVController.m
//  PageVCTesting
//
//  Created by John on 23/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "HelpViewController.h"
#import "Colors.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (void) viewDidLoad{
	[super viewDidLoad];
	self.view.backgroundColor = [Colors symmGrayBgColor];
}

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

