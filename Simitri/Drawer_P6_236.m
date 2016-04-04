//
//  NewDrawer.m
//  Symmetry
//
//  Created by John on 18/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "Drawer_P6_236.h"
#import "ADrawer_Protected.h"
#import "TransformUtils.h"
#import "DisplayUtils.h"
#import "AMathMarker.h"
#import "GeomUtils.h"

@implementation Drawer_P6_236
{
	float sideLength;
}

- (CGRect) getBasicRectangle{
	return CGRectMake(0, 0, sideLength*3, sideLength*sqrtf(3.0));
}

- (TransformPair*) getMathTransformForIndex:(NSInteger) i withCentre:(CGPoint) centre atTime:(float)t{
	CGAffineTransform cg = CGAffineTransformIdentity;
	CATransform3D ca = CATransform3DIdentity;
	if(i <= 2) {
		ca = [TransformUtils rotate3DAboutPoint:centre withAngle:t * M_PI/3];
	}
	else if(i <= 10){
		ca = [TransformUtils rotate3DAboutPoint:centre withAngle:2 * t * M_PI/3];
	}
	else{
		ca = [TransformUtils rotate3DAboutPoint:centre withAngle:t * M_PI];
	}
	return [[TransformPair alloc] initWithCA:ca withCG:cg is3d:YES];
}

- (NSArray*) getMathTransformBasicCentres{
	NSMutableArray* centres = [NSMutableArray array];
	// 6
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(0, self.basicRect.size.height/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(2*sideLength, 0)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(2*sideLength, self.basicRect.size.height)]];
	// 3
	[centres addObject:[NSValue valueWithCGPoint:CGPointZero]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideLength, 0)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(3*sideLength, 0)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(1.5*sideLength, self.basicRect.size.height/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(2.5*sideLength, self.basicRect.size.height/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(0, self.basicRect.size.height)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideLength, self.basicRect.size.height)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(3*sideLength, self.basicRect.size.height)]];
	// 2
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(0.5*sideLength, 0)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(0.5*sideLength, self.basicRect.size.height)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(1.25*sideLength, self.basicRect.size.height/4)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(1.25*sideLength, 3*self.basicRect.size.height/4)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(2*sideLength, self.basicRect.size.height/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(2.75*sideLength, self.basicRect.size.height/4)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(2.75*sideLength, 3*self.basicRect.size.height/4)]];
	return [centres copy];
}

- (NSArray*) getBasicMathMarkers{
	NSMutableArray* polys = [NSMutableArray array];
	CGPoint c0 = [self.basicPoints[0] CGPointValue];
	CGPoint c1 = [self.basicPoints[1] CGPointValue];
	CGPoint c2 = [self.basicPoints[2] CGPointValue];
	[polys addObject:[AMathMarker getRotOrder346CentrePolygonWithOrigin:c2 withP1:c0 andAngle:M_PI/3 andOrder:6 andLength:[AMathMarker getDefaultLength]]];
	[polys addObject:[AMathMarker getPartialRotCentrePolygonWithOrigin:c0 withP1:c1 andAngle:2*M_PI/3 andOrder:3 andLength:[AMathMarker getDefaultLength] withFrac:0.5]];
	[polys addObject:[AMathMarker getPartialRotCentrePolygonWithOrigin:c1 withP1:c0 andAngle:-2*M_PI/3 andOrder:3 andLength:[AMathMarker getDefaultLength] withFrac:0.5]];
	
	float midX = (c0.x + c1.x)/2.0;
	float midY = (c0.y + c1.y)/2.0;
	CGPoint mid01 = CGPointMake(midX, midY);
	[polys addObject:[AMathMarker getRotOrder2CentrePolygonWithOrigin:mid01 withStartAngle:0 andAngle:M_PI andRadius:[AMathMarker getDefaultRot2Radius]]];
	return polys;
}

- (NSArray*) getTransformations{
	CGPoint origin0 = [self.basicPoints[2]CGPointValue];
	CGPoint origin1 = CGPointMake(origin0.x + sideLength, origin0.y);
	CGPoint origin2 = CGPointMake(origin1.x + sideLength, origin1.y);
	CGAffineTransform t0 = [TransformUtils rotateAboutPoint:origin0 angle:M_PI/3];
	CGAffineTransform t02 = CGAffineTransformConcat(t0, t0);
	CGAffineTransform t03 = CGAffineTransformConcat(t02, t0);
	CGAffineTransform t04 = CGAffineTransformConcat(t03, t0);
	CGAffineTransform t05 = CGAffineTransformConcat(t04, t0);
	
	CGAffineTransform t1 = [TransformUtils rotateAboutPoint:origin1 angle:2*M_PI/3];
	CGAffineTransform t12 = CGAffineTransformConcat(t1, t1);
	
	CGAffineTransform t2 = [TransformUtils rotateAboutPoint:origin2 angle:2*M_PI/3];
	CGAffineTransform t22 = CGAffineTransformConcat(t2, t2);
	
	NSMutableArray* transforms = [NSMutableArray array];
	[GeomUtils addTransform:CGAffineTransformIdentity into:transforms];
	[GeomUtils addTransform:t0 into:transforms];
	[GeomUtils addTransform:t02 into:transforms];
	[GeomUtils addTransform:t03 into:transforms];
	[GeomUtils addTransform:t04 into:transforms];
	[GeomUtils addTransform:t05 into:transforms];
	
	[GeomUtils addCompTransform:t0 followedBy:t1 into:transforms];
	[GeomUtils addCompTransform:t0 followedBy:t12 into:transforms];
	
	[GeomUtils addCompTransform:t02 followedBy:t1 into:transforms];
	[GeomUtils addCompTransform:t02 followedBy:t12 into:transforms];
	
	[GeomUtils addCompTransforms:t0 followedBy:t1 followedBy:t2 into:transforms];
	[GeomUtils addCompTransforms:t0 followedBy:t1 followedBy:t22 into:transforms];

	[GeomUtils addCompTransforms:t02 followedBy:t12 followedBy:t2 into:transforms];
	[GeomUtils addCompTransforms:t02 followedBy:t12 followedBy:t22 into:transforms];

	return transforms;
}

- (NSArray*) getTheBasicPoints{
	sideLength = MIN(self.screenSize.width, self.screenSize.height)/3;
	id p0 = [NSValue valueWithCGPoint:CGPointZero];
	id p1 = [NSValue valueWithCGPoint:CGPointMake(sideLength, 0)];
	id p2 = [NSValue valueWithCGPoint:CGPointMake(sideLength/2, sideLength * 0.866)];
	return [[NSArray alloc] initWithObjects:p0, p1, p2, nil];
}

@end
