//
//  ADrawingLayer.h
//  Simitri
//
//  Created by John on 13/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawingObject.h"

@interface ADrawingLayer : UIView

- (void) load:(DrawingObject*) obj;
- (void) tick:(TransformPair*) t;
- (void) resetGeometry;
+ (float) getAlphaForAlphaLayer;
- (void) show:(BOOL)show;

@end
