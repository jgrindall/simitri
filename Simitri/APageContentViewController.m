//
//  ATemplatePageViewController.m
//  Symmetry
//
//  Created by John on 30/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "APageContentViewController_Protected.h"

@implementation APageContentViewController 

- (void) dealloc{
	self.dataObject = nil;
}

- (void) populate{
	
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self populate];
}

@end
