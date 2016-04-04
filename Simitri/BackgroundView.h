//
//  BackgroundView.h
//  Symmetry
//
//  Created by John on 01/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawingObject.h"
#import "ADrawingLayer_Protected.h"

@interface BackgroundView : ADrawingLayer
- (UIImage*) getImageForOverlay;
@end
