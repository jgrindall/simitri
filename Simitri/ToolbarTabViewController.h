//
//  ToolbarTabViewController.h
//  Symmetry
//
//  Created by John on 09/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ATabbedViewController_Protected.h"

@interface ToolbarTabViewController : ATabbedViewController

- (id) initWithButtons:(NSArray*)buttons withIcons:(NSArray*)icons;
- (void) buttonChosen:(NSNumber*)n;

@end
