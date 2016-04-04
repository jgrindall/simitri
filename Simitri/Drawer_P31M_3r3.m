//
//  NewDrawer.m
//  Symmetry
//
//  Created by John on 18/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "Drawer_P31M_3r3.h"
#import "ADrawer_Protected.h"
#import "TransformUtils.h"
#import "GeomUtils.h"

@implementation Drawer_P31M_3r3
{
	float sideWidth;
	float triHeight;
	float midLength;
	float smallHeight;
}

- (TransformPair*) getMathTransformForIndex:(NSInteger) i withCentre:(CGPoint) centre atTime:(float)t{
	CGAffineTransform cg = CGAffineTransformIdentity;
	CATransform3D ca = CATransform3DIdentity;
	BOOL is3d = YES;
	if(i<=17){
		ca = [TransformUtils rotate3DAboutPoint:centre withAngle:2*t*M_PI/3];
	}
	else if(i<=24){
		ca = [TransformUtils reflectIn3DLineThrough:centre inDirection:0 atAngle:t*M_PI];
	}
	else if(i<=28){
		ca = [TransformUtils reflectIn3DLineThrough:centre inDirection:M_PI/3 atAngle:t*M_PI];
	}
	else if(i<=32){
		ca = [TransformUtils reflectIn3DLineThrough:centre inDirection:-M_PI/3 atAngle:t*M_PI];
	}
	return [[TransformPair alloc] initWithCA:ca withCG:cg is3d:is3d];
}

- (NSArray*) getMathTransformBasicCentres{
	NSMutableArray* centres = [NSMutableArray array];
	[centres addObject:[NSValue valueWithCGPoint:CGPointZero]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth, 0)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(2*sideWidth, 0)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(0, midLength)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth, midLength)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(2*sideWidth, midLength)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(0, 2*midLength)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth, 2*midLength)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(2*sideWidth, 2*midLength)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(0, 3*midLength)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth, 3*midLength)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(2*sideWidth, 3*midLength)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth/2, smallHeight)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(3*sideWidth/2, smallHeight)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth/2, triHeight)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(3*sideWidth/2, triHeight)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth/2, triHeight + midLength)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(3*sideWidth/2, triHeight + midLength)]];
	//horiz
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth/2, 0)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(3*sideWidth/2, 0)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(0, triHeight)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth, triHeight)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(2*sideWidth, triHeight)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth/2, 2*triHeight)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(3*sideWidth/2, 2*triHeight)]];
	//
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth/4, triHeight/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(3*sideWidth/4, 3*triHeight/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(5*sideWidth/4, triHeight/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(7*sideWidth/4, 3*triHeight/2)]];
	//
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth/4, 3*triHeight/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(3*sideWidth/4, triHeight/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(5*sideWidth/4, 3*triHeight/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(7*sideWidth/4, triHeight/2)]];
	
	
	return [centres copy];
}

- (NSArray*) getBasicMathMarkers{
	NSMutableArray* polys = [NSMutableArray array];
	[polys addObject:[AMathMarker getLineOfReflectionWithP0:CGPointZero withP1:CGPointMake(sideWidth/2, triHeight) withP3Angle:5*M_PI/6]];
	[polys addObject:[AMathMarker getRotOrder346CentrePolygonWithOrigin:CGPointMake(0, midLength) withP1:CGPointMake(0,0) andAngle:2*M_PI/3 andOrder:3 andLength:[AMathMarker getDefaultLength]]];
	[polys addObject:[AMathMarker getPartialRotCentrePolygonWithOrigin:CGPointMake(sideWidth/2, triHeight) withP1:CGPointZero andAngle:2*M_PI/3 andOrder:3 andLength:[AMathMarker getDefaultLength] withFrac:0.333]];
	[polys addObject:[AMathMarker getPartialRotCentrePolygonWithOrigin:CGPointZero withP1:CGPointMake(0, triHeight) andAngle:-M_PI/3 andOrder:3 andLength:[AMathMarker getDefaultLength]*0.58 withFrac:0.5]];
	
	return polys;
}

- (CGRect) getBasicRectangle{
	return CGRectMake(0, 0, sideWidth, 2*triHeight);
}

- (NSArray*) getTransformations{
	CGAffineTransform t0 = [TransformUtils reflectInLineWithAngle:M_PI/3 withC:0];
	CGAffineTransform t1 = [TransformUtils rotateAboutPoint:CGPointMake(0, midLength) angle:2*M_PI/3];
	CGAffineTransform t12 = CGAffineTransformConcat(t1, t1);
	CGAffineTransform t2 = [TransformUtils rotateAboutPoint:CGPointMake(sideWidth/2, midLength/2) angle:2*M_PI/3];
	CGAffineTransform t22 = CGAffineTransformConcat(t2, t2);
	CGAffineTransform ref = [TransformUtils reflectInHorizontalLineWithC:triHeight];
	CGAffineTransform move = [TransformUtils translateBy:CGPointMake(sideWidth, 0)];
	NSMutableArray* transforms = [NSMutableArray array];
	[GeomUtils addTransform:CGAffineTransformIdentity into:transforms];
	[GeomUtils addTransform:t0 into:transforms];
	[GeomUtils addCompTransform:t0 followedBy: t2 into:transforms];
	[GeomUtils addCompTransform:t0 followedBy: t22 into:transforms];
	[GeomUtils addTransform:t1 into:transforms];
	[GeomUtils addCompTransform:t1 followedBy: move into:transforms];
	[GeomUtils addCompTransform:t12 followedBy: move into:transforms];
	//
	[GeomUtils addCompTransform:[transforms[0] CGAffineTransformValue] followedBy:ref into:transforms];
	[GeomUtils addCompTransform:[transforms[1] CGAffineTransformValue] followedBy:ref into:transforms];
	[GeomUtils addCompTransform:[transforms[2] CGAffineTransformValue] followedBy:ref into:transforms];
	[GeomUtils addCompTransform:[transforms[3] CGAffineTransformValue] followedBy:ref into:transforms];
	[GeomUtils addCompTransform:[transforms[4] CGAffineTransformValue] followedBy:ref into:transforms];
	[GeomUtils addCompTransform:[transforms[5] CGAffineTransformValue] followedBy:ref into:transforms];
	[GeomUtils addCompTransform:[transforms[6] CGAffineTransformValue] followedBy:ref into:transforms];
	return [transforms copy];
}

- (NSArray*) getTheBasicPoints{
	float max = MAX(self.screenSize.width, self.screenSize.height);
	sideWidth = max/2;
	triHeight = sideWidth * sqrtf(3.0)/2;
	midLength = (2.0/3.0)*triHeight;
	smallHeight = (1.0/3.0)*triHeight;
	id p0 = [NSValue valueWithCGPoint:CGPointZero];
	id p1 = [NSValue valueWithCGPoint:CGPointMake(sideWidth/2, triHeight)];
	id p2 = [NSValue valueWithCGPoint:CGPointMake(0, midLength)];
	return [[NSArray alloc] initWithObjects:p0, p1, p2, nil];
}

@end
