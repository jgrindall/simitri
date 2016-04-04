//
//  AnimViewController.h
//  Symmetry
//
//  Created by John on 23/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawingObject.h"

@interface AnimViewController : UIViewController

- (void) startAnimate;
- (void) stopAnimateWithFade:(BOOL)fade;
- (void) clickMathPoint:(id)pVal;
- (void) loadDrawingObject:(DrawingObject*) obj;

@end
