//
//  MatrixUtils.h
//  Symmetry
//
//  Created by John on 21/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Polygon.h"

@interface TransformUtils : NSObject

+ (CGAffineTransform) reflectInLineWithAngle:(float) theta withC:(float) c;
+ (CGAffineTransform) reflectInHorizontalLineWithC:(float) c;
+ (CGAffineTransform) reflectInVerticalLineWithA:(float) a;
+ (CGAffineTransform) reflectInLineWithAngle:(float) theta withC:(float) c withScale:(float)s;
+ (CGAffineTransform) reflectInHorizontalLineWithC:(float) c withScale:(float)s;
+ (CGAffineTransform) reflectInVerticalLineWithA:(float) a withScale:(float)s;
+ (CGAffineTransform) rotateAboutPoint:(CGPoint)p angle:(float)aRad;
+ (CGAffineTransform) translateBy:(CGPoint)p;
+ (CATransform3D) reflectIn3DLineThrough:(CGPoint)p0 inDirection:(float)dir atAngle:(float) angle;
+ (CATransform3D) rotate3DAboutPoint:(CGPoint)centre  withAngle:(float) angle;

@end
