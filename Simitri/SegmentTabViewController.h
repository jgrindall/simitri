//
//  FlexiTabViewController.h
//  FileManager
//
//  Created by John on 26/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATabbedViewController_Protected.h"

@interface SegmentTabViewController : ATabbedViewController

- (id) initWithTitles:(NSArray*)titles;
- (void) showSegments:(BOOL) show;
@end
