//
//  MarkerImage.m
//  Simitri
//
//  Created by John on 15/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "MarkerImage.h"
#import "Appearance.h"
#import "LayoutConsts.h"

@interface MarkerImage()

@property AMathMarker* marker;
@property NSArray* transforms;

@end

@implementation MarkerImage

- (id) initWithMarker:(AMathMarker*) m withTransforms:(NSArray*) transforms{
	self = [super init];
	if(self){
		self.marker = m;
		self.transforms = transforms;
		self.backgroundColor = [UIColor whiteColor];
	}
	return self;
}

- (void) drawRect:(CGRect)rect{
	CGMutablePathRef paths = CGPathCreateMutable();
	CGContextRef ref = UIGraphicsGetCurrentContext();
	UIBezierPath* path = self.marker.path;
	UIColor * clr = self.marker.color;
	if(ref){
		for (id transObj in self.transforms) {
			CGAffineTransform t = [transObj CGAffineTransformValue];
			CGPathAddPath(paths, &t, path.CGPath);
		}
		CGContextAddPath(ref, paths);
		CGContextSetFillColorWithColor(ref, clr.CGColor);
		CGContextFillPath(ref);
	}
	CGPathRelease(paths);
}

@end
