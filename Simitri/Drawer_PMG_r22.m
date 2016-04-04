//
//  NewDrawer.m
//  Symmetry
//
//  Created by John on 18/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "Drawer_PMG_r22.h"
#import "ADrawer_Protected.h"
#import "TransformUtils.h"
#import "GeomUtils.h"

@implementation Drawer_PMG_r22
{
	float sideWidth;
	float sideHeight;
}

- (TransformPair*) getMathTransformForIndex:(NSInteger) i withCentre:(CGPoint) centre atTime:(float)t{
	CGAffineTransform cg = CGAffineTransformIdentity;
	CATransform3D ca = CATransform3DIdentity;
	if(i <= 5) {
		ca = [TransformUtils reflectIn3DLineThrough:centre inDirection:M_PI/2 atAngle:t*M_PI];
	}
	else{
		ca = [TransformUtils rotate3DAboutPoint:centre withAngle:M_PI*t];
	}
	return [[TransformPair alloc] initWithCA:ca withCG:cg is3d:YES];
}

- (NSArray*) getMathTransformBasicCentres{
	NSMutableArray* centres = [NSMutableArray array];
	
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(0, sideHeight/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth, sideHeight/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(2*sideWidth, sideHeight/2)]];
	
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(0, 3*sideHeight/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth, 3*sideHeight/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(2*sideWidth, 3*sideHeight/2)]];
	
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth/2, 0)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(3*sideWidth/2, 0)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth/2, sideHeight)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(3*sideWidth/2, sideHeight)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth/2, 2*sideHeight)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(3*sideWidth/2, 2*sideHeight)]];
	return [centres copy];
}


- (NSArray*) getBasicMathMarkers{
	NSMutableArray* polys = [NSMutableArray array];
	[polys addObject:[AMathMarker getLineOfReflectionWithP0:CGPointMake(sideWidth, 0) withP1:CGPointMake(sideWidth, sideHeight) withP3Angle:M_PI]];
	[polys addObject:[AMathMarker getLineOfReflectionWithP0:CGPointZero withP1:CGPointMake(0, sideHeight) withP3Angle:0]];
	[polys addObject:[AMathMarker getRotOrder2CentrePolygonWithOrigin:CGPointMake(sideWidth/2, 0) withStartAngle:0 andAngle:M_PI andRadius:[AMathMarker getDefaultRot2Radius]]];
	[polys addObject:[AMathMarker getRotOrder2CentrePolygonWithOrigin:CGPointMake(sideWidth/2, sideHeight) withStartAngle:0 andAngle:M_PI andRadius:[AMathMarker getDefaultRot2Radius]]];
	return polys;
}

- (CGRect) getBasicRectangle{
	return CGRectMake(0, 0, 2*sideWidth, 2*sideHeight);
}

- (NSArray*) getTransformations{
	CGAffineTransform t1 = [TransformUtils reflectInVerticalLineWithA:sideWidth];
	CGAffineTransform t3 = [TransformUtils rotateAboutPoint:CGPointMake(sideWidth/2, sideHeight) angle:M_PI];
	NSMutableArray* transforms = [NSMutableArray array];
	[GeomUtils addTransform:CGAffineTransformIdentity into:transforms];
	[GeomUtils addTransform:t1 into:transforms];
	[GeomUtils addTransform:t3 into:transforms];
	[GeomUtils addCompTransform:t3 followedBy:t1 into:transforms];
	return [transforms copy];
}

- (NSArray*) getTheBasicPoints{
	float min = MIN(self.screenSize.width, self.screenSize.height);
	float max = MAX(self.screenSize.width, self.screenSize.height);
	sideWidth = max/5.0;
	sideHeight = min/4.0;
	id p0 = [NSValue valueWithCGPoint:CGPointZero];
	id p1 = [NSValue valueWithCGPoint:CGPointMake(sideWidth, 0)];
	id p2 = [NSValue valueWithCGPoint:CGPointMake(sideWidth, sideHeight)];
	id p3 = [NSValue valueWithCGPoint:CGPointMake(0,sideHeight)];
	return [[NSArray alloc] initWithObjects:p0, p1, p2, p3, nil];
}

@end
