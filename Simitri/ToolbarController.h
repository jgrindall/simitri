//
//  MainMenuToolbarController.h
//  Symmetry
//
//  Created by John on 08/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolbarViewController_Protected.h"

@interface ToolbarController : ToolbarViewController

- (id) initWithButtons:(NSArray*) buttons andIcons:(NSArray*) icons;
- (void) highlightButton:(NSInteger)i;

@end
