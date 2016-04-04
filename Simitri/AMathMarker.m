//
//  MathMarker.m
//  Simitri
//
//  Created by John on 13/06/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "AMathMarker.h"
#import "GeomUtils.h"
#import "TransformUtils.h"
#import "UIColor+Utils.h"

@implementation AMathMarker

+ (NSInteger) numDashesForLength:(float)len{
	NSInteger maxSize = 200;
	NSInteger minSize = 50;
	NSInteger dashesForMax = 18;
	NSInteger dashesForMin = 6;
	if(len < minSize){
		return dashesForMin;
	}
	else if(len > maxSize){
		return dashesForMax;
	}
	else{
		return (dashesForMin + ((len - minSize) / (maxSize - minSize))*(dashesForMax - dashesForMin));
	}
}

+ (UIColor*) colorForRef{
	return [AMathMarker colorForOrder:0];
}

+ (UIColor*) colorForOrder:(NSInteger)order{
	return [UIColor getGray:0.6 withAlpha:0.8];
}

+ (NSInteger) getDefaultRot2Radius{
	return 9;
}

+ (NSInteger) getDefaultLength{
	return 20;
}

+ (NSInteger) getDefaultArrowWidth{
	return 3;
}

+ (NSInteger) getDefaultRefThickness{
	return 3;
}

+ (NSInteger) getDefaultHeadLength{
	return 14;
}

+ (UIBezierPath*) getDashedArrow:(CGPoint) p withEnd:(CGPoint)endPoint withWidth:(float) width withHeadLength:(float)headLength{
	float len = [GeomUtils distFrom:p to:endPoint];
	CGPoint startEndVector = CGPointMake(endPoint.x - p.x, endPoint.y - p.y);
	CGPoint sideVector = CGPointMake(startEndVector.y, -startEndVector.x);
	CGPoint edgeVector = [GeomUtils makeLengthForVector:startEndVector toLength:(len - headLength)];
	sideVector = [GeomUtils makeLengthForVector:sideVector toLength:width];
	CGPoint v0 = CGPointMake(p.x + sideVector.x, p.y + sideVector.y);
	CGPoint v6 = CGPointMake(p.x - sideVector.x, p.y - sideVector.y);
	CGPoint v1 = CGPointMake(v0.x + edgeVector.x, v0.y + edgeVector.y);
	CGPoint v2 = CGPointMake(v1.x + sideVector.x, v1.y + sideVector.y);
	CGPoint v3 = endPoint;
	CGPoint v5 = CGPointMake(v6.x + edgeVector.x, v6.y + edgeVector.y);
	CGPoint v4 = CGPointMake(v5.x - sideVector.x, v5.y - sideVector.y);
	UIBezierPath* polygon = [AMathMarker dashedRectangleWithP0:v0 withP1:v1 withP3:v6];
	[polygon moveToPoint:v4];
	[polygon addLineToPoint:v2];
	[polygon addLineToPoint:v3];
	[polygon addLineToPoint:v4];
	return polygon;
}

+ (UIBezierPath*) dashedRectangleWithP0:(CGPoint)p0 withP1:(CGPoint)p1 withP3:(CGPoint)p3 {
	UIBezierPath* rects = [UIBezierPath bezierPath];
	float len = [GeomUtils distFrom:p0 to:p1];
	NSInteger num = [AMathMarker numDashesForLength:len];
	float d = len/num;
	CGPoint edge0 = [GeomUtils pointFrom:p0 towards:p1 withLength:d];
	CGPoint edgeVector = CGPointMake(edge0.x - p0.x, edge0.y - p0.y);
	CGPoint endVector = CGPointMake(p3.x - p0.x, p3.y - p0.y);
	for(int i = 1; i<=num; i++) {
		if(i%2 == 1){
			[rects moveToPoint:CGPointMake(p0.x + (i-1)*edgeVector.x, p0.y+(i-1)*edgeVector.y)];
			[rects addLineToPoint:CGPointMake(p0.x + i*edgeVector.x, p0.y+i*edgeVector.y)];
			[rects addLineToPoint:CGPointMake(p0.x + i*edgeVector.x + endVector.x, p0.y+i*edgeVector.y+endVector.y)];
			[rects addLineToPoint:CGPointMake(p0.x + (i-1)*edgeVector.x+ endVector.x, p0.y+(i-1)*edgeVector.y+ endVector.y)];
			[rects addLineToPoint:CGPointMake(p0.x + (i-1)*edgeVector.x, p0.y+(i-1)*edgeVector.y)];
		}
	}
	return rects;
}

+ (UIBezierPath*) getArrow:(CGPoint) p withEnd:(CGPoint)endPoint withWidth:(float) width withHeadLength:(float)headLength{
	UIBezierPath* polygon = [UIBezierPath bezierPath];
	float len = [GeomUtils distFrom:p to:endPoint];
	CGPoint startEndVector = CGPointMake(endPoint.x - p.x, endPoint.y - p.y);
	CGPoint sideVector = CGPointMake(startEndVector.y, -startEndVector.x);
	CGPoint edgeVector = [GeomUtils makeLengthForVector:startEndVector toLength:(len - headLength)];
	sideVector = [GeomUtils makeLengthForVector:sideVector toLength:width];
	CGPoint v0 = CGPointMake(p.x + sideVector.x, p.y + sideVector.y);
	CGPoint v1 = CGPointMake(v0.x + edgeVector.x, v0.y + edgeVector.y);
	CGPoint v2 = CGPointMake(v1.x + sideVector.x, v1.y + sideVector.y);
	CGPoint v3 = endPoint;
	CGPoint v4 = CGPointMake(p.x - sideVector.x, p.y - sideVector.y);
	CGPoint v5 = CGPointMake(v4.x + edgeVector.x, v4.y + edgeVector.y);
	CGPoint v6 = CGPointMake(v5.x - sideVector.x, v5.y - sideVector.y);
	[polygon moveToPoint:v0];
	[polygon addLineToPoint:v1];
	[polygon addLineToPoint:v2];
	[polygon addLineToPoint:v3];
	[polygon addLineToPoint:v6];
	[polygon addLineToPoint:v5];
	[polygon addLineToPoint:v4];
	[polygon addLineToPoint:v0];
	return polygon;
}

+ (AMathMarker*) getLineOfReflectionWithP0:(CGPoint) p0 withP1:(CGPoint)p1 withP3Angle:(float)p3Angle{
	CGPoint p3 = CGPointMake(p0.x + cos(p3Angle)*[AMathMarker getDefaultRefThickness], p0.y+ sin(p3Angle)*[AMathMarker getDefaultRefThickness]);
	AMathMarker* marker = [[AMathMarker alloc] init];
	marker.path = [AMathMarker dashedRectangleWithP0:p0 withP1:p1 withP3:p3];
	marker.color = [AMathMarker colorForRef];
	return marker;
}

+ (AMathMarker*) getTranslationWithOrigin:(CGPoint) p withP1:(CGPoint)p1 withMiddle:(CGPoint)middle withScale:(float)scale withMove:(BOOL)move{
	AMathMarker* marker = [[AMathMarker alloc] init];
	float dx = p1.x - p.x;
	float dy = p1.y - p.y;
	CGPoint middleVector = CGPointZero;
	if(move){
		middleVector = CGPointMake(middle.x - p.x, middle.y - p.y);
		middleVector = [GeomUtils makeLengthForVector:middleVector toLength:20];
	}
	CGPoint startPoint = CGPointMake(p.x -dx*scale + middleVector.x, p.y - dy*scale + middleVector.y);
	CGPoint endPoint = CGPointMake(p.x + dx*scale + middleVector.x , p.y + dy*scale + middleVector.y);
	marker.path = [AMathMarker getArrow:startPoint withEnd:endPoint withWidth:[AMathMarker getDefaultArrowWidth] withHeadLength:[AMathMarker getDefaultHeadLength]];
	marker.color = [AMathMarker colorForRef];
	return marker;
}

+ (AMathMarker*) getGlideRefWithOrigin:(CGPoint) p withP1:(CGPoint)p1 withMiddle:(CGPoint)middle withScale:(float)scale withMove:(BOOL)move{
	AMathMarker* marker = [[AMathMarker alloc] init];
	float dx = p1.x - p.x;
	float dy = p1.y - p.y;
	CGPoint middleVector = CGPointZero;
	if(move){
		middleVector = CGPointMake(middle.x - p.x, middle.y - p.y);
		middleVector = [GeomUtils makeLengthForVector:middleVector toLength:20];
	}
	CGPoint startPoint = CGPointMake(p.x -dx*scale + middleVector.x, p.y - dy*scale + middleVector.y);
	CGPoint endPoint = CGPointMake(p.x + dx*scale + middleVector.x , p.y + dy*scale + middleVector.y);
	marker.path = [AMathMarker getDashedArrow:startPoint withEnd:endPoint withWidth:[AMathMarker getDefaultArrowWidth] withHeadLength:[AMathMarker getDefaultHeadLength]];
	marker.color = [AMathMarker colorForRef];
	return marker;
}

+ (AMathMarker*) getRotOrder2CentrePolygonWithOrigin:(CGPoint) p withStartAngle:(float) theta0 andAngle:(float)angle andRadius:(float)radius{
	AMathMarker* marker = [[AMathMarker alloc] init];
	UIBezierPath* polygon = [UIBezierPath bezierPath];
	[polygon addArcWithCenter:p radius:radius startAngle:theta0 endAngle:theta0 + angle clockwise:YES];
	marker.path = polygon;
	marker.color = [AMathMarker colorForOrder:2];
	return marker;
}

+ (AMathMarker*) getRotOrder346CentrePolygonWithOrigin:(CGPoint) p withP1:(CGPoint)p1 andAngle:(float) theta andOrder:(NSInteger)order andLength:(NSInteger)len{
	AMathMarker* marker = [[AMathMarker alloc] init];
	UIBezierPath* polygon = [UIBezierPath bezierPath];
	CGPoint endPoint = [GeomUtils pointFrom:p towards:p1 withLength:len];
	[polygon moveToPoint:p];
	[polygon addLineToPoint:endPoint];
	CGAffineTransform r = [TransformUtils rotateAboutPoint:p angle:theta];
	[polygon addLineToPoint:CGPointApplyAffineTransform(endPoint, r)];
	[polygon addLineToPoint:p];
	marker.path = polygon;
	marker.color = [AMathMarker colorForOrder:order];
	return marker;
}

+ (AMathMarker*) getPartialRotCentrePolygonWithOrigin:(CGPoint) p withP1:(CGPoint)p1 andAngle:(float) theta andOrder:(int) order andLength:(NSInteger)len withFrac:(float)f{
	AMathMarker* marker = [[AMathMarker alloc] init];
	UIBezierPath* polygon = [UIBezierPath bezierPath];
	float angle0 = f*theta;
	float angle1 = (M_PI - theta)/2;
	float angle2 = M_PI - angle0 - angle1;
	float x = sin(angle1) * len / sin(angle2);
	CGPoint endPoint = [GeomUtils pointFrom:p towards:p1 withLength:len];
	[polygon moveToPoint:p];
	[polygon addLineToPoint:endPoint];
	CGAffineTransform r = [TransformUtils rotateAboutPoint:p angle:theta*f];
	[polygon addLineToPoint:[GeomUtils fracAlongLineFrom:p to:CGPointApplyAffineTransform(endPoint, r) withFrac:(x/len)]];
	[polygon addLineToPoint:p];
	marker.path = polygon;
	marker.color = [AMathMarker colorForOrder:order];
	return marker;
}

@end
