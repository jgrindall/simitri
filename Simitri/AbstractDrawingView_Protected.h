//
//  ADrawingView_Protected.h
//  Symmetry
//
//  Created by John on 18/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "AbstractDrawingView.h"
#import "DrawingObject.h"
#import "Line.h"

@interface AbstractDrawingView ()

@property NSInteger currentTop;
@property Line* currentLine;

- (Line*) getLineAtIndex:(NSInteger) i;
- (void) lineAdded;
- (void) drawLinesWithBackground:(BOOL)background;
- (void) makeLineImageWithWhole:(BOOL) useWhole;
- (void) removeLineAtIndex:(NSInteger)i;
- (void) saveImage;
- (void) checkOverflow;
- (void) updateButtons;

@end
