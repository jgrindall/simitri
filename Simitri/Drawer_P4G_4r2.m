
#import "Drawer_P4G_4r2.h"
#import "ADrawer_Protected.h"
#import "TransformUtils.h"
#import "DisplayUtils.h"
#import "AMathMarker.h"
#import "GeomUtils.h"

@implementation Drawer_P4G_4r2
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
	if(i <= 1) {
		ca = [TransformUtils reflectIn3DLineThrough:centre inDirection:M_PI/4 atAngle:t*M_PI];
	}
	else if(i <= 3){
		ca = [TransformUtils reflectIn3DLineThrough:centre inDirection:-M_PI/4 atAngle:t*M_PI];
	}
	else{
		ca = [TransformUtils rotate3DAboutPoint:centre withAngle:t*M_PI/2];
	}
	return [[TransformPair alloc] initWithCA:ca withCG:cg is3d:is3d];
}

- (NSArray*) getMathTransformBasicCentres{
	NSMutableArray* centres = [NSMutableArray array];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth/2, sideWidth/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(3*sideWidth/2, 3*sideWidth/2)]];
	
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(3*sideWidth/2, sideWidth/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth/2, 3*sideWidth/2)]];
	
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth, 0)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth, 2*sideWidth)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(0, sideWidth)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(2*sideWidth, sideWidth)]];
	
	return [centres copy];
}

- (NSArray*) getBasicMathMarkers{
	NSMutableArray* polys = [NSMutableArray array];
	[polys addObject:[AMathMarker getLineOfReflectionWithP0:CGPointZero withP1:CGPointMake(sideWidth, sideWidth) withP3Angle:3*M_PI/4]];
	[polys addObject:[AMathMarker getRotOrder346CentrePolygonWithOrigin:CGPointMake(0, sideWidth) withP1:CGPointZero andAngle:M_PI/2 andOrder:4 andLength:[AMathMarker getDefaultLength]]];
	return polys;
}

- (NSArray*) getTransformations{
	CGAffineTransform t0 = [TransformUtils reflectInLineWithAngle:M_PI/4 withC:0];
	CGAffineTransform t1 = [TransformUtils reflectInLineWithAngle:-M_PI/4 withC:2*sideWidth];
	CGAffineTransform t2 = [TransformUtils rotateAboutPoint:CGPointMake(0, sideWidth) angle:M_PI/2];
	NSMutableArray* transforms = [NSMutableArray array];
	[GeomUtils addTransform:CGAffineTransformIdentity into:transforms];
	[GeomUtils addTransform:t0 into:transforms];
	[GeomUtils addTransform:t1 into:transforms];
	[GeomUtils addTransform:t2 into:transforms];
	[GeomUtils addCompTransform:t2 followedBy:t1 into:transforms];
	[GeomUtils addCompTransform:t0 followedBy:t1 into:transforms];
	[GeomUtils addCompTransform:t2 followedBy:t0 into:transforms];
	[GeomUtils addCompTransforms:t2 followedBy:t0 followedBy:t1 into:transforms];
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
