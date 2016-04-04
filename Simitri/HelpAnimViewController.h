//
//  HelpAnimViewController.h
//  Simitri
//
//  Created by John on 16/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ADrawer.h"
#import "DrawingObject.h"
#import "AnimViewController_Protected.h"

@interface HelpAnimViewController : AnimViewController

- (void) touch:(UITouch*)touch;
- (void) showMath:(BOOL) show;

@end
