//
//  PVController.m
//  PageVCTesting
//
//  Created by John on 23/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "TemplateFileViewController.h"
#import "TemplateDataProvider.h"

@interface TemplateFileViewController ()

@end

@implementation TemplateFileViewController

- (void) clickMathPoint:(id) pVal{
	
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

-  (void) swipeLeft{
	[self nextPage];
}

-  (void) swipeRight{
	[self prevPage];
}

@end

