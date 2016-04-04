
#import "Drawer_P6M_r236.h"
#import "ADrawer_Protected.h"
#import "TransformUtils.h"
#import "DisplayUtils.h"
#import "AMathMarker.h"
#import "GeomUtils.h"

@implementation Drawer_P6M_r236
{
	float sideLength;
	float sideWidth;
	float hypot;
}

- (CGRect) getBasicRectangle{
	return CGRectMake(0, 0, 2*(hypot + sideWidth), 2*sideLength);
}

- (TransformPair*) getMathTransformForIndex:(NSInteger) i withCentre:(CGPoint) centre atTime:(float)t{
	CGAffineTransform cg = CGAffineTransformIdentity;
	CATransform3D ca = CATransform3DIdentity;
	if(i <= 5) {
		ca = [TransformUtils reflectIn3DLineThrough:centre inDirection:0 atAngle:t*M_PI];
	}
	else if(i<=11){
		ca = [TransformUtils reflectIn3DLineThrough:centre inDirection:M_PI/2 atAngle:t*M_PI];
	}
	else if(i<=17){
		ca = [TransformUtils reflectIn3DLineThrough:centre inDirection:0 atAngle:t*M_PI];
	}
	else if(i<=21){
		ca = [TransformUtils reflectIn3DLineThrough:centre inDirection:-M_PI/6 atAngle:t*M_PI];
	}
	else if(i<=25){
		ca = [TransformUtils reflectIn3DLineThrough:centre inDirection:M_PI/6 atAngle:t*M_PI];
	}
	else if(i<=29){
		ca = [TransformUtils reflectIn3DLineThrough:centre inDirection:-M_PI/3 atAngle:t*M_PI];
	}
	else if(i<=33){
		ca = [TransformUtils reflectIn3DLineThrough:centre inDirection:M_PI/3 atAngle:t*M_PI];
	}
	else if(i<=37){
		ca = [TransformUtils reflectIn3DLineThrough:centre inDirection:M_PI/3 atAngle:t*M_PI];
	}
	else{
		ca = [TransformUtils reflectIn3DLineThrough:centre inDirection:-M_PI/3 atAngle:t*M_PI];
	}
	return [[TransformPair alloc] initWithCA:ca withCG:cg is3d:YES];
}

- (NSArray*) getMathTransformBasicCentres{
	NSMutableArray* centres = [NSMutableArray array];
	// short horiz
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth/2, 0)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth/2, 2*sideLength)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth + hypot - sideWidth/2, sideLength)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth + hypot + sideWidth/2, sideLength)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(2*(sideWidth + hypot) - sideWidth/2, 0)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(2*(sideWidth + hypot) - sideWidth/2, 2*sideLength)]];
	// long vert
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(0, sideLength/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(0, 3*sideLength/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth+hypot, sideLength/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth+hypot, 3*sideLength/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(2*(sideWidth+hypot), sideLength/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(2*(sideWidth+hypot), 3*sideLength/2)]];
	// long horiz
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth+hypot/2, 0)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth+3*hypot/2, 0)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(hypot/2, sideLength)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(2*sideWidth+3*hypot/2, sideLength)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth+hypot/2, 2*sideLength)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth+3*hypot/2, 2*sideLength)]];
	// -30 deg
	float gx = sideLength*sqrtf(3.0)/4;
	float gy = sideLength/4;
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(gx, sideLength - gy)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth + hypot - gx, gy)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth + hypot + gx, 2*sideLength - gy)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(2*(sideWidth + hypot) - gx, sideLength + gy)]];
	//
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(gx, sideLength + gy)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth + hypot - gx, 2*sideLength - gy)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth + hypot + gx, gy)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(2*(sideWidth + hypot) - gx, sideLength - gy)]];
	//
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(gy, gx)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth + hypot - gy, gx)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth + hypot + gy, 2*sideLength - gx)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(2*(sideWidth + hypot) - gy, 2*sideLength - gx)]];
	//
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth + hypot + gy, gx)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(2*(sideWidth + hypot) - gy, gx)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(gy, 2*sideLength - gx)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth + hypot - gy, 2*sideLength - gx)]];
	//here
	float bx = sideWidth / 2;
	float by = sideWidth * sqrtf(3.0)/2;
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth + bx/2, by/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth + 3*bx/2, 3*by/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(hypot + 2*sideWidth + bx/2, sideLength + by/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(hypot + 3*sideWidth + bx/2, sideLength + 3*by/2)]];
	//
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth + bx/2, 2*sideLength - by/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth + 3*bx/2, 2*sideLength - 3*by/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(hypot + 2*sideWidth + bx/2, sideLength - by/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(hypot + 3*sideWidth + bx/2, by/2)]];
	return [centres copy];
}

- (NSArray*) getBasicMathMarkers{
	NSMutableArray* polys = [NSMutableArray array];
	[polys addObject:[AMathMarker getLineOfReflectionWithP0:CGPointZero withP1:CGPointMake(sideWidth, 0) withP3Angle:M_PI/2]];
	[polys addObject:[AMathMarker getLineOfReflectionWithP0:CGPointZero withP1:CGPointMake(0, sideLength) withP3Angle:0]];
	[polys addObject:[AMathMarker getLineOfReflectionWithP0:CGPointMake(sideWidth, 0) withP1:CGPointMake(0, sideLength) withP3Angle:7*M_PI/6]];
	return polys;
}

- (NSArray*) getTransformations{
	CGAffineTransform h = [TransformUtils reflectInHorizontalLineWithC:sideLength];
	CGAffineTransform v = [TransformUtils reflectInVerticalLineWithA:(hypot + sideWidth)];
	
	CGAffineTransform t0 = [TransformUtils reflectInLineWithAngle:-M_PI/3 withC:sideLength];
	CGAffineTransform t1 = [TransformUtils reflectInLineWithAngle:-M_PI/3 withC:3*sideLength];
	CGAffineTransform t2 = [TransformUtils reflectInLineWithAngle:-M_PI/6 withC:sideLength];
	CGAffineTransform t3 = [TransformUtils reflectInLineWithAngle:M_PI/3 withC:-sideLength];
	
	NSMutableArray* transforms = [NSMutableArray array];
	[GeomUtils addTransform:CGAffineTransformIdentity into:transforms];
	[GeomUtils addTransform:t0 into:transforms];
	[GeomUtils addCompTransform:t0 followedBy:t3 into:transforms];
	[GeomUtils addCompTransform:t0 followedBy:t2 into:transforms];
	[GeomUtils addCompTransforms:t0 followedBy:t2 followedBy:t3 into:transforms];
	[GeomUtils addCompTransforms:t0 followedBy:t2 followedBy:t3 followedBy:t1 into:transforms];
	
	[GeomUtils addCompTransform:[transforms[0] CGAffineTransformValue] followedBy:h into:transforms];
	[GeomUtils addCompTransform:[transforms[1] CGAffineTransformValue] followedBy:h into:transforms];
	[GeomUtils addCompTransform:[transforms[2] CGAffineTransformValue] followedBy:h into:transforms];
	[GeomUtils addCompTransform:[transforms[3] CGAffineTransformValue] followedBy:h into:transforms];
	[GeomUtils addCompTransform:[transforms[4] CGAffineTransformValue] followedBy:h into:transforms];
	[GeomUtils addCompTransform:[transforms[5] CGAffineTransformValue] followedBy:h into:transforms];
	
	[GeomUtils addCompTransform:[transforms[0] CGAffineTransformValue] followedBy:v into:transforms];
	[GeomUtils addCompTransform:[transforms[1] CGAffineTransformValue] followedBy:v into:transforms];
	[GeomUtils addCompTransform:[transforms[2] CGAffineTransformValue] followedBy:v into:transforms];
	[GeomUtils addCompTransform:[transforms[3] CGAffineTransformValue] followedBy:v into:transforms];
	[GeomUtils addCompTransform:[transforms[4] CGAffineTransformValue] followedBy:v into:transforms];
	[GeomUtils addCompTransform:[transforms[5] CGAffineTransformValue] followedBy:v into:transforms];
	
	[GeomUtils addCompTransforms:[transforms[0] CGAffineTransformValue] followedBy:h followedBy:v into:transforms];
	[GeomUtils addCompTransforms:[transforms[1] CGAffineTransformValue] followedBy:h followedBy:v into:transforms];
	[GeomUtils addCompTransforms:[transforms[2] CGAffineTransformValue] followedBy:h followedBy:v into:transforms];
	[GeomUtils addCompTransforms:[transforms[3] CGAffineTransformValue] followedBy:h followedBy:v into:transforms];
	[GeomUtils addCompTransforms:[transforms[4] CGAffineTransformValue] followedBy:h followedBy:v into:transforms];
	[GeomUtils addCompTransforms:[transforms[5] CGAffineTransformValue] followedBy:h followedBy:v into:transforms];
	
	return transforms;
}

- (NSArray*) getTheBasicPoints{
	float min = MIN(self.screenSize.width, self.screenSize.height);
	sideLength = min*sqrtf(3.0)/6;
	sideWidth = sideLength / sqrtf(3);
	hypot = hypotf(sideWidth, sideLength);
	id p0 = [NSValue valueWithCGPoint:CGPointZero];
	id p1 = [NSValue valueWithCGPoint:CGPointMake(sideWidth, 0)];
	id p2 = [NSValue valueWithCGPoint:CGPointMake(0, sideLength)];
	return [[NSArray alloc] initWithObjects:p0, p1, p2, nil];
}

@end
