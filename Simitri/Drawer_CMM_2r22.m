#import "Drawer_CMM_2r22.h"
#import "ADrawer_Protected.h"
#import "TransformUtils.h"
#import "DisplayUtils.h"
#import "AMathMarker.h"
#import "GeomUtils.h"

@implementation Drawer_CMM_2r22
{
	float sideLength;
}

- (CGRect) getBasicRectangle{
	return CGRectMake(0, 0, sideLength*2, sideLength*2);
}

- (TransformPair*) getMathTransformForIndex:(NSInteger) i withCentre:(CGPoint) centre atTime:(float)t{
	CGAffineTransform cg = CGAffineTransformIdentity;
	CATransform3D ca = CATransform3DIdentity;
	BOOL is3d = YES;
	if(i <= 3) {
		ca = [TransformUtils rotate3DAboutPoint:centre withAngle:t*M_PI];
	}
	else if(i <= 9){
		ca = [TransformUtils reflectIn3DLineThrough:centre inDirection:M_PI/2 atAngle:t*M_PI];
	}
	else{
		ca = [TransformUtils reflectIn3DLineThrough:centre inDirection:0 atAngle:t*M_PI];
	}
	return [[TransformPair alloc] initWithCA:ca withCG:cg is3d:is3d];
}

- (NSArray*) getMathTransformBasicCentres{
	NSMutableArray* centres = [NSMutableArray array];
	//rot
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideLength/2, sideLength/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(1.5*sideLength, sideLength/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideLength/2, 1.5*sideLength)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(1.5*sideLength, 1.5*sideLength)]];
	// ref1
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(0, sideLength/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideLength, sideLength/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(2*sideLength, sideLength/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(0, 3*sideLength/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideLength, 3*sideLength/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(2*sideLength, 3*sideLength/2)]];
	//ref2
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideLength/2, 0)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideLength/2, sideLength)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideLength/2, 2*sideLength)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(3*sideLength/2, 0)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(3*sideLength/2, sideLength)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(3*sideLength/2, 2*sideLength)]];
	
	return [centres copy];
}

- (NSArray*) getBasicMathMarkers{
	NSMutableArray* polys = [NSMutableArray array];
	CGPoint c0 = CGPointMake(sideLength/2, sideLength/2);
	[polys addObject:[AMathMarker getRotOrder2CentrePolygonWithOrigin:c0 withStartAngle:M_PI/4 andAngle:M_PI andRadius:[AMathMarker getDefaultRot2Radius]] ];
	[polys addObject:[AMathMarker getLineOfReflectionWithP0:CGPointZero withP1:CGPointMake(0, sideLength) withP3Angle:0]];
	[polys addObject:[AMathMarker getLineOfReflectionWithP0:CGPointMake(0, sideLength) withP1:CGPointMake(sideLength, sideLength) withP3Angle:-M_PI/2]];
	return polys;
}

- (NSArray*) getTransformations{
	CGPoint origin0 = CGPointMake(sideLength/2, sideLength/2);
	CGAffineTransform r0 = [TransformUtils rotateAboutPoint:origin0 angle:M_PI];
	CGAffineTransform ref0 = [TransformUtils reflectInVerticalLineWithA:sideLength];
	CGAffineTransform ref1 = [TransformUtils reflectInHorizontalLineWithC:sideLength];
	NSMutableArray* transforms = [NSMutableArray array];
	[GeomUtils addTransform:CGAffineTransformIdentity into:transforms];
	[GeomUtils addTransform:r0 into:transforms];
	[GeomUtils addTransform:ref0 into:transforms];
	[GeomUtils addCompTransform:r0 followedBy:ref0 into:transforms];
	[GeomUtils addTransform:ref1 into:transforms];
	[GeomUtils addCompTransform:r0 followedBy:ref1 into:transforms];
	[GeomUtils addCompTransform:ref0 followedBy:ref1 into:transforms];
	[GeomUtils addCompTransforms:r0 followedBy:ref0 followedBy:ref1 into:transforms];
	return transforms;
}

- (NSArray*) getTheBasicPoints{
	sideLength = MIN(self.screenSize.width, self.screenSize.height)/4;
	id p0 = [NSValue valueWithCGPoint:CGPointZero];
	id p1 = [NSValue valueWithCGPoint:CGPointMake(sideLength, sideLength)];
	id p2 = [NSValue valueWithCGPoint:CGPointMake(0, sideLength)];
	return [[NSArray alloc] initWithObjects:p0, p1, p2, nil];
}

@end
