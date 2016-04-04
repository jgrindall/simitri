//
//  ADrawingView.h
//  Symmetry
//
//  Created by John on 17/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Line.h"
#import "ADrawer.h"
#import "DrawingObject.h"
#import "ADrawingLayer_Protected.h"

@interface AbstractDrawingView : ADrawingLayer

{
	@protected CGPoint bezPts[5];
	@protected int ctr;
}

extern NSInteger const SYMM_MAX_UNDO_STACK;
@property DrawingObject* drawingObject;
- (UIImage*) getImageForOverlay;
- (void) memoryWarning;
- (void) undo;
- (void) redo;
- (void) clear;


@end
