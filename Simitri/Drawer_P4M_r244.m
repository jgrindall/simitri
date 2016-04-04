
#import "Drawer_P4M_r244.h"
#import "ADrawer_Protected.h"
#import "TransformUtils.h"
#import "DisplayUtils.h"
#import "AMathMarker.h"
#import "GeomUtils.h"

@implementation Drawer_P4M_r244
{
	float sideWidth;
}

- (CGRect) getBasicRectangle{
	return CGRectMake(0, 0, 2*sideWidth, 2*sideWidth);
}

- (TransformPair*) getMathTransformForIndex:(NSInteger) i withCentre:(CGPoint) centre atTime:(float)t{
	CGAffineTransform cg = CGAffineTransformIdentity;
	CATransform3D ca = CATransform3DIdentity;
	BOOL is3d = YES;
	if(i <= 5) {
		ca = [TransformUtils reflectIn3DLineThrough:centre inDirection:0 atAngle:t*M_PI];
	}
	else if(i <= 11){
		ca = [TransformUtils reflectIn3DLineThrough:centre inDirection:M_PI/2 atAngle:t*M_PI];
	}
	else if(i <= 13){
		ca = [TransformUtils reflectIn3DLineThrough:centre inDirection:M_PI/4 atAngle:t*M_PI];
	}
	else {
		ca = [TransformUtils reflectIn3DLineThrough:centre inDirection:-M_PI/4 atAngle:t*M_PI];
	}
	return [[TransformPair alloc] initWithCA:ca withCG:cg is3d:is3d];
}

- (NSArray*) getMathTransformBasicCentres{
	NSMutableArray* centres = [NSMutableArray array];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth/2, 0)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(3*sideWidth/2, 0)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth/2, sideWidth)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(3*sideWidth/2, sideWidth)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth/2, 2*sideWidth)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(3*sideWidth/2, 2*sideWidth)]];
	
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(0, sideWidth/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth, sideWidth/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(2*sideWidth, sideWidth/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(0, 3*sideWidth/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth, 3*sideWidth/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(2*sideWidth, 3*sideWidth/2)]];
	
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth/2, sideWidth/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(3*sideWidth/2, 3*sideWidth/2)]];
	
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(3*sideWidth/2, sideWidth/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth/2, 3*sideWidth/2)]];
	
	return [centres copy];
}

- (NSArray*) getBasicMathMarkers{
	NSMutableArray* polys = [NSMutableArray array];
	[polys addObject:[AMathMarker getLineOfReflectionWithP0:CGPointZero withP1:CGPointMake(sideWidth, sideWidth) withP3Angle:3*M_PI/4]];
	[polys addObject:[AMathMarker getLineOfReflectionWithP0:CGPointZero withP1:CGPointMake(0, sideWidth) withP3Angle:0]];
	[polys addObject:[AMathMarker getLineOfReflectionWithP0:CGPointMake(0, sideWidth) withP1:CGPointMake(sideWidth, sideWidth) withP3Angle:-M_PI/2]];
	return polys;
}

- (NSArray*) getTransformations{
	CGAffineTransform t0 = [TransformUtils reflectInLineWithAngle:M_PI/4 withC:0];
	CGAffineTransform t1 = [TransformUtils reflectInLineWithAngle:-M_PI/4 withC:2*sideWidth];
	CGAffineTransform t2 = [TransformUtils reflectInHorizontalLineWithC:sideWidth];
	CGAffineTransform t3 = [TransformUtils reflectInVerticalLineWithA:sideWidth];
	NSMutableArray* transforms = [NSMutableArray array];
	[GeomUtils addTransform:CGAffineTransformIdentity into:transforms];
	[GeomUtils addTransform:t0 into:transforms];
	[GeomUtils addTransform:t1 into:transforms];
	[GeomUtils addTransform:t2 into:transforms];
	[GeomUtils addTransform:t3 into:transforms];
	[GeomUtils addCompTransform:t0 followedBy:t3 into:transforms];
	[GeomUtils addCompTransform:t1 followedBy:t0 into:transforms];
	[GeomUtils addCompTransform:t2 followedBy:t1 into:transforms];
	return transforms;
}

- (NSArray*) getTheBasicPoints{
	float min = MIN(self.screenSize.width, self.screenSize.height);
	sideWidth = min/4.0;
	id p0 = [NSValue valueWithCGPoint:CGPointZero];
	id p1 = [NSValue valueWithCGPoint:CGPointMake(sideWidth, sideWidth)];
	id p2 = [NSValue valueWithCGPoint:CGPointMake(0, sideWidth)];
	return [[NSArray alloc] initWithObjects:p0, p1, p2, nil];
}

@end
