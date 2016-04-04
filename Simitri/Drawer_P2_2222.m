
#import "Drawer_P2_2222.h"
#import "ADrawer_Protected.h"
#import "TransformUtils.h"
#import "DisplayUtils.h"
#import "AMathMarker.h"
#import "GeomUtils.h"

@implementation Drawer_P2_2222
{
	float sideWidth;
}

- (CGRect) getBasicRectangle{
	return CGRectMake(0, 0, sideWidth, sideWidth);
}

- (TransformPair*) getMathTransformForIndex:(NSInteger) i withCentre:(CGPoint) centre atTime:(float)t{
	CGAffineTransform cg = CGAffineTransformIdentity;
	CATransform3D ca = CATransform3DIdentity;
	ca = [TransformUtils rotate3DAboutPoint:centre withAngle:M_PI*t];
	return [[TransformPair alloc] initWithCA:ca withCG:cg is3d:YES];
}

- (NSArray*) getMathTransformBasicCentres{
	NSMutableArray* centres = [NSMutableArray array];
	[centres addObject:[NSValue valueWithCGPoint:CGPointZero]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth/2, 0)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth, 0)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(0, sideWidth/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth/2, sideWidth/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth, sideWidth/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(0, sideWidth)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth/2, sideWidth)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth, sideWidth)]];
	return [centres copy];
}

- (NSArray*) getBasicMathMarkers{
	NSMutableArray* polys = [NSMutableArray array];
	[polys addObject:[AMathMarker getRotOrder2CentrePolygonWithOrigin:CGPointMake(0, sideWidth/2) withStartAngle:-M_PI/2 andAngle:M_PI andRadius:[AMathMarker getDefaultRot2Radius]]];
	[polys addObject:[AMathMarker getRotOrder2CentrePolygonWithOrigin:CGPointMake(sideWidth/2, sideWidth/2) withStartAngle:-M_PI/4 andAngle:M_PI andRadius:[AMathMarker getDefaultRot2Radius]]];
	[polys addObject:[AMathMarker getRotOrder2CentrePolygonWithOrigin:CGPointMake(sideWidth/2, sideWidth) withStartAngle:M_PI andAngle:M_PI andRadius:[AMathMarker getDefaultRot2Radius]]];
	[polys addObject:[AMathMarker getRotOrder2CentrePolygonWithOrigin:CGPointMake(0, sideWidth) withStartAngle:M_PI/2 andAngle:-M_PI/2 andRadius:[AMathMarker getDefaultRot2Radius]]];
	[polys addObject:[AMathMarker getRotOrder2CentrePolygonWithOrigin:CGPointZero withStartAngle:M_PI/4 andAngle:-M_PI/4 andRadius:[AMathMarker getDefaultRot2Radius]]];
	return polys;
}

- (NSArray*) getTransformations{
	CGAffineTransform t0 = [TransformUtils rotateAboutPoint:CGPointMake(sideWidth/2, sideWidth/2) angle:M_PI];
	NSMutableArray* transforms = [NSMutableArray array];
	[GeomUtils addTransform:CGAffineTransformIdentity into:transforms];
	[GeomUtils addTransform:t0 into:transforms];
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
