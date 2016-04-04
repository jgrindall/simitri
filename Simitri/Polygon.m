//
//  Polygon.m
//  PathRect
//
//  Created by John on 22/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "Polygon.h"
#import "GeomUtils.h"

@implementation Polygon

- (id) initWithPoints:(NSArray*) points{
	self = [super init];
	if(self){
		_points = points;
	}
	return self;
}

- (BOOL) hasVertex:(CGPoint) point{
	for (int i = 0; i<self.points.count ; i++) {
		if([GeomUtils pointMatched:[self getPoint:i] with:point]){
			return YES;
		}
	}
	return NO;
}

- (BOOL) containsPoint:(CGPoint) point{
	UIBezierPath* path = [self toBezPath];
	return [self hasVertex:point] || CGPathContainsPoint(path.CGPath, NULL, point, YES);
}

- (float) getInRadius{
	CGPoint centre = [self getCOM];
	float minDist = INFINITY;
	for(int i = 0; i < self.points.count ;i++){
		CGPoint p0 = [self getPoint:i];
		CGPoint p1 = [self getPoint:(i+1)];
		float d = [GeomUtils minDistLineFrom:centre toLineWithP0:p0 andP1:p1];
		if(d < minDist){
			minDist = d;
		}
	}
	return minDist;
}

- (CGPoint) getCOM{
	float sumX = 0;
	float sumY = 0;
	NSInteger num = self.points.count;
	for(int i = 0; i<=num - 1;i++){
		CGPoint p = [self getPoint:i];
		sumX += p.x;
		sumY += p.y;
	}
	return CGPointMake(sumX/num, sumY/num);
}

- (UIBezierPath*) toBezPath{
	UIBezierPath* path = [UIBezierPath bezierPath];
	CGPoint p0 = [self getPoint:0];
	[path moveToPoint:p0];
	for(int i = 1; i<self.points.count ;i++){
		CGPoint p = [self getPoint:i];
		[path addLineToPoint:p];
	}
	[path addLineToPoint:p0];
	return path;
}

- (CGPoint) getPoint:(int) i{
	while(i<0){
		i += self.points.count;
	}
	i = i % self.points.count;
	return [self.points[i] CGPointValue];
}

- (NSString*) description{
	return [NSString stringWithFormat:@"POLY: %@", self.points];
}

- (Polygon*) applyTransform:(CGAffineTransform) t{
	NSMutableArray* array = [NSMutableArray array];
	for(int i = 0; i<self.points.count ;i++){
		CGPoint p = [self getPoint:i];
		CGPoint newPoint = CGPointApplyAffineTransform(p, t);
		[array addObject:[NSValue valueWithCGPoint:newPoint]];
	}
	return [[Polygon alloc] initWithPoints:[array copy]];
}

@end
