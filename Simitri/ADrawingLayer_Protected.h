//
//  ADrawingLayer_Protected.h
//  Simitri
//
//  Created by John on 13/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ADrawingLayer.h"
#import "DrawingObject.h"

@interface ADrawingLayer ()

@property CGAffineTransform mathTransform;
@property ADrawer* drawer;
@property DrawingObject* drawingObject;

@end
