//
//  SymmetryTabViewController.h
//  FileManager
//
//  Created by John on 26/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "SegmentTabViewController.h"
#import "FileManagerDelegate.h"

@interface FilesTabViewController : SegmentTabViewController <FileManagerDelegate>

- (id) initWithTitles:(NSArray*)titles;

@end
