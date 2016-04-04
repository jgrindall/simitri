
#import "Drawer_P4_244.h"
#import "ADrawer_Protected.h"
#import "TransformUtils.h"
#import "DisplayUtils.h"
#import "AMathMarker.h"
#import "GeomUtils.h"

@implementation Drawer_P4_244
{
	float sideWidth;
}

- (CGRect) getBasicRectangle{
	return CGRectMake(0, 0, 2*sideWidth, 2*sideWidth);
}

- (TransformPair*) getMathTransformForIndex:(NSInteger) i withCentre:(CGPoint) centre atTime:(float)t{
	CGAffineTransform cg = CGAffineTransformIdentity;
	CATransform3D ca = CATransform3DIdentity;
	if(i <= 5) {
		ca = [TransformUtils rotate3DAboutPoint:centre withAngle:t*M_PI/2];
	}
	else{
		ca = [TransformUtils rotate3DAboutPoint:centre withAngle:t*M_PI];
	}
	return [[TransformPair alloc] initWithCA:ca withCG:cg is3d:YES];
}

- (NSArray*) getMathTransformBasicCentres{
	NSMutableArray* centres = [NSMutableArray array];
	[centres addObject:[NSValue valueWithCGPoint:CGPointZero]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(0, sideWidth)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(0, 2*sideWidth)]];
	
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth, 0)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth, sideWidth)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth, 2*sideWidth)]];
	
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(2*sideWidth, 0)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(2*sideWidth, sideWidth)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(2*sideWidth, 2*sideWidth)]];
	
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth/2, sideWidth/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(3*sideWidth/2, sideWidth/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth/2, 3*sideWidth/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(3*sideWidth/2, 3*sideWidth/2)]];
	return [centres copy];
}

- (NSArray*) getBasicMathMarkers{
	NSMutableArray* polys = [NSMutableArray array];
	[polys addObject:[AMathMarker getRotOrder346CentrePolygonWithOrigin:CGPointMake(0, sideWidth) withP1:CGPointZero andAngle:M_PI/2 andOrder:4 andLength:[AMathMarker getDefaultLength]]];
	[polys addObject:[AMathMarker getRotOrder2CentrePolygonWithOrigin:CGPointMake(sideWidth/2, sideWidth/2) withStartAngle:M_PI/4 andAngle:M_PI andRadius:[AMathMarker getDefaultRot2Radius]]];
	
	[polys addObject:[AMathMarker getPartialRotCentrePolygonWithOrigin:CGPointZero withP1:CGPointMake(sideWidth, 0) andAngle:M_PI/2 andOrder:4 andLength:[AMathMarker getDefaultLength] withFrac:0.5]];
	[polys addObject:[AMathMarker getPartialRotCentrePolygonWithOrigin:CGPointZero withP1:CGPointMake(0, sideWidth) andAngle:-M_PI/2 andOrder:4 andLength:[AMathMarker getDefaultLength] withFrac:0.5]];
	
	return polys;
}

- (NSArray*) getTransformations{
	CGAffineTransform t0 = [TransformUtils rotateAboutPoint:CGPointMake(sideWidth/2, sideWidth/2) angle:M_PI];
	CGAffineTransform t1 = [TransformUtils rotateAboutPoint:CGPointMake(sideWidth, sideWidth) angle:M_PI/2];
	CGAffineTransform t12 = CGAffineTransformConcat(t1, t1);
	CGAffineTransform t13 = CGAffineTransformConcat(t12, t1);
	NSMutableArray* transforms = [NSMutableArray array];
	[GeomUtils addTransform:CGAffineTransformIdentity into:transforms];
	[GeomUtils addTransform:t1 into:transforms];
	[GeomUtils addTransform:t12 into:transforms];
	[GeomUtils addTransform:t13 into:transforms];
	[GeomUtils addTransform:t0 into:transforms];
	[GeomUtils addCompTransform:t0 followedBy:t1 into:transforms];
	[GeomUtils addCompTransform:t0 followedBy:t12 into:transforms];
	[GeomUtils addCompTransform:t0 followedBy:t13 into:transforms];
	return transforms;
}

- (NSArray*) getTheBasicPoints{
	float max = MAX(self.screenSize.width, self.screenSize.height);
	sideWidth = max/4.0;
	id p0 = [NSValue valueWithCGPoint:CGPointZero];
	id p1 = [NSValue valueWithCGPoint:CGPointMake(sideWidth, sideWidth)];
	id p2 = [NSValue valueWithCGPoint:CGPointMake(0, sideWidth)];
	return [[NSArray alloc] initWithObjects:p0, p1, p2, nil];
}

@end
