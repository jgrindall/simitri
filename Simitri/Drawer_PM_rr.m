//
//  NewDrawer.m
//  Symmetry
//
//  Created by John on 18/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "Drawer_PM_rr.h"
#import "ADrawer_Protected.h"
#import "TransformUtils.h"
#import "GeomUtils.h"

@implementation Drawer_PM_rr
{
	float sideWidth;
	float sideHeight;
}

- (TransformPair*) getMathTransformForIndex:(NSInteger) i withCentre:(CGPoint) centre atTime:(float)t{
	CGAffineTransform cg = CGAffineTransformIdentity;
	CATransform3D ca = CATransform3DIdentity;
	BOOL is3d = NO;
	if(i <= 2) {
		is3d = YES;
		ca = [TransformUtils reflectIn3DLineThrough:centre inDirection:M_PI/2 atAngle:t*M_PI];
	}
	else{
		cg =  [TransformUtils translateBy:CGPointMake(0, -sideHeight*t)];
	}
	return [[TransformPair alloc] initWithCA:ca withCG:cg is3d:is3d];
}

- (NSArray*) getMathTransformBasicCentres{
	NSMutableArray* centres = [NSMutableArray array];
	//rot
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(0, sideHeight/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth, sideHeight/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(2*sideWidth, sideHeight/2)]];
	
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth/2, sideHeight/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(3*sideWidth/2, sideHeight/2)]];
	return [centres copy];
}


- (NSArray*) getBasicMathMarkers{
	NSMutableArray* polys = [NSMutableArray array];
	[polys addObject:[AMathMarker getTranslationWithOrigin:CGPointMake(sideWidth/2, sideHeight/2) withP1:CGPointMake(sideWidth/2, 0) withMiddle:CGPointMake(sideWidth/2, sideHeight/2) withScale:0.7 withMove:NO]];
	[polys addObject:[AMathMarker getLineOfReflectionWithP0:CGPointZero withP1:CGPointMake(0, sideHeight) withP3Angle:0]];
	[polys addObject:[AMathMarker getLineOfReflectionWithP0:CGPointMake(sideWidth, 0) withP1:CGPointMake(sideWidth, sideHeight) withP3Angle:M_PI]];
	return polys;
}

- (CGRect) getBasicRectangle{
	return CGRectMake(0, 0, 2*sideWidth, sideHeight);
}

- (NSArray*) getTransformations{
	CGAffineTransform t0 = [TransformUtils reflectInVerticalLineWithA:sideWidth];
	NSMutableArray* transforms = [NSMutableArray array];
	[GeomUtils addTransform:CGAffineTransformIdentity into:transforms];
	[GeomUtils addTransform:t0 into:transforms];
	return [transforms copy];
}

- (NSArray*) getTheBasicPoints{
	float min = MIN(self.screenSize.width, self.screenSize.height);
	float max = MAX(self.screenSize.width, self.screenSize.height);
	sideWidth = min/4.0;
	sideHeight = max/6.0;
	id p0 = [NSValue valueWithCGPoint:CGPointZero];
	id p1 = [NSValue valueWithCGPoint:CGPointMake(sideWidth, 0)];
	id p2 = [NSValue valueWithCGPoint:CGPointMake(sideWidth, sideHeight)];
	id p3 = [NSValue valueWithCGPoint:CGPointMake(0,sideHeight)];
	return [[NSArray alloc] initWithObjects:p0, p1, p2, p3, nil];
}

@end
