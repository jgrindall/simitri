#import "Drawer_P1_O.h"
#import "ADrawer_Protected.h"
#import "TransformUtils.h"
#import "DisplayUtils.h"
#import "AMathMarker.h"
#import "GeomUtils.h"

@implementation Drawer_P1_O
{
	float sideWidth;
	float sideHeight;
}

- (CGRect) getBasicRectangle{
	return CGRectMake(0, 0, 2*sideWidth, 2*sideHeight);
}

- (TransformPair*) getMathTransformForIndex:(NSInteger) i withCentre:(CGPoint) centre atTime:(float)t{
	CGAffineTransform cg = CGAffineTransformIdentity;
	CATransform3D ca = CATransform3DIdentity;
	if(i <= 6) {
		cg = [TransformUtils translateBy:CGPointMake(sideWidth * t, 0)];
	}
	else{
		cg =  [TransformUtils translateBy:CGPointMake(sideWidth * t/2, sideHeight * t)];
	}
	return [[TransformPair alloc] initWithCA:ca withCG:cg];
}

- (NSArray*) getMathTransformBasicCentres{
	NSMutableArray* centres = [NSMutableArray array];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth/2, 0)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(3*sideWidth/2, 0)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(0, sideHeight)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth, sideHeight)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(2*sideWidth, sideHeight)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth/2, 2*sideHeight)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(3*sideWidth/2, 2*sideHeight)]];
	
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(sideWidth/4, sideHeight/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(5*sideWidth/4, sideHeight/2)]];
	
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(3*sideWidth/4, 3*sideHeight/2)]];
	[centres addObject:[NSValue valueWithCGPoint:CGPointMake(7*sideWidth/4, 3*sideHeight/2)]];
	
	return [centres copy];
}

- (NSArray*) getBasicMathMarkers{
	NSMutableArray* polys = [NSMutableArray array];
	[polys addObject:[AMathMarker getTranslationWithOrigin:CGPointMake(sideWidth/2, 0) withP1:CGPointMake(sideWidth, 0) withMiddle:CGPointMake(3*sideWidth/2, sideHeight/2) withScale:0.5 withMove:YES]];
	[polys addObject:[AMathMarker getTranslationWithOrigin:CGPointMake(3*sideWidth/2, 0) withP1:CGPointMake(2*sideWidth, 0) withMiddle:CGPointMake(5*sideWidth/2, sideHeight/2) withScale:0.5 withMove:YES]];
	
	[polys addObject:[AMathMarker getTranslationWithOrigin:CGPointMake(sideWidth/4, sideHeight/2) withP1:CGPointMake(sideWidth/2, sideHeight) withMiddle:CGPointMake(3*sideWidth/2, sideHeight/2) withScale:0.5 withMove:YES]];
	[polys addObject:[AMathMarker getTranslationWithOrigin:CGPointMake(5*sideWidth/4, sideHeight/2) withP1:CGPointMake(3*sideWidth/2, sideHeight) withMiddle:CGPointMake(5*sideWidth/2, sideHeight/2) withScale:0.5 withMove:YES]];
	
	return polys;
}

- (NSArray*) getTransformations{
	CGAffineTransform t0 = [TransformUtils translateBy:CGPointMake(sideWidth, 0)];
	CGAffineTransform t1 = [TransformUtils translateBy:CGPointMake(-sideWidth, 0)];
	CGAffineTransform t2 = [TransformUtils translateBy:CGPointMake(-sideWidth/2, sideHeight)];
	CGAffineTransform t3 = [TransformUtils translateBy:CGPointMake(sideWidth/2, sideHeight)];
	CGAffineTransform t4 = [TransformUtils translateBy:CGPointMake(3*sideWidth/2, sideHeight)];
	NSMutableArray* transforms = [NSMutableArray array];
	[GeomUtils addTransform:CGAffineTransformIdentity into:transforms];
	[GeomUtils addTransform:t0 into:transforms];
	[GeomUtils addTransform:t1 into:transforms];
	[GeomUtils addTransform:t2 into:transforms];
	[GeomUtils addTransform:t3 into:transforms];
	[GeomUtils addTransform:t4 into:transforms];
	return transforms;
}

- (NSArray*) getTheBasicPoints{
	float min = MIN(self.screenSize.width, self.screenSize.height);
	float max = MAX(self.screenSize.width, self.screenSize.height);
	sideWidth = min/4.0;
	sideHeight = max/5.0;
	id p0 = [NSValue valueWithCGPoint:CGPointZero];
	id p1 = [NSValue valueWithCGPoint:CGPointMake(sideWidth, 0)];
	id p2 = [NSValue valueWithCGPoint:CGPointMake(3*sideWidth/2.0, sideHeight)];
	id p3 = [NSValue valueWithCGPoint:CGPointMake(sideWidth/2.0, sideHeight)];
	return [[NSArray alloc] initWithObjects:p0, p1, p2, p3, nil];
}

@end
