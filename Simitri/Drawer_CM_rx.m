//
//  NewDrawer.m
//  Symmetry
//
//  Created by John on 18/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "Drawer_CM_rx.h"
#import "ADrawer_Protected.h"
#import "TransformUtils.h"
#import "GeomUtils.h"

@implementation Drawer_CM_rx
{
	float sideWidth;
}

- (TransformPair*) getMathTransformForIndex:(NSInteger) i withCentre:(CGPoint) centre atTime:(float)t{
	CGAffineTransform cg = CGAffineTransformIdentity;
	CATransform3D ca = CATransform3DIdentity;
	BOOL is3d = NO;
	if(i <= 1) {
		if(t < 0.5){
			cg = [TransformUtils translateBy:CGPointMake((sideWidth/2)*2*t, -(sideWidth/2)*2*t)];
		}
		else{
			is3d = YES;
			ca = [TransformUtils reflectIn3DLineThrough:CGPointMake(centre.x, centre.y) inDirection:-M_PI/4 atAngle:M_PI*(2*t - 1)];
		}
	}
	else{
		is3d = YES;
		ca = [TransformUtils reflectIn3DLineThrough:centre inDirection:-M_PI/4 atAngle:t*M_PI];
	}
	return [[TransformPair alloc] initWithCA:ca withCG:cg is3d:is3d];
}

- (NSArray*) getMathTransformBasicCentres{
	NSMutableArray* centres = [NSMutableArray array];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth/4, sideWidth/4)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(3*sideWidth/4, 3*sideWidth/4)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth/2, sideWidth/2)]];
	return [centres copy];
}

- (NSArray*) getBasicMathMarkers{
	NSMutableArray* polys = [NSMutableArray array];
	[polys addObject:[AMathMarker getGlideRefWithOrigin:CGPointMake(sideWidth/4 , sideWidth/4 ) withP1:CGPointMake(sideWidth/2, 0) withMiddle:CGPointMake(sideWidth/4, sideWidth/4) withScale:0.7 withMove:NO]];
	[polys addObject:[AMathMarker getLineOfReflectionWithP0:CGPointMake(0, sideWidth ) withP1:CGPointMake(sideWidth, 0) withP3Angle:-3*M_PI/4]];
	return polys;
}

- (CGRect) getBasicRectangle{
	return CGRectMake(0, 0, sideWidth, sideWidth);
}

- (NSArray*) getTransformations{
	CGAffineTransform t0 = [TransformUtils reflectInLineWithAngle:-M_PI/4 withC:sideWidth];
	NSMutableArray* transforms = [NSMutableArray array];
	[GeomUtils addTransform:CGAffineTransformIdentity into:transforms];
	[GeomUtils addTransform:t0 into:transforms];
	return [transforms copy];
}

- (NSArray*) getTheBasicPoints{
	float min = MIN(self.screenSize.width, self.screenSize.height);
	sideWidth = min/3.0;
	id p0 = [NSValue valueWithCGPoint:CGPointZero];
	id p1 = [NSValue valueWithCGPoint:CGPointMake(sideWidth, 0)];
	id p2 = [NSValue valueWithCGPoint:CGPointMake(0, sideWidth)];
	return [[NSArray alloc] initWithObjects:p0, p1, p2, nil];
}

@end
