//
//  GeomUtils.m
//  Symmetry
//
//  Created by John on 23/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "GeomUtils.h"

@implementation GeomUtils

+ (BOOL) CGAffMatched:(CGAffineTransform) t0 with:(CGAffineTransform) t1{
	float tolerance = 0.01;
	float da = t0.a - t1.a;
	if(da<0){
		da = -da;
	}
	if(da > tolerance){
		return NO;
	}
	float db = t0.b - t1.b;
	if(db<0){
		db = -db;
	}
	if(db > tolerance){
		return NO;
	}
	float dc = t0.c - t1.c;
	if(dc<0){
		dc = -dc;
	}
	if(dc > tolerance){
		return NO;
	}
	float dd = t0.d - t1.d;
	if(dd<0){
		dd = -dd;
	}
	if(dd > tolerance){
		return NO;
	}
	float dtx = t0.tx - t1.tx;
	if(dtx<0){
		dtx = -dtx;
	}
	if(dtx > tolerance){
		return NO;
	}
	float dty = t0.ty - t1.ty;
	if(dty<0){
		dty = -dty;
	}
	if(dty > tolerance){
		return NO;
	}
	return YES;
}

+ (BOOL) pointMatched:(CGPoint) p0 with:(CGPoint) p1{
	float tolerance = 0.01;
	float dx = p0.x - p1.x;
	if(dx<0){
		dx*=-1;
	}
	if(dx > tolerance){
		return NO;
	}
	float dy = p0.y - p1.y;
	if(dy<0){
		dy*=-1;
	}
	if(dy > tolerance){
		return NO;
	}
	return YES;
}

+ (CGPoint) pointFrom:(CGPoint)p towards:(CGPoint) endPoint withLength:(float) len{
	float dx = endPoint.x - p.x;
	float dy = endPoint.y - p.y;
	float fullLen = sqrtf(dx*dx + dy*dy);
	float scale = len/fullLen;
	return CGPointMake(p.x + scale*dx, p.y + scale*dy);
}

+ (CGPoint) makeLengthForVector:(CGPoint)v toLength:(float)len{
	float oldLen = sqrtf(v.x*v.x + v.y*v.y);
	float scale = len/oldLen;
	return CGPointMake(scale*v.x, scale*v.y);
}

+ (int) getClosestTo:(CGPoint)p inArray:(NSArray*) array withTolerance:(float)tol{
	int index = -1;
	float minDistSqr = INFINITY;
	float distSqr;
	float dx;
	float dy;
	CGPoint test;
	for (int i = 0; i < array.count; i++) {
		test = [array[i] CGPointValue];
		dx = p.x - test.x;
		dy = p.y - test.y;
		distSqr = dx*dx + dy*dy;
		if(distSqr < tol && distSqr < minDistSqr){
			minDistSqr = distSqr;
			index = i;
		}
	}
	return index;
}

+ (CGPoint) fracAlongLineFrom:(CGPoint)p0 to:(CGPoint)p1 withFrac:(float)f{
	float dx = p1.x - p0.x;
	float dy = p1.y - p0.y;
	return CGPointMake(p0.x + f*dx, p0.y + f*dy);
}

+ (CGPoint) midPointOf:(CGPoint)p0 with:(CGPoint)p1{
	return [GeomUtils fracAlongLineFrom:p0 to:p1 withFrac:0.5];
}

+ (void) addCompTransforms:(CGAffineTransform) t followedBy:(CGAffineTransform) s followedBy:(CGAffineTransform)u into:(NSMutableArray*)array{
	[GeomUtils addTransform: CGAffineTransformConcat(t, CGAffineTransformConcat(s, u)) into:array];
}

+ (void) addCompTransforms:(CGAffineTransform) t followedBy:(CGAffineTransform) s followedBy:(CGAffineTransform)u followedBy:(CGAffineTransform)v into:(NSMutableArray*)array{
	[GeomUtils addTransform: CGAffineTransformConcat(t, CGAffineTransformConcat(s, CGAffineTransformConcat(u, v))) into:array];
}

+ (void) addCompTransforms:(CGAffineTransform) t followedBy:(CGAffineTransform) s followedBy:(CGAffineTransform)u followedBy:(CGAffineTransform)v followedBy:(CGAffineTransform)w into:(NSMutableArray*)array{
	[GeomUtils addTransform: CGAffineTransformConcat(t, CGAffineTransformConcat(s, CGAffineTransformConcat(u, CGAffineTransformConcat(v, w)))) into:array];
}


+ (void) addCompTransform:(CGAffineTransform) t followedBy:(CGAffineTransform) s into:(NSMutableArray*)array{
	[GeomUtils addTransform: CGAffineTransformConcat(t, s) into:array];
}

+ (void) addTransform:(CGAffineTransform) t into:(NSMutableArray*)array{
	[array addObject:[NSValue valueWithCGAffineTransform:t]];
}

+ (UIBezierPath*) demoUsWithCentre:(CGPoint)centre withSize:(float)d{
	d = d*0.75;
	UIBezierPath* path = [UIBezierPath bezierPath];
	[path addArcWithCenter:CGPointMake(centre.x , centre.y) radius:d startAngle:0 endAngle:2*M_PI clockwise:YES];
	[path moveToPoint:CGPointMake(centre.x + d, centre.y) ];
	[path addArcWithCenter:CGPointMake(centre.x + d/2 , centre.y) radius:d/2 startAngle:0 endAngle:1.25*M_PI clockwise:YES];
	
	return path;
}

+ (UIBezierPath*) demoLoopWithCentre:(CGPoint)centre withSize:(float)d{
	UIBezierPath* path = [UIBezierPath bezierPath];
	[path moveToPoint:CGPointMake(centre.x, centre.y + d)];
	[path addLineToPoint:CGPointMake(centre.x, centre.y - d)];
	[path addArcWithCenter:CGPointMake(centre.x, centre.y + d/2) radius:d/2 startAngle:-M_PI/2 endAngle:M_PI/2 clockwise:YES];
	return path;
}

+ (UIBezierPath*) demoStarWithCentre:(CGPoint)centre withSize:(float)d{
	UIBezierPath* path = [UIBezierPath bezierPath];
	float a = M_PI/8;
	for(int i = 0; i <= 4; i++){
		[path moveToPoint:centre];
		[path addQuadCurveToPoint:CGPointMake(centre.x + d*cosf(a*i), centre.y + d*sinf(a*i)) controlPoint:CGPointMake(centre.x + (d/2)*cosf(a*(i+2)), centre.y + (d/2)*sinf(a*(i+2)))];
	}
	return path;
}

+ (UIBezierPath*) demoSpiralWithCentre:(CGPoint)centre withSize:(float)d{
	UIBezierPath* path = [UIBezierPath bezierPath];
	CGPoint p = CGPointMake(centre.x, centre.y + d);
	[path moveToPoint:p];
	int dir = 0;
	CGPoint endPoint;
	CGPoint cPoint;
	for(int i = 1; i <= 7 ; i++){
		if(dir == 0){
			endPoint = CGPointMake(p.x + d, p.y - d);
			cPoint = CGPointMake(p.x + d, p.y);
		}
		else if(dir == 1){
			endPoint = CGPointMake(p.x - d, p.y - d);
			cPoint = CGPointMake(p.x, p.y - d);
		}
		else if(dir == 2){
			endPoint = CGPointMake(p.x - d, p.y + d);
			cPoint = CGPointMake(p.x - d, p.y);
		}
		else{
			endPoint = CGPointMake(p.x + d, p.y + d);
			cPoint = CGPointMake(p.x, p.y + d);
		}
		[path addQuadCurveToPoint:endPoint controlPoint:cPoint];
		p = endPoint;
		dir ++;
		d *= 0.85;
		if(dir == 4){
			dir = 0;
		}
	}
	return path;
}

+ (float) distFrom:(CGPoint) p0 to:(CGPoint) p1{
	float dx = p0.x - p1.x;
	float dy = p0.y - p1.y;
	return sqrtf(dx*dx + dy*dy);
}

+ (float) minDistLineFrom:(CGPoint)centre toLineWithP0:(CGPoint)p0 andP1:(CGPoint)p1{
	float minDist = INFINITY;
	int num = 25;
	for(int i = 0; i <= num; i++){
		float frac = (1.0*i)/(1.0*num);
		CGPoint p = [self fracAlongLineFrom:p0 to:p1 withFrac:frac];
		float d = [GeomUtils distFrom:centre to:p];
		if(d < minDist){
			minDist = d;
		}
	}
	return minDist;
}

+ (UIBezierPath*) demoAnglesWithCentre:(CGPoint)centre withSize:(float)d{
	float a = M_PI*45/180;
	float w = d*cosf(a);
	float h = d*sinf(a);;
	CGRect r = CGRectMake(centre.x - w, centre.y - h, 2*w, 2*h);
	CGRect r2 = CGRectMake(r.origin.x, r.origin.y, r.size.width/2.5, r.size.height/2.5);
	UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:r cornerRadius:10];
	UIBezierPath* path1 = [UIBezierPath bezierPathWithRoundedRect:r2 cornerRadius:10];
	[path appendPath:path1];
	return path;
}

+ (CGRect) getFrameForImageWidth:(float) w andHeight:(float)h inRect:(CGSize)size{
	float ratio = size.width/size.height;
	float imageRatio = w/h;
	float scaleFactor;
	CGRect imageFrame;
	if(ratio > imageRatio){
		scaleFactor = size.height / h;
		float dx = (size.width - w * scaleFactor)/2;
		imageFrame = CGRectMake(dx, 0, w * scaleFactor, size.height);
	}
	else{
		scaleFactor = size.width / w;
		float dy = (size.height - h * scaleFactor)/2;
		imageFrame = CGRectMake(0, dy, size.width, h * scaleFactor);
	}
	return imageFrame;
}

@end
