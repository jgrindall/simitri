//
//  NewDrawer.m
//  Symmetry
//
//  Created by John on 18/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "Drawer_PG_xx.h"
#import "ADrawer_Protected.h"
#import "TransformUtils.h"
#import "GeomUtils.h"

@implementation Drawer_PG_xx
{
	float sideWidth;
	float sideHeight;
}

- (TransformPair*) getMathTransformForIndex:(NSInteger) i withCentre:(CGPoint) centre atTime:(float)t{
	CGAffineTransform cg = CGAffineTransformIdentity;
	CATransform3D ca = CATransform3DIdentity;
	BOOL is3d = NO;
	if(t < 0.5){
		cg = [TransformUtils translateBy:CGPointMake(0, -sideHeight*2*t)];
	}
	else{
		is3d = YES;
		ca = [TransformUtils reflectIn3DLineThrough:centre inDirection:M_PI/2 atAngle:(2*t - 1)*M_PI];
	}
	return [[TransformPair alloc] initWithCA:ca withCG:cg is3d:is3d];
}

- (NSArray*) getMathTransformBasicCentres{
	NSMutableArray* centres = [NSMutableArray array];

	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(0 , sideHeight/2 )]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth/2 , sideHeight/2 )]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth , sideHeight/2 )]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(0 , 3*sideHeight/2 )]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth/2 , 3*sideHeight/2 )]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth , 3*sideHeight/2 )]];
	return [centres copy];
}

- (NSArray*) getBasicMathMarkers{
	NSMutableArray* polys = [NSMutableArray array];
	[polys addObject:[AMathMarker getGlideRefWithOrigin:CGPointMake(0 , sideHeight/2 ) withP1:CGPointZero withMiddle:CGPointMake(sideWidth/2, sideHeight/2) withScale:0.7 withMove:YES]];
	[polys addObject:[AMathMarker getGlideRefWithOrigin:CGPointMake(sideWidth/2 , sideHeight/2 ) withP1:CGPointMake(sideWidth/2 , 0) withMiddle:CGPointMake(sideWidth/2, sideHeight/2) withScale:0.7 withMove:NO]];
	return polys;
}

- (CGRect) getBasicRectangle{
	return CGRectMake(0, 0, sideWidth, 2*sideHeight);
}

- (NSArray*) getTransformations{
	CGAffineTransform t0 = [TransformUtils reflectInVerticalLineWithA:sideWidth/2];
	CGAffineTransform t1 = [TransformUtils translateBy:CGPointMake(0, sideHeight)];
	NSMutableArray* transforms = [NSMutableArray array];
	[GeomUtils addTransform:CGAffineTransformIdentity into:transforms];
	[GeomUtils addCompTransform:t0 followedBy:t1 into:transforms];
	return [transforms copy];
}

- (NSArray*) getTheBasicPoints{
	float min = MIN(self.screenSize.width, self.screenSize.height);
	float max = MAX(self.screenSize.width, self.screenSize.height);
	sideWidth = min/4.0;
	sideHeight = max/5.0;
	id p0 = [NSValue valueWithCGPoint:CGPointZero];
	id p1 = [NSValue valueWithCGPoint:CGPointMake(sideWidth, 0)];
	id p2 = [NSValue valueWithCGPoint:CGPointMake(sideWidth, sideHeight)];
	id p3 = [NSValue valueWithCGPoint:CGPointMake(0,sideHeight)];
	return [[NSArray alloc] initWithObjects:p0, p1, p2, p3, nil];
}

@end
