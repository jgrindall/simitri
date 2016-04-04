//
//  DrawingViewController.h
//  Symmetry
//
//  Created by John on 19/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawingObject.h"
#import "AbstractDrawingView.h"
#import "AnimViewController_Protected.h"

@interface DrawingViewController : AnimViewController

- (NSArray*) getThumbs;
- (UIImage*) getLargeThumb;
- (UIImage*) getMedThumb;
- (UIImage*) getThumb;
- (void) loadDrawingObject:(DrawingObject*) obj;
- (DrawingObject*) getDrawingObject;
- (void) onRotate;

@end
