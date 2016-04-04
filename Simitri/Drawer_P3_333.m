
#import "Drawer_P3_333.h"
#import "ADrawer_Protected.h"
#import "TransformUtils.h"
#import "DisplayUtils.h"
#import "AMathMarker.h"
#import "GeomUtils.h"

@implementation Drawer_P3_333
{
	float sideLength;
	float triHeight;
}

- (CGRect) getBasicRectangle{
	return CGRectMake(0, 0, 3*sideLength, 2*triHeight);
}

- (TransformPair*) getMathTransformForIndex:(NSInteger) i withCentre:(CGPoint) centre atTime:(float)t{
	CGAffineTransform cg = CGAffineTransformIdentity;
	CATransform3D ca = CATransform3DIdentity;
	ca = [TransformUtils rotate3DAboutPoint:centre withAngle:2*t*M_PI/3];
	return [[TransformPair alloc] initWithCA:ca withCG:cg is3d:YES];
}

- (NSArray*) getMathTransformBasicCentres{
	NSMutableArray* centres = [NSMutableArray array];
	[centres addObject:[NSValue valueWithCGPoint:CGPointZero]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(0, 2*triHeight)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(3*sideLength/2, triHeight)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(3*sideLength, 0)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(3*sideLength, 2*triHeight)]];
	
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideLength/2, triHeight)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(2*sideLength, 0)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(2*sideLength, 2*triHeight)]];
	
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideLength, 0)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideLength, 2*triHeight)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(5*sideLength/2, triHeight)]];
	return [centres copy];
}

- (NSArray*) getBasicMathMarkers{
	NSMutableArray* polys = [NSMutableArray array];
	[polys addObject:[AMathMarker getPartialRotCentrePolygonWithOrigin:CGPointZero withP1:CGPointMake(sideLength/2, triHeight) andAngle:2*M_PI/3 andOrder:3 andLength:[AMathMarker getDefaultLength] withFrac:0.5]];
	[polys addObject:[AMathMarker getPartialRotCentrePolygonWithOrigin:CGPointMake(0, 2*triHeight) withP1:CGPointMake(sideLength/2, triHeight) andAngle:-2*M_PI/3 andOrder:3 andLength:[AMathMarker getDefaultLength] withFrac:0.5]];
	[polys addObject:[AMathMarker getRotOrder346CentrePolygonWithOrigin:CGPointMake(sideLength/2, triHeight) withP1:CGPointMake(0, 2*triHeight) andAngle:2*M_PI/3 andOrder:3 andLength:[AMathMarker getDefaultLength]]];
	[polys addObject:[AMathMarker getRotOrder346CentrePolygonWithOrigin:CGPointMake(-sideLength/2, triHeight) withP1:CGPointZero andAngle:2*M_PI/3 andOrder:3 andLength:[AMathMarker getDefaultLength]]];
	return polys;
}

- (NSArray*) getTransformations{
	CGAffineTransform t0 = [TransformUtils rotateAboutPoint:CGPointMake(sideLength/2, triHeight) angle:2*M_PI/3];
	CGAffineTransform t1 = [TransformUtils rotateAboutPoint:CGPointMake(3*sideLength/2, triHeight) angle:2*M_PI/3];
	CGAffineTransform t2 = [TransformUtils translateBy:CGPointMake(3*sideLength/2, -triHeight)];
	CGAffineTransform t3 = [TransformUtils translateBy:CGPointMake(3*sideLength/2, triHeight)];
	CGAffineTransform t4 = [TransformUtils translateBy:CGPointMake(3*sideLength, 0)];
	NSMutableArray* transforms = [NSMutableArray array];
	[GeomUtils addTransform:CGAffineTransformIdentity into:transforms];
	[GeomUtils addTransform:t0 into:transforms];
	[GeomUtils addCompTransform:t0 followedBy:t0 into:transforms];
	[GeomUtils addCompTransform:t0 followedBy:t1 into:transforms];
	[GeomUtils addCompTransform:t2 followedBy:t1 into:transforms];
	[GeomUtils addTransform:t2 into:transforms];
	[GeomUtils addTransform:t3 into:transforms];
	[GeomUtils addTransform:t4 into:transforms];
	return transforms;
}

- (NSArray*) getTheBasicPoints{
	float min = MIN(self.screenSize.width, self.screenSize.height);
	sideLength = min/4.0;
	triHeight = sideLength * sqrtf(3.0)/2;
	id p0 = [NSValue valueWithCGPoint:CGPointZero];
	id p1 = [NSValue valueWithCGPoint:CGPointMake(sideLength/2, triHeight)];
	id p2 = [NSValue valueWithCGPoint:CGPointMake(0, 2*triHeight)];
	id p3 = [NSValue valueWithCGPoint:CGPointMake(-sideLength/2, triHeight)];
	return [[NSArray alloc] initWithObjects:p0, p1, p2, p3, nil];
}

@end
