//
//  PVController.m
//  PageVCTesting
//
//  Created by John on 23/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "AlbumViewController.h"
#import "AlbumDataProvider.h"

@interface AlbumViewController ()

@end

@implementation AlbumViewController

- (void) loadFiles:(NSArray *)files{
	[self setPageDataArray:files];
}

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}

@end

