//
//  ADrawingLayer.m
//  Simitri
//
//  Created by John on 13/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "ADrawingLayer_Protected.h"

@implementation ADrawingLayer

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
		self.mathTransform = CGAffineTransformIdentity;
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void) show:(BOOL)show{
	[self setHidden:!show];
}

+ (float) getAlphaForAlphaLayer{
	return 0.75;
}

- (void) load:(DrawingObject*) obj{
	if(self.drawingObject){
		[self.drawingObject clear];
		self.drawingObject = nil;
	}
	self.drawingObject = obj;
	self.drawer = obj.drawer;
}

- (void) resetGeometry{
	self.layer.transform = CATransform3DIdentity;
	self.mathTransform = CGAffineTransformIdentity;
	[self setNeedsDisplay];
}

- (void) tick:(TransformPair*) t{
	if(t.is3d){
		float w = self.bounds.size.width;
		float h = self.bounds.size.height;
		CATransform3D move = CATransform3DMakeTranslation(w/2.0, h/2.0, 0);
		CATransform3D moveBack = CATransform3DMakeTranslation(-w/2.0, -h/2.0, 0);
		self.layer.transform = CATransform3DConcat(CATransform3DConcat(move, t.ca3dTransform), moveBack);
	}
	else {
		self.mathTransform = t.affineTransform;
		[self setNeedsDisplay];
	}
}

- (void) dealloc{
	self.drawer = nil;
}

@end
