//
//  NewDrawer.m
//  Symmetry
//
//  Created by John on 18/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "Drawer_P3M1_r333.h"
#import "ADrawer_Protected.h"
#import "TransformUtils.h"
#import "DisplayUtils.h"
#import "AMathMarker.h"
#import "GeomUtils.h"

@implementation Drawer_P3M1_r333
{
	float sideLength;
	float triHeight;
}

- (CGRect) getBasicRectangle{
	return CGRectMake(0, 0, sideLength*3, triHeight*2);
}

- (TransformPair*) getMathTransformForIndex:(NSInteger) i withCentre:(CGPoint) centre atTime:(float)t{
	CGAffineTransform cg = CGAffineTransformIdentity;
	CATransform3D ca = CATransform3DIdentity;
	BOOL is3d = YES;
	if(i <= 9) {
		ca = [TransformUtils reflectIn3DLineThrough:centre inDirection:0 atAngle:t*M_PI];
	}
	else if(i <= 15){
		ca = [TransformUtils reflectIn3DLineThrough:centre inDirection:M_PI/3 atAngle:t*M_PI];
	}
	else {
		ca = [TransformUtils reflectIn3DLineThrough:centre inDirection:-M_PI/3 atAngle:t*M_PI];
	}
	return [[TransformPair alloc] initWithCA:ca withCG:cg is3d:is3d];
}

- (NSArray*) getMathTransformBasicCentres{
	NSMutableArray* centres = [NSMutableArray array];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideLength/2, 0)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(3*sideLength/2, 0)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(5*sideLength/2, 0)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideLength/2, 2*triHeight)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(3*sideLength/2, 2*triHeight)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(5*sideLength/2, 2*triHeight)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(0, triHeight)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideLength, triHeight)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(2*sideLength, triHeight)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(3*sideLength, triHeight)]];
	
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideLength/4, triHeight/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(3*sideLength/4, 3*triHeight/2)]];
	
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(5*sideLength/4, triHeight/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(7*sideLength/4, 3*triHeight/2)]];
	
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(9*sideLength/4, triHeight/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(11*sideLength/4, 3*triHeight/2)]];
	
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideLength/4, 3*triHeight/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(3*sideLength/4, triHeight/2)]];
	
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(5*sideLength/4, 3*triHeight/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(7*sideLength/4, triHeight/2)]];
	
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(9*sideLength/4, 3*triHeight/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(11*sideLength/4, triHeight/2)]];
	
	return [centres copy];
}

- (NSArray*) getBasicMathMarkers{
	NSMutableArray* polys = [NSMutableArray array];
	[polys addObject:[AMathMarker getLineOfReflectionWithP0:CGPointZero withP1:CGPointMake(sideLength, 0) withP3Angle:M_PI/2]];
	[polys addObject:[AMathMarker getLineOfReflectionWithP0:CGPointZero withP1:CGPointMake(sideLength/2, triHeight) withP3Angle:-M_PI/6]];
	[polys addObject:[AMathMarker getLineOfReflectionWithP0:CGPointMake(sideLength/2, triHeight) withP1:CGPointMake(sideLength, 0) withP3Angle:7*M_PI/6]];
	return polys;
}

- (NSArray*) getTransformations{
	NSMutableArray* transforms = [NSMutableArray array];
	[GeomUtils addTransform:CGAffineTransformIdentity into:transforms];
	CGAffineTransform t0 = [TransformUtils reflectInLineWithAngle:M_PI/3 withC:0];
	CGAffineTransform t1 = [TransformUtils reflectInLineWithAngle:M_PI/3 withC:-2*triHeight];
	CGAffineTransform t2 = [TransformUtils reflectInLineWithAngle:M_PI/3 withC:-4*triHeight];
	CGAffineTransform s0 = [TransformUtils reflectInLineWithAngle:-M_PI/3 withC:2*triHeight];
	CGAffineTransform s1 = [TransformUtils reflectInLineWithAngle:-M_PI/3 withC:4*triHeight];
	CGAffineTransform s2 = [TransformUtils reflectInLineWithAngle:-M_PI/3 withC:6*triHeight];
	CGAffineTransform r = [TransformUtils reflectInHorizontalLineWithC:triHeight];
	[GeomUtils addTransform:t0 into:transforms];
	[GeomUtils addTransform:s0 into:transforms];
	[GeomUtils addTransform:r into:transforms];
	[GeomUtils addTransform:s1 into:transforms];
	[GeomUtils addCompTransform:s0 followedBy:r into:transforms];
	[GeomUtils addCompTransform:t0 followedBy:r into:transforms];
	[GeomUtils addCompTransform:s0 followedBy:t1 into:transforms];
	[GeomUtils addCompTransform:s0 followedBy:s1 into:transforms];
	[GeomUtils addCompTransforms:t0 followedBy:s0 followedBy:s1 into:transforms];
	[GeomUtils addCompTransforms:s0 followedBy:t1 followedBy:s1 into:transforms];
	[GeomUtils addCompTransform:s1 followedBy:r into:transforms];
	[GeomUtils addCompTransform:s1 followedBy:t2 into:transforms];
	[GeomUtils addCompTransforms:s1 followedBy:r followedBy:s2 into:transforms];
	return transforms;
}

- (NSArray*) getTheBasicPoints{
	sideLength = MIN(self.screenSize.width, self.screenSize.height)/4;
	triHeight = sideLength * sqrtf(3)/2;
	id p0 = [NSValue valueWithCGPoint:CGPointZero];
	id p1 = [NSValue valueWithCGPoint:CGPointMake(sideLength, 0)];
	id p2 = [NSValue valueWithCGPoint:CGPointMake(sideLength/2, triHeight)];
	return [[NSArray alloc] initWithObjects:p0, p1, p2, nil];
}

@end
