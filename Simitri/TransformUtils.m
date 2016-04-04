//
//  MatrixUtils.m
//  Symmetry
//
//  Created by John on 21/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "TransformUtils.h"

@implementation TransformUtils

//http://www.cimt.plymouth.ac.uk/projects/mepres/alevel/fpure_ch9.pdf

//http://wiki.inkscape.org/wiki/images/WallpaperTransformations.png

+ (CGAffineTransform) reflectInLineWithAngle:(float) theta withC:(float) c{
	return [TransformUtils reflectInLineWithAngle:theta withC:c withScale:1];
}

+ (CGAffineTransform) reflectInHorizontalLineWithC:(float) c{
	return [TransformUtils reflectInHorizontalLineWithC:c withScale:1];
}

+ (CGAffineTransform) reflectInVerticalLineWithA:(float) a{
	return [TransformUtils reflectInVerticalLineWithA:a withScale:1];
}

+ (CGAffineTransform) reflectInLineWithAngle:(float) theta withC:(float) cInter withScale:(float)scale{
	float min = 0.15;
	if(scale >= 0 && scale < min){
		scale = min;
	}
	if(scale <= 0 && scale > -min){
		scale = -min;
	}
	float c = cos(theta);
	float s = sin(theta);
	float m = 1 + scale;
	CGAffineTransform move = CGAffineTransformMakeTranslation(0, -cInter);
	CGAffineTransform reflect = CGAffineTransformMake(1 - m*s*s , s*c*m, s*c*m, 1 - m*c*c, 0, 0);
	CGAffineTransform moveBack = CGAffineTransformInvert(move);
	return CGAffineTransformConcat(CGAffineTransformConcat(move, reflect), moveBack);
}

+ (CGAffineTransform) reflectInHorizontalLineWithC:(float) c withScale:(float)s{
	CGAffineTransform move = CGAffineTransformMakeTranslation(0, -c);
	CGAffineTransform reflect = CGAffineTransformMake(1, 0, 0, -s, 0, 0);
	CGAffineTransform moveBack = CGAffineTransformInvert(move);
	return CGAffineTransformConcat(CGAffineTransformConcat(move, reflect), moveBack);
}

+ (CGAffineTransform) reflectInVerticalLineWithA:(float) a withScale:(float)s{
	CGAffineTransform move = CGAffineTransformMakeTranslation(-a, 0);
	CGAffineTransform reflect = CGAffineTransformMakeScale(-s, 1);
	CGAffineTransform moveBack = CGAffineTransformInvert(move);
	return CGAffineTransformConcat(CGAffineTransformConcat(move, reflect), moveBack);
}

+ (CGAffineTransform) rotateAboutPoint:(CGPoint)p angle:(float)aRad{
	CGAffineTransform move = CGAffineTransformMakeTranslation(-p.x, -p.y);
	CGAffineTransform rotate = CGAffineTransformMakeRotation(aRad);
	CGAffineTransform moveBack = CGAffineTransformInvert(move);
	return CGAffineTransformConcat(CGAffineTransformConcat(move, rotate), moveBack);
}

+ (CGAffineTransform) translateBy:(CGPoint)p{
	return CGAffineTransformMakeTranslation(p.x, p.y);
}

+ (CATransform3D) reflectIn3DLineThrough:(CGPoint)p0 inDirection:(float)dir atAngle:(float) angle{
	CATransform3D move = CATransform3DMakeTranslation(-p0.x, -p0.y, 0);
	CATransform3D moveBack = CATransform3DMakeTranslation(p0.x, p0.y, 0);
	CATransform3D rot = CATransform3DMakeRotation(angle, cos(dir), sin(dir), 0);
	return CATransform3DConcat(CATransform3DConcat(move, rot), moveBack);
}

+ (CATransform3D) rotate3DAboutPoint:(CGPoint)p0 withAngle:(float) angle{
	CATransform3D move = CATransform3DMakeTranslation(-p0.x, -p0.y, 0);
	CATransform3D moveBack = CATransform3DMakeTranslation(p0.x, p0.y, 0);
	CATransform3D rot = CATransform3DMakeRotation(angle, 0, 0, 1);
	return CATransform3DConcat(CATransform3DConcat(move, rot), moveBack);
}


@end
