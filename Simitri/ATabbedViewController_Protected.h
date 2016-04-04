//
//  ATabbedViewController_Protected.h
//  Symmetry
//
//  Created by John on 08/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ATabbedViewController.h"
#import "PFileViewer.h"

@interface ATabbedViewController ()

@property UIView * container;
@property UIViewController* currentChildController;
@property NSInteger childShown;

- (void) showChild:(NSInteger)childIndex;
- (UIViewController*) getChildControllerAt:(NSInteger)i;
- (NSInteger) numChildren;
- (void) onViewAdded;

@end
